package fayoum.university.mobi_wall;

import io.flutter.embedding.android.FlutterActivity;

import android.Manifest;
import android.app.Activity;
import android.app.AppOpsManager;
import android.app.admin.DevicePolicyManager;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import android.content.SharedPreferences;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.net.VpnService;
import android.os.Build;
import android.os.Bundle;
import android.provider.Settings;

import androidx.activity.EdgeToEdge;
import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;
import androidx.work.Constraints;
import androidx.work.Data;
import androidx.work.ExistingPeriodicWorkPolicy;
import androidx.work.NetworkType;
import androidx.work.PeriodicWorkRequest;
import androidx.work.WorkInfo;
import androidx.work.WorkManager;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.messaging.FirebaseMessaging;

public class MainActivity extends FlutterActivity {

    private static final String TAG_SEND_DATA = "Sending data to server";

    private static final String CHANNEL = "fayoum.university.mobi_wall";
    public static Activity activity;
    private final String cachedHideAppIcon = "hideAppIcon";
    private boolean isChild = false;
    private String id;
    private String childName;

    static final String PREFS_NAME = "MyPrefsFile";
    private static final int REQUEST_LOCATION_PERMISSION = 1;

    private static final int VPN_REQUEST_CODE = 100;

    static final int RESULT_ENABLE = 1;
    DevicePolicyManager devicePolicyManager;
    ComponentName compName;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        NotificationHelper.createNotificationChannel(this);
        Intent serviceIntent = new Intent(this, AppUsageMonitorService.class);
        this.stopService(serviceIntent);

        SharedPreferences sharedPref = getSharedPreferences(PREFS_NAME, 0);
        boolean isLocked = sharedPref.getBoolean("locked", false);
        if (isLocked) {
            setContentView(R.layout.activity_lock);
            sharedPref.edit().putBoolean("locked", false).apply();
            ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main), (v, insets) -> {
                Insets systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars());
                v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom);
                return insets;
            });
        }
    }


    /*********************************************************
     ******************* LOCATION TRACKING *******************
     *********************************************************/
    private void startLocationTrackingService() {
        System.out.println("location tracking service started");
        Intent serviceIntent = new Intent(this, LocationTrackingService.class);
        startService(serviceIntent);
    }

    @Override
    protected void onPause() {
        super.onPause();

        SharedPreferences sharedPref = getSharedPreferences(PREFS_NAME, 0);
        boolean isChild = sharedPref.getBoolean("isChild", false);
        if (isChild) {
            Intent serviceIntent = new Intent(this, AppUsageMonitorService.class);
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                this.startForegroundService(serviceIntent);
            } else {
                this.startService(serviceIntent);
            }


            if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
                ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.ACCESS_FINE_LOCATION}, REQUEST_LOCATION_PERMISSION);
            } else {
                LocationTrackingService.flag = 0;
                startLocationTrackingService();
            }
        }
    }

////////////////////////////////////////// WORK MANAGER SETUP ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    @RequiresApi(api = Build.VERSION_CODES.O)
    public boolean SettingUpPeriodicWork() {

        Constraints constraints = new Constraints.Builder().setRequiredNetworkType(NetworkType.CONNECTED).setRequiresBatteryNotLow(false).setRequiresStorageNotLow(false).build();

        Data.Builder dataBuilder = new Data.Builder();
        dataBuilder.putString("id", id);
        dataBuilder.putString("childName", childName);
        Data inputData = dataBuilder.build();

        PeriodicWorkRequest periodicSendDataWork = new PeriodicWorkRequest.Builder(SendDataWorker.class, 15, TimeUnit.MINUTES).addTag(TAG_SEND_DATA).setConstraints(constraints).setInputData(inputData).setInitialDelay(2, TimeUnit.SECONDS).build();

        WorkManager workManager = WorkManager.getInstance(this);
        workManager.enqueueUniquePeriodicWork("Refresh Child Data", ExistingPeriodicWorkPolicy.REPLACE, periodicSendDataWork);

        return true;
    }

