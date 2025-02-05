package fayoum.university.mobi_wall;
import android.content.SharedPreferences;
import android.os.Build;
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


    @RequiresApi(api = Build.VERSION_CODES.N)
    @Override
    public void onMessageReceived(RemoteMessage remoteMessage) {

        SharedPreferences sharedPref = getSharedPreferences("cachedBlockedApps", 0);
        SharedPreferences.Editor editor = sharedPref.edit();

        System.out.println("receiving a message");

        // Check if message contains a data payload.
        if (!remoteMessage.getData().isEmpty()) {
            System.out.println("Message data payload: " + remoteMessage.getData());


            if (Objects.equals(remoteMessage.getData().get("updateBlockedApps"), "true")) {
                String blockedAppsString = remoteMessage.getData().get("blockedApps");
                Set<String> set = new HashSet<>();
                if (blockedAppsString != null && blockedAppsString.length() > 2) {
                    blockedAppsString = blockedAppsString.substring(1, blockedAppsString.length() - 1);

                    List<String> blockedAppsList = new ArrayList<String>(Arrays.asList(blockedAppsString.split(",")));
                    System.out.println("blocked list length " + blockedAppsList.size());
                    for (String s : blockedAppsList) {
                        set.add(s.substring(1, s.length() - 1));
                    }

                }
                editor.putStringSet("blockedApps", set).apply();
                set = sharedPref.getStringSet("blockedApps", new HashSet<>());
            }
        }

        // Check if message contains a notification payload.
        if (remoteMessage.getNotification() != null) {
            System.out.println("Message Notification title : " + remoteMessage.getNotification().getTitle());
            NotificationHelper.createNotificationChannel(this);
            NotificationHelper.sendNotification(this, remoteMessage.getNotification().getTitle(), remoteMessage.getNotification().getBody());
        }

    }


}

//exBd_dqMRJumfwUpZS1h9j:APA91bHgYK6JZjcR_WwEQM1nLDI2W3j8CGVvL6IyRAXMQ4g6bwQtSTIybp1sTs59eE4L3CKoXLnsChAfmho5XmvkgLd3POmvs0_VIWB2N-GbbcFao87VCI-uUxQ7RwRlbUDccOI4u1fc