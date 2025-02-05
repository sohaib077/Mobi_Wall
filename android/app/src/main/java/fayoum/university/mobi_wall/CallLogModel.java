package fayoum.university.mobi_wall;
import java.util.HashMap;
import java.util.Map;

public class CallLogModel {
    private final String number;
    private final String type;
    private final String date;
    private final String duration;
    private final String name;

    public CallLogModel(String number, String type, String date, String duration , String name) {
        this.number = number;
        this.type = type;
        this.date = date;
        this.duration = duration;
        this.name = name;
    }

    public Map<String, Object> toMap() {
        Map<String, Object> callLogMap = new HashMap<>();
        callLogMap.put("number", number);
        callLogMap.put("type", type);
        callLogMap.put("date", date);
        callLogMap.put("duration", duration);
        callLogMap.put("name", name);
        return callLogMap;
    }
}