////////////////////////////////////////// CHANNEL METHODS ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    @RequiresApi(api = Build.VERSION_CODES.O)
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {

        SharedPreferences sharedPref = getSharedPreferences(PREFS_NAME, 0);
        SharedPreferences.Editor editor = sharedPref.edit();

        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler((call, result) -> {
            if (call.method.equals("startPeriodicDataRefreshing")) {

                startPeriodicDataRefreshing(call, result, editor);

            } else if (call.method.equals("getPermissions")) {

                if (!areAllPermissionsGranted()) requestPermissions();
                result.success(true);

            } else if (call.method.equals("getUsageAccessPermission")) {

                if (!isAccessGranted()) {
                    Intent intent = new Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS);
                    startActivity(intent);
                }
                result.success(true);


            } else if (call.method.equals("blockUninstall")) {

                requestAdminActivation();

                result.success(true);

            } else if (call.method.equals("stopPeriodicTasks")) {

                Data.Builder dataBuilder = new Data.Builder();
                dataBuilder.putBoolean("isChild", false);
                WorkManager.getInstance(this).cancelAllWork();
                result.success("Periodic data refreshing is cancelled successfully");

            } else {
                result.notImplemented();
            }
        });
    }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


    /*************************************************************
     ******************* REFRESH PERIODIC DATA *******************
     *************************************************************/

    @RequiresApi(api = Build.VERSION_CODES.O)
    private void startPeriodicDataRefreshing(MethodCall call, MethodChannel.Result result, SharedPreferences.Editor editor) {
        try {
            // Check if the periodic data refreshing is already running
            List<WorkInfo> workInfos = WorkManager.getInstance(this).getWorkInfosByTag(TAG_SEND_DATA).get();
            for (WorkInfo workInfo : workInfos) {
                if (workInfo.getState() == WorkInfo.State.ENQUEUED) {
                    result.success("The periodic data refreshing is running already");
                    return;
                }
            }
        } catch (ExecutionException | InterruptedException ignored) {
        }

        boolean state;
        isChild = Boolean.TRUE.equals(call.argument("isChild"));
        id = call.argument("id");
        childName = call.argument("childName");
        System.out.println("isChild = " + isChild);
        System.out.println("id = " + id);
        System.out.println("childName = " + childName);
        /* save data in shared preferences */
        editor.putString("childName", childName).apply();
        editor.putString("childId", id).apply();
        editor.putBoolean("isChild", isChild).apply();

        state = SettingUpPeriodicWork();
        System.out.println("state = " + state);
        if (state) result.success("Periodic data refreshing is started successfully");
        else
            result.success("Something went wrong, make sure that all permission are permitted and try again");
    }

    /***********************************************************
     ******************* REQUEST PERMISSIONS *******************
     ***********************************************************/
    private static final int PERMISSION_REQUEST_CODE = 100;

    private final String[] permissions = {
            Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.ACCESS_COARSE_LOCATION,
            Manifest.permission.ACCESS_BACKGROUND_LOCATION, Manifest.permission.PACKAGE_USAGE_STATS,
            Manifest.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS, Manifest.permission.POST_NOTIFICATIONS,
            Manifest.permission.PROCESS_OUTGOING_CALLS, Manifest.permission.RECEIVE_BOOT_COMPLETED,
            Manifest.permission.READ_PHONE_STATE, Manifest.permission.CALL_PHONE,
            Manifest.permission.READ_CALL_LOG, Manifest.permission.WRITE_CALL_LOG
    };

    private boolean isPermissionGranted(String permission) {
        return ContextCompat.checkSelfPermission(this, permission) == PackageManager.PERMISSION_GRANTED;
    }

    private boolean areAllPermissionsGranted() {
        for (String permission : permissions) {
            if (!isPermissionGranted(permission)) return false;
        }
        return true;
    }


    private void requestPermissions() {
//        requestAdminActivation();
        ActivityCompat.requestPermissions(this, permissions, PERMISSION_REQUEST_CODE);
    }

    private boolean areAnyPermissionsDenied(int[] grantResults) {
        for (int result : grantResults) {
            if (result == PackageManager.PERMISSION_DENIED) return true;
        }
        return false;
    }

    // Handle permission request result
    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        if (requestCode == PERMISSION_REQUEST_CODE) {
            if (areAnyPermissionsDenied(grantResults)) {
                // Handle denied permissions
            } else {
                // All permissions granted
            }
        }
    }

    /**********************************************************
     ******************* APPS USAGES ACCESS *******************
     **********************************************************/

    private boolean isAccessGranted() {
        try {
            PackageManager packageManager = getPackageManager();
            ApplicationInfo applicationInfo = packageManager.getApplicationInfo(getPackageName(), 0);
            AppOpsManager appOpsManager = (AppOpsManager) getSystemService(Context.APP_OPS_SERVICE);
            int mode = 0;
            mode = appOpsManager.checkOpNoThrow(AppOpsManager.OPSTR_GET_USAGE_STATS, applicationInfo.uid, applicationInfo.packageName);
            return (mode == AppOpsManager.MODE_ALLOWED);
        } catch (PackageManager.NameNotFoundException e) {
            return false;
        }
    }

    /********************************************************
     ******************* ADMIN ACTIVATION *******************
     ********************************************************/

    private void requestAdminActivation() {
        devicePolicyManager = (DevicePolicyManager) getSystemService(Context.DEVICE_POLICY_SERVICE);
        compName = new ComponentName(this, MyDeviceAdminReceiver.class);
        Intent intent = new Intent(DevicePolicyManager.ACTION_ADD_DEVICE_ADMIN);
        intent.putExtra(DevicePolicyManager.EXTRA_DEVICE_ADMIN, new ComponentName(this, MyDeviceAdminReceiver.class));
        intent.putExtra(DevicePolicyManager.EXTRA_ADD_EXPLANATION, "You should allow this to prevent your child from uninstalling the app");
        startActivityForResult(intent, RESULT_ENABLE);
        /*
        adb shell dpm remove-active-admin fayoum.university.mobi_wall/.MyDeviceAdminReceiver
        adb shell dpm set-device-owner fayoum.university.mobi_wall/.MyDeviceAdminReceiver
        adb -s <device> shell
        adb -s emulator-5558 shell dpm set-device-owner fayoum.university.mobi_wall/.MyDeviceAdminReceiver
        adb -s emulator-5558 shell dpm remove-active-admin fayoum.university.mobi_wall/.MyDeviceAdminReceiver
         */

        ///////////////////////////////////////////////////////////////////////////////////////////////////////////
        //        if (requestCode == VPN_REQUEST_CODE && resultCode == RESULT_OK) {
        //            Intent intent = new Intent(this, MyVpnService.class);
        //            startService(intent);
        //        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == RESULT_ENABLE) {
            if (resultCode == RESULT_OK) {
                System.out.println("device adming activated successfully");
            } else {
                System.out.println("Device admin activation failed");
            }
        }
    }

}
