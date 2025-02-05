package fayoum.university.mobi_wall;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Nullable;

public class AppDataModel {
    private final String packageName;
    private final String name;

    private final long dailyUsageTime;
    private final long weeklyUsageTime;
    private final long monthlyUsageTime;

    public AppDataModel(String packageName, String name , long dailyUsageTime , long weeklyUsageTime , long monthlyUsageTime) {
        this.packageName = packageName;
        this.name = name;
        this.dailyUsageTime = dailyUsageTime;
        this.weeklyUsageTime = weeklyUsageTime;
        this.monthlyUsageTime = monthlyUsageTime;
    }

    public Map<String, Object> toMap() {
        Map<String, Object> map = new HashMap<>();
        map.put("packageName", packageName);
        map.put("name", name);
        map.put("dailyUsageTime", dailyUsageTime);
        map.put("weeklyUsageTime", weeklyUsageTime);
        map.put("monthlyUsageTime", monthlyUsageTime);
        return map;
    }

}
