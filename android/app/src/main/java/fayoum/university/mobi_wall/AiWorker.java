package fayoum.university.mobi_wall;

import android.content.Context;
import android.os.Build;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.work.Worker;
import androidx.work.WorkerParameters;

import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.firestore.FirebaseFirestore;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.Calendar;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.json.JSONException;
import org.json.JSONObject;

public class AiWorker extends Worker {

    public AiWorker(@NonNull Context context, @NonNull WorkerParameters workerParams) {
        super(context, workerParams);
    }


    private static final String TAG = AiWorker.class.getSimpleName();

    @RequiresApi(api = Build.VERSION_CODES.N)
    @NonNull
    @Override
    public Result doWork() {

        String id = getInputData().getString("id");
        String childName = getInputData().getString("childName");

        Context context = getApplicationContext();
        try {
            SendData(context, id, childName);
        } catch (Exception e) {

            System.out.println("Exception 1 = " + e);

            NotificationHelper.sendNotification(this.getApplicationContext(), "Exception 1", e + "   " + Calendar.getInstance().getTime());

            boolean initializedBefore = false;
            List<FirebaseApp> firebaseApps = FirebaseApp.getApps(context);
            if (!firebaseApps.isEmpty()) {
                for (FirebaseApp app : firebaseApps) {
                    if (app.getName().equals(FirebaseApp.DEFAULT_APP_NAME)) {
                        initializedBefore = true;
                        break;
                    }
                }
            }
            if (!initializedBefore)
                FirebaseApp.initializeApp(this.getApplicationContext(), new FirebaseOptions.Builder().setApiKey("'AIzaSyDfwJq_1hj8SVKjAD7BlVBX78UPuky3Rl4'").setApplicationId("1:928204233885:android:96c21b60a5c5bfc5e24874").setGcmSenderId("928204233885").setProjectId("mobiwall-43f95").build());
            try {
                SendData(context, id, childName);
            } catch (URISyntaxException ex) {
                throw new RuntimeException(ex);
            }
            Result.retry();
        }

        NotificationHelper.sendNotification(this.getApplicationContext(), "AI Success", "🎉🎉" + "   " + Calendar.getInstance().getTime());

        return Result.success();
    }


    @RequiresApi(api = Build.VERSION_CODES.N)
    private void SendData(Context context, String id, String childName) throws URISyntaxException {


        System.out.println("Sending Data To AI Model...");


        callEndpoint(context);

    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    public static void callEndpoint(Context context) {
        /* Getting apps details  */
        List<Map<String, Object>> apps = new InstalledAppsProvider(context).getInstalledApps();
        JSONObject appUsageData = new JSONObject();
        for (Map<String, Object> app : apps) {
            try {
                appUsageData.put((String) Objects.requireNonNull(app.get("packageName")), (long) app.get("dailyUsageTime") / (1000 * 60.0));
            } catch (JSONException e) {
                throw new RuntimeException(e);
            }
        }


        new Thread(() -> {
            // Send the data to the API
            try {
                URL url = new URL("https://mostafa01332-predict.hf.space/predict");
                HttpURLConnection connection = (HttpURLConnection) url.openConnection();
                connection.setRequestMethod("POST");
                connection.setRequestProperty("Content-Type", "application/json; utf-8");
                connection.setRequestProperty("Accept", "application/json");
                connection.setDoOutput(true);

                Log.d(TAG, "app usage input: " + appUsageData);

                // Write the data to the connection
                try (OutputStream os = connection.getOutputStream()) {
                    byte[] input = appUsageData.toString().getBytes("utf-8");
                    os.write(input, 0, input.length);
                }

                // Check the response code
                int responseCode = connection.getResponseCode();
                if (responseCode == HttpURLConnection.HTTP_OK) {

                    // Read the response
                    BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
                    StringBuilder response = new StringBuilder();
                    String inputLine;
                    while ((inputLine = in.readLine()) != null) {
                        response.append(inputLine);
                    }
                    in.close();

                    Log.d(TAG, "Response: " + response);

                } else {
                    Log.e(TAG, "Error sending data to Ai: " + responseCode);
                }
            } catch (Exception e) {
                Log.e(TAG, "Send Data to Ai: " + e);
                e.printStackTrace();
            }
        }).start();
    }

}


