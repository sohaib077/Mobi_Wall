package fayoum.university.mobi_wall;

import android.content.SharedPreferences;
import android.util.Log;

import java.io.IOException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

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
import com.google.auth.oauth2.GoogleCredentials;
import com.google.auth.oauth2.AccessToken;

import java.io.FileInputStream;
import java.io.InputStream;
import java.util.Arrays;


public class NotificationSender {

    private static final String TAG = "NotificationSender";
    public static final MediaType JSON = MediaType.parse("application/json; charset=utf-8");
    private static final String FCM_URL = "https://fcm.googleapis.com/v1/projects/mobiwall-43f95/messages:send";
    
    private Context context;
    private String token;
    private ExecutorService executor;

    public NotificationSender(Context context, String token) {
        this.context = context;
        this.token = token;
        this.executor = Executors.newSingleThreadExecutor();
    }

    public void sendNotificationAsync() {
        executor.execute(new Runnable() {
            @Override
            public void run() {
                try {
                    sendNotification();
                } catch (Exception e) {
                    Log.e(TAG, "Exception in notification sending: " + e.getMessage(), e);
                }
            }
        });
    }

    private String getAccessToken() {
        try {
            // Load your service account key file
            InputStream serviceAccount = context.getAssets().open("mobiwall-43f95-ca076616cced.json");
            GoogleCredentials googleCredentials = GoogleCredentials
                    .fromStream(serviceAccount)
                    .createScoped(Arrays.asList("https://www.googleapis.com/auth/firebase.messaging"));
            
            googleCredentials.refresh();
            AccessToken accessToken = googleCredentials.getAccessToken();
            return accessToken.getTokenValue();
        } catch (Exception e) {
            Log.e(TAG, "Error getting access token: " + e.getMessage(), e);
            return null;
        }
    }

    public void sendNotification() {
        SharedPreferences sharedPref = context.getSharedPreferences("MyPrefsFile", 0);
        String childName = sharedPref.getString("childName", "Unknown Child");

        Log.d(TAG, "Sending notification to token: " + token);
        
        String accessToken = getAccessToken();
        if (accessToken == null) {
            Log.e(TAG, "Failed to get access token");
            return;
        }

        OkHttpClient client = new OkHttpClient();
        
        // Updated JSON format for FCM HTTP v1 API
        String json = "{"
                + "\"message\": {"
                + "\"token\": \"" + token + "\","
                + "\"notification\": {"
                + "\"title\": \"Location Tracker\","
                + "\"body\": \"Your child (" + childName + ") has changed their location.\""
                + "},"
                + "\"android\": {"
                + "\"priority\": \"high\""
                + "}"
                + "}"
                + "}";

        RequestBody requestBody = RequestBody.create(JSON, json);
        Request request = new Request.Builder()
                .url(FCM_URL)
                .post(requestBody)
                .addHeader("Authorization", "Bearer " + accessToken)
                .addHeader("Content-Type", "application/json")
                .build();

        try {
            Response response = client.newCall(request).execute();
            String responseBody = response.body() != null ? response.body().string() : "";
            
            Log.d(TAG, "Response code: " + response.code());
            Log.d(TAG, "Response body: " + responseBody);
            
            if (response.isSuccessful()) {
                Log.i(TAG, "Notification sent successfully");
            } else {
                Log.e(TAG, "Error sending notification. Code: " + response.code() + ", Body: " + responseBody);
            }
        } catch (IOException e) {
            Log.e(TAG, "Network error sending notification: " + e.getMessage(), e);
        }
    }
    
    public void shutdown() {
        if (executor != null && !executor.isShutdown()) {
            executor.shutdown();
        }
    }
}