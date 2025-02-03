package fayoum.university.mobi_wall;

import android.content.SharedPreferences;

import java.io.IOException;

import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

import android.content.Context;

import androidx.annotation.NonNull;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.FirebaseFirestore;


public class NotificationSender {

    public static final MediaType JSON = MediaType.parse("application/json; charset=utf-8");

    private Context context;
    private String token;

    Thread thread = new Thread(new Runnable() {

        @Override
        public void run() {
            try {
                sendNotification();
            } catch (Exception e) {
                System.out.println("exception = " + e.getMessage());
            }
        }
    });

    public NotificationSender(Context context, String token) {
        this.context = context;
        this.token = token;
    }

    public void startThread() {
        thread.start();
    }

    public void sendNotification() {
        SharedPreferences sharedPref = context.getSharedPreferences("MyPrefsFile", 0);
        SharedPreferences.Editor editor = sharedPref.edit();

        String childName = sharedPref.getString("childName", "null");

//        String token = sharedPref.getString("token", "null");
        System.out.println("token from shared pref = " + token);
        OkHttpClient client = new OkHttpClient();
        String json = "{"
                + "\"to\": \"" + token + "\","
                + "\"notification\": {"
                + "\"title\": \"" + "Location tracker" + "\","
                + "\"body\": \"" + "Your child ( " + childName + " ) has changed his location." + "\""
                + "}"
                + "}";

        RequestBody requestBody = RequestBody.create(JSON, json);
        Request request = new Request.Builder()
                .url("https://fcm.googleapis.com/fcm/send")
                .post(requestBody)
                .addHeader("Authorization", "Bearer AAAA9S9xrdY:APA91bFZomn-A9WnrJUn1ePBYInqq9sp1oc4llAzHbHc_Z35dbJB2q60CjtZIaqVFDwguFtCtJa4iRZh00XblidhYjg-cLRbCAQLgC7e35B43FzmJtTgo1bTAQSjnLax-7Ke9urAth0f")
                .build();


        try {
            Response response = client.newCall(request).execute();
            System.out.println("response = " + response);
            if (response.isSuccessful()) {
                System.out.println("Notification sent successfully");
                // Notification sent successfully
            } else {
                System.out.println("Error sending notification");
                // Error sending notification
            }
        } catch (IOException e) {
            System.out.println("error sending notification = " + e.getMessage());
//            e.printStackTrace();
        }
    }
}