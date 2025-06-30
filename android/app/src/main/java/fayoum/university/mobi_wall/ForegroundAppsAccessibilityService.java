package fayoum.university.mobi_wall;

import android.accessibilityservice.AccessibilityService;
import android.accessibilityservice.AccessibilityServiceInfo;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Build;
import android.os.Bundle;
import android.provider.Settings;
import android.view.accessibility.AccessibilityEvent;
import android.util.Log;
import android.view.accessibility.AccessibilityManager;
import android.view.accessibility.AccessibilityNodeInfo;

import androidx.core.app.NotificationCompat;

import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class ForegroundAppsAccessibilityService extends AccessibilityService {

    private static final String TAG = "ForegroundAppService";
    private static final String CHANNEL_ID = "accessibility_service_channel";
    private static final int NOTIFICATION_ID = 6789;

    @Override
    public void onCreate() {
        super.onCreate();
        startForeground(NOTIFICATION_ID, createNotification());
    }

    @Override
    protected void onServiceConnected() {
        super.onServiceConnected();
        Log.d(TAG, "AccessibilityService connected");
    }

//    @Override
//    public int onStartCommand(Intent intent, int flags, int startId) {
//        startForeground(NOTIFICATION_ID, createNotification());
//        return super.onStartCommand(intent, flags, startId);
//    }

    @Override
    public void onAccessibilityEvent(AccessibilityEvent event) {

        if (event.getEventType() == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) {
            String packageName = event.getPackageName().toString();
            if (getBlockedApps().contains(packageName) || packageName.contains("apps.youtube.music")) {
                blockApp();
                Log.e(TAG, "Current Blocked Foreground App: " + packageName);
            } else {
                Log.d(TAG, "Current Foreground App: " + packageName);
            }
        }

//        urlTracking(event);

    }

    private void urlTracking(AccessibilityEvent event) {
        AccessibilityNodeInfo source = event.getSource();
        if (source == null)
            return;
        final String packageName = String.valueOf(source.getPackageName());
        String BROWSER_LIST = "com.android.chrome";
        List<String> browserList
                = Arrays.asList(BROWSER_LIST.split(",\\s*"));
        if (event.getEventType()
                == AccessibilityEvent.TYPE_WINDOW_CONTENT_CHANGED) {
            if (!browserList.contains(packageName)) {
                return;
            }
        }

        if (browserList.contains(packageName)) {
            try {
                if (AccessibilityEvent
                        .eventTypeToString(event.getEventType())
                        .contains("WINDOW")) {
                    AccessibilityNodeInfo nodeInfo = event.getSource();
                    getUrlsFromViews(nodeInfo);
                }
            } catch (StackOverflowError ex) {
                ex.printStackTrace();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    public void getUrlsFromViews(AccessibilityNodeInfo info) {

        try {
            if (info == null)
                return;
            if (info.getText() != null && info.getText().length() > 0) {
                String capturedText = info.getText().toString();
                Log.e(TAG, "Captured Text : " + capturedText.substring(1, 6));

//                Bundle arguments = new Bundle();
                if (capturedText.contains("https://")
                        || capturedText.contains("http://")) {

                    if (capturedText.contains("facebook.com")) {
                        Log.e(TAG, "Current Blocked URL : " + capturedText);
                    }
                }
            }
            for (int i = 0; i < info.getChildCount(); i++) {
                AccessibilityNodeInfo child = info.getChild(i);
                getUrlsFromViews(child);
                if (child != null) {
                    child.recycle();
                }
            }
        } catch (StackOverflowError ex) {
            ex.printStackTrace();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    @Override
    public void onInterrupt() {
        Log.d(TAG, "AccessibilityService interrupted");
    }

    private Set<String> getBlockedApps() {
        SharedPreferences sharedPref1 = getSharedPreferences("cachedBlockedApps", 0);
        return sharedPref1.getStringSet("blockedApps", new HashSet<>());
    }

    private void blockApp() {
        Intent intent = new Intent(ForegroundAppsAccessibilityService.this, BlockingActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        startActivity(intent);
    }

    public static boolean isAccessibilityServiceEnabled(Context context, Class<? extends AccessibilityService> serviceClass) {
        AccessibilityManager am = (AccessibilityManager) context.getSystemService(Context.ACCESSIBILITY_SERVICE);
        List<AccessibilityServiceInfo> enabledServices = am.getEnabledAccessibilityServiceList(AccessibilityServiceInfo.FEEDBACK_GENERIC);

        for (AccessibilityServiceInfo serviceInfo : enabledServices) {
            if (serviceInfo.getId().contains(context.getPackageName() + "/" + serviceClass.getName())) {
                return true;
            }
        }
        return false;
    }

//    public boolean isAccessibilityServiceEnabled(Context context) {
//        String service = context.getPackageName() + "/.ForegroundAppsAccessibilityService";
//        int enabled = Settings.Secure.getInt(getContentResolver(),
//                Settings.Secure.ACCESSIBILITY_ENABLED, 0);
//        if (enabled == 1) {
//            String enabledServices = Settings.Secure.getString(getContentResolver(),
//                    Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES);
//            return enabledServices != null && enabledServices.contains(service);
//        }
//        return false;
//    }    

private Notification createNotification() {
        Intent notificationIntent = new Intent(this, MainActivity.class);
        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0, notificationIntent, PendingIntent.FLAG_IMMUTABLE);

        NotificationCompat.Builder builder = new NotificationCompat.Builder(this, CHANNEL_ID)
                .setContentTitle("Accessibility Service")
                .setContentText("Monitoring apps")
                .setSmallIcon(R.drawable.ic_notification)
                .setColor(getResources().getColor(R.color.primary_color))
                .setContentIntent(pendingIntent);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel channel = new NotificationChannel(CHANNEL_ID, "Accessibility Service", NotificationManager.IMPORTANCE_LOW);
            NotificationManager notificationManager = getSystemService(NotificationManager.class);
            if (notificationManager != null) {
                notificationManager.createNotificationChannel(channel);
            }
        }
      return  builder.build();
    }
}
