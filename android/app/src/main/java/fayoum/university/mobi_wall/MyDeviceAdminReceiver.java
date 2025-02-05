package fayoum.university.mobi_wall;

import android.app.admin.DeviceAdminReceiver;
import android.content.Context;
import android.content.Intent;

public class MyDeviceAdminReceiver extends DeviceAdminReceiver {
    @Override
    public void onEnabled(Context context, Intent intent) {
        System.out.println("admin");
        // Code to execute when the app is granted device admin privileges
    }

    @Override
    public void onDisabled(Context context, Intent intent) {
        // Code to execute when the app loses device admin privileges
    }
}
