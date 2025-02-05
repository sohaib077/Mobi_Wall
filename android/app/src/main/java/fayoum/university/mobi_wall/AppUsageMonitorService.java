package fayoum.university.mobi_wall;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.Service;
import android.app.usage.UsageStats;
import android.app.usage.UsageStatsManager;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Build;
import android.os.Handler;
import android.os.IBinder;
import android.os.Looper;
import android.util.Log;
import androidx.annotation.Nullable;
import java.util.HashSet;
import java.util.List;
import android.app.Notification;
import android.app.PendingIntent;
import androidx.core.app.NotificationCompat;
import java.util.Set;
import java.util.SortedMap;
import java.util.TreeMap;


public class AppUsageMonitorService extends Service {

    private static final String TAG = "AppUsageMonitorService";
    private static final int NOTIFICATION_ID = 12345;
    private Handler handler;

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        System.out.println("AppUsageMonitorService started");
        handler = new Handler(Looper.getMainLooper());
        startAppUsageMonitoring();
        startForeground(NOTIFICATION_ID, createNotification());
        return START_STICKY;
    }

    @Override
    public void onDestroy() {
        stopAppUsageMonitoring();
        super.onDestroy();
    }

    private void startAppUsageMonitoring() {
        handler.postDelayed(new Runnable() {
            @Override
            public void run() {
                String currentApp = getForegroundApp(getApplicationContext());
                Log.d(TAG, "Current App Package: " + currentApp);
                handler.postDelayed(this, 1000); // Run every 1 second
            }
        }, 0);
    }

    private void stopAppUsageMonitoring() {
        handler.removeCallbacksAndMessages(null);
        stopForeground(true);
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    private String getForegroundApp(Context context) {

        String foregroundApp = "";
        SharedPreferences sharedPref1 = getSharedPreferences("cachedBlockedApps", 0);
        Set<String> set = new HashSet<>();
        set = sharedPref1.getStringSet("blockedApps", new HashSet<>());

            long endTime = System.currentTimeMillis();
            long startTime = endTime - 10000; // Look for app usage in the last 10 seconds

            UsageStatsManager usageStatsManager = (UsageStatsManager) context.getSystemService(Context.USAGE_STATS_SERVICE);
            List<UsageStats> usageStatsList = usageStatsManager.queryUsageStats(UsageStatsManager.INTERVAL_BEST, startTime, endTime);
            if (usageStatsList != null && !usageStatsList.isEmpty()) {
                SortedMap<Long, UsageStats> sortedMap = new TreeMap<>();
                for (UsageStats usageStats : usageStatsList) {
                    sortedMap.put(usageStats.getLastTimeUsed(), usageStats);
                }
                if (!sortedMap.isEmpty()) {
                    foregroundApp = sortedMap.get(sortedMap.lastKey()).getPackageName();
                }
            }
        if (set.contains(foregroundApp)) {
            System.out.println("trying to open mobiwall app");

            SharedPreferences sharedPref = getApplicationContext().getSharedPreferences(MainActivity.PREFS_NAME, 0);
            SharedPreferences.Editor editor = sharedPref.edit();
            editor.putBoolean("locked", true).apply();
            launchApp(context, "fayoum.university.mobi_wall");
        }

        return foregroundApp;
    }


    private void launchApp(Context context, String packageName) {

        Intent launchIntent = getPackageManager().getLaunchIntentForPackage(packageName);

        if (launchIntent != null) {
            launchIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            context.startActivity(launchIntent);
//        stopSelf(); // Stop the service after launching the app
        } else {
            Log.e(TAG, "Unable to launch app. Package name: " + packageName);
        }
    }


    private Notification createNotification() {
        Intent notificationIntent = new Intent(this, MainActivity.class); // Replace YourActivity with your desired activity
        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0, notificationIntent, PendingIntent.FLAG_IMMUTABLE);

        NotificationCompat.Builder builder = new NotificationCompat.Builder(this, "CHANNEL_ID")
                .setContentTitle("App Usage Monitor")
                .setContentText("Monitoring app usage")
                .setSmallIcon(R.mipmap.ic_launcher)
                .setContentIntent(pendingIntent);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel channel = new NotificationChannel("CHANNEL_ID", "App Usage Monitor", NotificationManager.IMPORTANCE_LOW);
            NotificationManager notificationManager = getSystemService(NotificationManager.class);
            if (notificationManager != null) {
                notificationManager.createNotificationChannel(channel);
            }
        }

        return builder.build();
    }
}
