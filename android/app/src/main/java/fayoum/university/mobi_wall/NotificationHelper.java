package fayoum.university.mobi_wall;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Context;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.os.Build;

import androidx.core.app.ActivityCompat;
import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;

public class NotificationHelper {

    public static final String SPORTS_CHANNEL_ID = "testing_channel";

    public static void createNotificationChannel(Context context) {

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationManager notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
            if (notificationManager != null && notificationManager.getNotificationChannel(SPORTS_CHANNEL_ID) == null) {
                NotificationChannel channel = new NotificationChannel(SPORTS_CHANNEL_ID, "Testing channel", NotificationManager.IMPORTANCE_HIGH);
                channel.setDescription("Just a description");
                channel.enableLights(true);
                channel.setLightColor(Color.RED);
                channel.enableVibration(true);


                notificationManager.createNotificationChannel(channel);

            }
        }
    }    public static void sendNotification(Context context, String title, String message) {
        NotificationCompat.Builder builder = new NotificationCompat.Builder(context, SPORTS_CHANNEL_ID)
                .setContentTitle(title)
                .setContentText(message)
                .setSmallIcon(R.drawable.ic_notification)
                .setColor(context.getResources().getColor(R.color.primary_color))
                .setPriority(NotificationCompat.PRIORITY_DEFAULT);


        NotificationManagerCompat notificationManagerCompat = NotificationManagerCompat.from(context);
        if (ActivityCompat.checkSelfPermission(context, android.Manifest.permission.POST_NOTIFICATIONS) != PackageManager.PERMISSION_GRANTED) {
            System.out.println("notification permission required");
            return;
        }
        notificationManagerCompat.notify(1455, builder.build());

    }


}
