package fayoum.university.mobi_wall;
import android.Manifest;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.Service;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.location.Location;
import android.os.Build;
import android.os.IBinder;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.core.app.ActivityCompat;
import androidx.core.app.NotificationCompat;
import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.Granularity;
import com.google.android.gms.location.LocationCallback;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationResult;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.location.Priority;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.FirebaseFirestore;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

public class LocationTrackingService extends Service {
    private static final String CHANNEL_ID = "LocationTrackingChannel";
    private static final int NOTIFICATION_ID = 1;

    private FusedLocationProviderClient fusedLocationProviderClient;
    private LocationCallback locationCallback;


    @Override
    public void onCreate() {
        super.onCreate();
        fusedLocationProviderClient = LocationServices.getFusedLocationProviderClient(this);
        createNotificationChannel();
    }


    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        SharedPreferences sharedPref = getSharedPreferences(MainActivity.PREFS_NAME, 0);
        sharedPref.edit().putBoolean("locationTracking", true).apply();
        startForeground(NOTIFICATION_ID, createNotification());

        requestLocationUpdates();

        return START_STICKY;
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public void onDestroy() {

        super.onDestroy();
        SharedPreferences sharedPref = getSharedPreferences(MainActivity.PREFS_NAME, 0);
        sharedPref.edit().putBoolean("locationTracking", true).apply();
        stopLocationUpdates();
    }

    private void createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel channel = new NotificationChannel(CHANNEL_ID, "Location Tracking", NotificationManager.IMPORTANCE_DEFAULT);
            NotificationManager notificationManager = getSystemService(NotificationManager.class);
            if (notificationManager != null) {
                notificationManager.createNotificationChannel(channel);
            }
        }
    }    private Notification createNotification() {
        NotificationCompat.Builder builder = new NotificationCompat.Builder(this, CHANNEL_ID)
                .setContentTitle("Location Tracking")
                .setContentText("Tracking user location")
                .setSmallIcon(R.drawable.ic_notification)
                .setColor(getResources().getColor(R.color.primary_color))
                .setPriority(NotificationCompat.PRIORITY_DEFAULT);

        return builder.build();
    }

    static int flag = 0;

    private void requestLocationUpdates() {
        SharedPreferences sharedPref = getApplicationContext().getSharedPreferences(MainActivity.PREFS_NAME, 0);
        SharedPreferences.Editor editor = sharedPref.edit();

        LocationRequest locationRequest = new LocationRequest.Builder(10000).setGranularity(Granularity.GRANULARITY_FINE).setPriority(Priority.PRIORITY_HIGH_ACCURACY).setMinUpdateDistanceMeters(500).build();

        locationCallback = new LocationCallback() {
            @Override
            public void onLocationResult(LocationResult locationResult) {
                System.out.println("flag = " + flag);
                if (locationResult != null) {
                    Location location = locationResult.getLastLocation();
                    flag++;
                    if (location != null && flag > 1) {

                        Map<String, Double> address = new HashMap<>();
                        address.put("latitude", location.getLatitude());
                        address.put("longitude", location.getLongitude());

                        System.out.println("Location update: " + location.getLatitude() + ", " + location.getLongitude());

                        String id = sharedPref.getString("childId", "null");

                        System.out.println("id = " + id);

                        FirebaseFirestore db = FirebaseFirestore.getInstance();
                        DocumentReference docRef = db.collection("users").document(id);


                        db.collection("users").document(id).collection("children").document(sharedPref.getString("childName", null)).update("updatedDate", new Date(), "location", address).addOnCompleteListener(runnable -> {

                            System.out.println("location updated and uploaded successfully to the server");
                            docRef.get().addOnCompleteListener(new OnCompleteListener<DocumentSnapshot>() {
                                @Override
                                public void onComplete(@NonNull Task<DocumentSnapshot> task) {
                                    if (task.isSuccessful()) {
                                        DocumentSnapshot document = task.getResult();
                                        if (document.exists() && document.getData().get("token") != null) {
                                            editor.putString("token", document.getData().get("token").toString());
                                            System.out.println("parent token = " + document.getData().get("token"));
                                            new NotificationSender(getApplicationContext(), document.getData().get("token").toString()).startThread();
                                        } else {
                                            System.out.println("No such document");
                                        }
                                    } else {
                                        System.out.println("get failed with ");
                                    }
                                }
                            });

                        });


                        // Notify location change or perform other actions
                    }
                }
            }
        };

        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED) {
            fusedLocationProviderClient.requestLocationUpdates(locationRequest, locationCallback, null);
        }
    }

    private void stopLocationUpdates() {
        fusedLocationProviderClient.removeLocationUpdates(locationCallback);
    }
}