package fayoum.university.mobi_wall;
import android.Manifest;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.os.Build;
import androidx.core.app.ActivityCompat;
import java.util.Calendar;

public class StartupOnBootUpReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {

        System.out.println("hello from booting up");
        NotificationHelper.sendNotification(context, "Rebooting", " " + "   " + Calendar.getInstance().getTime());
        SharedPreferences sharedPref = context.getSharedPreferences(MainActivity.PREFS_NAME, 0);
        boolean isChild = sharedPref.getBoolean("isChild", false);
        if (isChild) {
            Intent serviceIntent1 = new Intent(context, AppUsageMonitorService.class);
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(serviceIntent1);
            } else {
                context.startService(serviceIntent1);
            }

            if (ActivityCompat.checkSelfPermission(context, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
                ActivityCompat.requestPermissions(MainActivity.activity, new String[]{Manifest.permission.ACCESS_FINE_LOCATION}, 1);
            } else {
                LocationTrackingService.flag = 0;
                Intent serviceIntent2 = new Intent(context, LocationTrackingService.class);
                context.startService(serviceIntent2);
            }
        }

    }
}
