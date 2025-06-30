package fayoum.university.mobi_wall;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Intent;
import android.content.SharedPreferences;
import android.net.ProxyInfo;
import android.net.VpnService;
import android.os.Build;
import android.os.ParcelFileDescriptor;
import android.util.Log;

import androidx.annotation.RequiresApi;
import androidx.core.app.NotificationCompat;

import java.io.FileInputStream;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.util.HashSet;
import java.util.Set;

public class BlockingVpnService extends VpnService {
    private ParcelFileDescriptor vpnInterface;
    final String TAG = "BlockingVpnService";
    private static final String CHANNEL_ID = "VPN_SERVICE_CHANNEL";
    private static final int NOTIFICATION_ID = 123;

    @Override
    public void onCreate() {
        super.onCreate();
    }

    @RequiresApi(api = Build.VERSION_CODES.Q)
    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        Builder builder = new Builder();
        builder.setSession("Parental Control VPN");
        builder.addAddress("192.168.1.6", 24); // Example IP
        builder.addDnsServer("8.8.8.8"); // Google  DNS
//        builder.addDnsServer("1.1.1.1"); // Cloudflare DNS

        // Step 3: Route all traffic through the VPN, except Firebase
        // Add a specific route for Firebase's IP range to bypass the VPN
        builder.addRoute("8.8.8.0", 24);  // Example Google DNS range for Firebase traffic
        builder.addRoute("8.8.4.0", 24);  // Another range for Firebase services
        // You can add more specific routes for Firebase or Google services if needed

        // Step 4: Route all other traffic through the VPN (catch-all route)
        builder.addRoute("0.0.0.0", 0);  // Default route for all non-Firebase traffic



        vpnInterface = builder.establish();

        // Configure the proxy
        builder.addRoute("10.0.2.2", 32); // Route traffic to the proxy server
        builder.setHttpProxy(ProxyInfo.buildDirectProxy("10.0.2.2", 8080));

        // Start a thread to monitor traffic
//        new Thread(new Runnable() {
//            @Override
//            public void run() {
//                monitorTraffic();
//            }
//        }).start();
        startForeground(NOTIFICATION_ID, createNotification());
        return START_STICKY;
    }

    private void monitorTraffic() {
        // Read packets from the VPN interface
        FileInputStream in = new FileInputStream(vpnInterface.getFileDescriptor());
        byte[] packet = new byte[32767];
        while (true) {
            int length = 0;
            try {
                length = in.read(packet);
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
            if (length > 0) {
                // Parse the packet and check if it contains a blocked URL
                if (isBlockedIp(packet)) {
                    Log.d(TAG, "Blocked URL detected");
                    // Block the packet
                } else {
                    // Allow the packet
                }
            }
        }
    }

    byte[] lastPacket;

    private boolean isBlockedIp(byte[] packet) {
        if (packet == lastPacket) return false;
        lastPacket = packet;
        // Parse the destination IP address from the packet
        ByteBuffer buffer = ByteBuffer.wrap(packet);
        buffer.position(16); // Destination IP starts at byte 16 in the IP header
        byte[] destIpBytes = new byte[4];
        buffer.get(destIpBytes);
        String destIp = bytesToIp(destIpBytes);
        Log.d(TAG, "Destination IP: " + destIp);
        // Check if the destination IP is in the block list
        Set<String> blockedIps = getBlockedIps(); // Retrieve your block list
        return blockedIps.contains(destIp);
    }

    private Set<String> getBlockedIps() {
        // Retrieve the blocked IPs from SharedPreferences or a database
        SharedPreferences sharedPreferences = getSharedPreferences("BlockedIps", MODE_PRIVATE);
        return sharedPreferences.getStringSet("ips", new HashSet<>());
    }

    private String bytesToIp(byte[] bytes) {
        // Ensure the byte array has exactly 4 bytes (IPv4 address)
        if (bytes.length != 4) {
            throw new IllegalArgumentException("Byte array must have exactly 4 bytes for an IPv4 address.");
        }

        // Convert each byte to an unsigned integer (0-255) and format it as an IP address
        return String.format("%d.%d.%d.%d",
                bytes[0] & 0xFF, // Convert to unsigned byte
                bytes[1] & 0xFF,
                bytes[2] & 0xFF,
                bytes[3] & 0xFF);
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        if (vpnInterface != null) {
            try {
                vpnInterface.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }    private Notification createNotification() {
        Intent notificationIntent = new Intent(this, MainActivity.class);
        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0, notificationIntent, PendingIntent.FLAG_IMMUTABLE);

        NotificationCompat.Builder builder = new NotificationCompat.Builder(this, CHANNEL_ID)
                .setContentTitle("VPN Service")
                .setContentText("Monitoring network traffic")
                .setSmallIcon(R.drawable.ic_notification)
                .setColor(getResources().getColor(R.color.primary_color))
                .setContentIntent(pendingIntent);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel channel = new NotificationChannel(CHANNEL_ID, "VPN Service", NotificationManager.IMPORTANCE_LOW);
            NotificationManager notificationManager = getSystemService(NotificationManager.class);
            if (notificationManager != null) {
                notificationManager.createNotificationChannel(channel);
            }
        }
        return builder.build();
    }
}