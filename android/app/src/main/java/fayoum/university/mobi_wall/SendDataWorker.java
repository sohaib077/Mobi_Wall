package fayoum.university.mobi_wall;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Build;
import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.core.content.ContextCompat;
import androidx.work.Worker;
import androidx.work.WorkerParameters;
import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationServices;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.firestore.FirebaseFirestore;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class SendDataWorker extends Worker {

    public SendDataWorker(@NonNull Context context, @NonNull WorkerParameters workerParams) {
        super(context, workerParams);
    }


    private static final String TAG = SendDataWorker.class.getSimpleName();

    @RequiresApi(api = Build.VERSION_CODES.N)
    @NonNull
    @Override
    public Result doWork() {

        String id = getInputData().getString("id");
        String childName = getInputData().getString("childName");

        Context context = getApplicationContext();
        Log.i(TAG, "Sending data to Server started ..");
        try {
            SendData(context, id, childName);
        } catch (Exception e) {

            System.out.println("Exception 1 = " + e);

            NotificationHelper.sendNotification(this.getApplicationContext(), "Exception 1", e.toString() + "   " + Calendar.getInstance().getTime());

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
                FirebaseApp.initializeApp(this.getApplicationContext(), new FirebaseOptions.Builder().setApiKey("'AIzaSyCQHjVsVP5aKYsJc_g4LYB5sJHMqTUsm2o'").setApplicationId("1:1053062966742:android:f79eb0a5ceac5d71ef4877").setGcmSenderId("1053062966742").setProjectId("mobiwall-abc0f").build());
            SendData(context, id, childName);
            Result.retry();
        }

        NotificationHelper.sendNotification(this.getApplicationContext(), "Success", "🎉🎉" + "   " + Calendar.getInstance().getTime());

        return Result.success();
    }


    @RequiresApi(api = Build.VERSION_CODES.N)
    private void SendData(Context context, String id, String childName) {


        System.out.println("Sending Data...");


        /* Getting location details  */
        Map<String, Double> address = new HashMap<>();
        FusedLocationProviderClient fusedLocationProviderClient;
        fusedLocationProviderClient = LocationServices.getFusedLocationProviderClient(context);
        if (ContextCompat.checkSelfPermission(context, android.Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED) {

            fusedLocationProviderClient.getLastLocation().addOnSuccessListener(location -> {
                System.out.println("Location = " + location);
                if (location != null) {

                    address.put("latitude", location.getLatitude());
                    address.put("longitude", location.getLongitude());


                }
            }).addOnFailureListener(e -> System.out.println("getLastLocation failure " + e));
        } else {

            address.put("latitude", 0.0);
            address.put("longitude", 0.0);
            System.out.println("Permission is required");
        }


        ///////////////////////////////////////////////////////////////////////////////////////////////////

        /* Getting apps details  */
        List<Map<String, Object>> apps = new InstalledAppsProvider(context).getInstalledApps();

        /* Getting calls details  */
        List<Map<String, Object>> calls = new CallLogs(context).getRecentCalls();


        System.out.println("apps length " + apps.size());
        System.out.println("address = " + address.values());
        FirebaseFirestore db = FirebaseFirestore.getInstance();
        if (address.containsKey("latitude"))
            db.collection("users").document(id).collection("children").document(childName).update("updatedDate", new Date(), "apps", apps, "location", address, "calls", calls);
        else
            db.collection("users").document(id).collection("children").document(childName).update("updatedDate", new Date(), "apps", apps, "calls", calls);

    }


}