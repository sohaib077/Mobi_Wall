package fayoum.university.mobi_wall;
import android.annotation.SuppressLint;
import android.content.ContentResolver;
import android.content.Context;
import android.database.Cursor;
import android.net.Uri;
import android.provider.CallLog;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class CallLogs {

    private final Context context;

    public CallLogs(Context context) {
        this.context = context;
    }


    public List<Map<String, Object>> getRecentCalls() {
        List<Map<String, Object>> callLogs = new ArrayList<>();

        Uri callLogUri = CallLog.Calls.CONTENT_URI;
        String[] projection = {
                CallLog.Calls.NUMBER,
                CallLog.Calls.TYPE,
                CallLog.Calls.DATE,
                CallLog.Calls.DURATION,
                CallLog.Calls.CACHED_NAME,
        };
        String sortOrder = CallLog.Calls.DATE + " DESC LIMIT 20";

        ContentResolver contentResolver = context.getContentResolver();
        Cursor cursor = contentResolver.query(callLogUri, projection, null, null, sortOrder);

        if (cursor != null) {
            while (cursor.moveToNext()) {
                @SuppressLint("Range") String number = cursor.getString(cursor.getColumnIndex(CallLog.Calls.NUMBER));
                @SuppressLint("Range") String type = cursor.getString(cursor.getColumnIndex(CallLog.Calls.TYPE));
                @SuppressLint("Range") String date = cursor.getString(cursor.getColumnIndex(CallLog.Calls.DATE));
                @SuppressLint("Range") String duration = cursor.getString(cursor.getColumnIndex(CallLog.Calls.DURATION));
                @SuppressLint("Range") String name = cursor.getString(cursor.getColumnIndex(CallLog.Calls.CACHED_NAME));

                CallLogModel callLogEntry = new CallLogModel(number, type, date, duration , name);
                callLogs.add(callLogEntry.toMap());
            }
            cursor.close();
        }

        return callLogs;

        /*
         INCOMING_TYPE = 1
         OUTGOING_TYPE = 2
         MISSED_TYPE = 3
         */

    }
}
