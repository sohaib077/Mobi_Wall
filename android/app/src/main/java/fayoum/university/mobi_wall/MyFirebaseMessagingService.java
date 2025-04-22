package fayoum.university.mobi_wall;
import android.content.SharedPreferences;
import android.os.Build;
import android.util.Log;

import androidx.annotation.RequiresApi;
import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Objects;
import java.util.Set;

public class MyFirebaseMessagingService extends FirebaseMessagingService {

    final String TAG = "MyMessagingService";
    @RequiresApi(api = Build.VERSION_CODES.N)
    @Override
    public void onMessageReceived(RemoteMessage remoteMessage) {
        SharedPreferences sharedPref = getSharedPreferences("cachedBlockedApps", 0);
        SharedPreferences.Editor editor = sharedPref.edit();

        Log.i(TAG,"receiving a message");

        // Check if message contains a data payload.
        if (!remoteMessage.getData().isEmpty()) {
            Log.i(TAG,"Message data payload: " + remoteMessage.getData());


            if (Objects.equals(remoteMessage.getData().get("updateBlockedApps"), "true")) {
                String blockedAppsString = remoteMessage.getData().get("blockedApps");
                Set<String> set = new HashSet<>();
                if (blockedAppsString != null && blockedAppsString.length() > 2) {
                    blockedAppsString = blockedAppsString.substring(1, blockedAppsString.length() - 1);
                    List<String> blockedAppsList = new ArrayList<String>(Arrays.asList(blockedAppsString.split(",")));
                    set.addAll(blockedAppsList);

                }
                Log.i(TAG,"set = " + set);
                editor.putStringSet("blockedApps", set).apply();
            }
        }

        // Check if message contains a notification payload.
        if (remoteMessage.getNotification() != null) {
            Log.i(TAG,"Message Notification title : " + remoteMessage.getNotification().getTitle());
            NotificationHelper.createNotificationChannel(this);
            NotificationHelper.sendNotification(this, remoteMessage.getNotification().getTitle(), remoteMessage.getNotification().getBody());
        }

    }


}

//exBd_dqMRJumfwUpZS1h9j:APA91bHgYK6JZjcR_WwEQM1nLDI2W3j8CGVvL6IyRAXMQ4g6bwQtSTIybp1sTs59eE4L3CKoXLnsChAfmho5XmvkgLd3POmvs0_VIWB2N-GbbcFao87VCI-uUxQ7RwRlbUDccOI4u1fc