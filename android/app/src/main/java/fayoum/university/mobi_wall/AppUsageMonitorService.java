package fayoum.university.mobi_wall;

import android.app.ActivityManager;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.Service;
import android.app.admin.DevicePolicyManager;
import android.app.usage.UsageStats;
import android.app.usage.UsageStatsManager;
import android.content.ComponentName;
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
        stopAppUsageMonitoring();
        System.out.println("AppUsageMonitorService started");
        handler.postDelayed(new Runnable() {
            @Override
            public void run() {
                String currentApp = checkForBlockedApps();
                Log.d(TAG, "Current App Package: " + currentApp);
                handler.postDelayed(this, 5000); // Run every 5 second
            }
        }, 0);
    }

    private void stopAppUsageMonitoring() {
        System.out.println("Trying to stop app usage monitor service");
        try {
            handler.removeCallbacksAndMessages(null);
            stopForeground(true);
        } catch (Exception e) {
            Log.e(TAG, "error while stopping app usage monitor service = " + e);
        }
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }


    private String checkForBlockedApps() {
        Set<String> blockedApps = getBlockedApps();
        String foregroundApp = "";
        ActivityManager am = (ActivityManager) getSystemService(Context.ACTIVITY_SERVICE);
        List<ActivityManager.RunningAppProcessInfo> processes = am.getRunningAppProcesses();
        for (ActivityManager.RunningAppProcessInfo process : processes) {
            System.out.println("process = " + process.pkgList[0]);
            if (process.importance == ActivityManager.RunningAppProcessInfo.IMPORTANCE_FOREGROUND) {
                String packageName = process.pkgList[0];
                foregroundApp = packageName;
                if (blockedApps.contains(packageName)) {
                    blockApp();
                }
            }
        }
        return foregroundApp;
    }

    private Set<String> getBlockedApps() {
        SharedPreferences sharedPref1 = getSharedPreferences("cachedBlockedApps", 0);
        return sharedPref1.getStringSet("blockedApps", new HashSet<>());
    }

    private void blockApp() {
        Intent intent = new Intent(AppUsageMonitorService.this, BlockingActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        startActivity(intent);
    }

//    private String getForegroundApp(Context context) {
//
//        String foregroundApp = "";
//        SharedPreferences sharedPref1 = getSharedPreferences("cachedBlockedApps", 0);
//        Set<String> set = new HashSet<>();
//        set = sharedPref1.getStringSet("blockedApps", new HashSet<>());
//
//        long endTime = System.currentTimeMillis();
//        long startTime = endTime - 10000; // Look for app usage in the last 10 seconds
//
//        UsageStatsManager usageStatsManager = (UsageStatsManager) context.getSystemService(Context.USAGE_STATS_SERVICE);
//        List<UsageStats> usageStatsList = usageStatsManager.queryUsageStats(UsageStatsManager.INTERVAL_BEST, startTime, endTime);
//        if (usageStatsList != null && !usageStatsList.isEmpty()) {
//            SortedMap<Long, UsageStats> sortedMap = new TreeMap<>();
//            for (UsageStats usageStats : usageStatsList) {
//
//                sortedMap.put(usageStats.getLastTimeUsed(), usageStats);
//            }
//            if (!sortedMap.isEmpty()) {
//                foregroundApp = sortedMap.get(sortedMap.lastKey()).getPackageName();
//            }
//        }
//
//        if (set.contains(foregroundApp) || foregroundApp.contains("youtube")) {
//            System.out.println("trying to open mobiwall app");
//
//
//            Intent intent = new Intent(AppUsageMonitorService.this, BlockingActivity.class);
//            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
//            startActivity(intent);
//
//
//        }
//
//        return foregroundApp;
//    }


//    private void launchApp() {
//        try {
//
//            Intent launchIntent = getPackageManager().getLaunchIntentForPackage(this.getPackageName());
////            Intent launchIntent = new Intent(this, BlockingActivity.class);
//            System.out.println("intent != null");
//            launchIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
//            AppUsageMonitorService.this.startActivity(launchIntent);
//        } catch (Exception e) {
//            System.out.println("error while launching app = " + e);
//        }
//    }  

private Notification createNotification() {
        Intent notificationIntent = new Intent(this, MainActivity.class); // Replace YourActivity with your desired activity
        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0, notificationIntent, PendingIntent.FLAG_IMMUTABLE);

        NotificationCompat.Builder builder = new NotificationCompat.Builder(this, "CHANNEL_ID")
                .setContentTitle("App Usage Monitor")
                .setContentText("Monitoring app usage")
                .setSmallIcon(R.drawable.ic_notification)
                .setColor(getResources().getColor(R.color.primary_color))
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

/*

//            SharedPreferences sharedPref = getApplicationContext().getSharedPreferences(MainActivity.PREFS_NAME, 0);
//            SharedPreferences.Editor editor = sharedPref.edit();
//            editor.putBoolean("locked", true).apply();
//            launchApp();

//            ActivityManager am = (ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);
//            Intent startMain = new Intent(Intent.ACTION_MAIN);
//            startMain.addCategory(Intent.CATEGORY_HOME);
//            startMain.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
//            this.startActivity(startMain);
//            am.killBackgroundProcesses(foregroundApp);

//            ComponentName adminComponent = new ComponentName(this, MyDeviceAdminReceiver.class);
//            System.out.println("admin component = " + adminComponent);
//            DevicePolicyManager dpm = (DevicePolicyManager) getSystemService(Context.DEVICE_POLICY_SERVICE);
//            dpm.setApplicationHidden(adminComponent, foregroundApp, true);

 */