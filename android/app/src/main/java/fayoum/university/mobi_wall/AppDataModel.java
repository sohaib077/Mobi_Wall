package fayoum.university.mobi_wall;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
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

    // Helper method to create dummy data
    public static List<AppDataModel> getDummyAppDataList() {
        List<AppDataModel> appDataList = new ArrayList<>();

        // Social Media Apps
        appDataList.add(new AppDataModel("com.instagram.android", "Instagram", 
                7200000L, 50400000L, 216000000L)); // 2 hours daily
        
        appDataList.add(new AppDataModel("com.whatsapp", "WhatsApp", 
                5400000L, 37800000L, 162000000L)); // 1.5 hours daily
        
        appDataList.add(new AppDataModel("com.facebook.katana", "Facebook", 
                3600000L, 25200000L, 108000000L)); // 1 hour daily
        
        appDataList.add(new AppDataModel("com.zhiliaoapp.musically", "TikTok", 
                9000000L, 63000000L, 270000000L)); // 2.5 hours daily
        
        appDataList.add(new AppDataModel("com.twitter.android", "Twitter", 
                2700000L, 18900000L, 81000000L)); // 45 minutes daily

        // Gaming Apps
        appDataList.add(new AppDataModel("com.tencent.ig", "PUBG Mobile", 
                10800000L, 75600000L, 324000000L)); // 3 hours daily
        
        appDataList.add(new AppDataModel("com.activision.callofduty.shooter", "Call of Duty Mobile", 
                5400000L, 37800000L, 162000000L)); // 1.5 hours daily
        
        appDataList.add(new AppDataModel("com.supercell.clashroyale", "Clash Royale", 
                1800000L, 12600000L, 54000000L)); // 30 minutes daily
        
        appDataList.add(new AppDataModel("com.king.candycrushsaga", "Candy Crush Saga", 
                1200000L, 8400000L, 36000000L)); // 20 minutes daily
        
        appDataList.add(new AppDataModel("com.mojang.minecraftpe", "Minecraft", 
                3600000L, 25200000L, 108000000L)); // 1 hour daily

        // Learning Apps
        appDataList.add(new AppDataModel("com.duolingo", "Duolingo", 
                1800000L, 12600000L, 54000000L)); // 30 minutes daily
        
        appDataList.add(new AppDataModel("org.khanacademy.android", "Khan Academy", 
                2700000L, 18900000L, 81000000L)); // 45 minutes daily
        
        appDataList.add(new AppDataModel("org.coursera.android", "Coursera", 
                3600000L, 25200000L, 108000000L)); // 1 hour daily
        
        appDataList.add(new AppDataModel("com.udemy.android", "Udemy", 
                2700000L, 18900000L, 81000000L)); // 45 minutes daily
        
        appDataList.add(new AppDataModel("com.microblink.photomath", "Photomath", 
                900000L, 6300000L, 27000000L)); // 15 minutes daily

        // Other Popular Apps
        appDataList.add(new AppDataModel("com.google.android.youtube", "YouTube", 
                14400000L, 100800000L, 432000000L)); // 4 hours daily
        
        appDataList.add(new AppDataModel("com.netflix.mediaclient", "Netflix", 
                7200000L, 50400000L, 216000000L)); // 2 hours daily
        
        appDataList.add(new AppDataModel("com.spotify.music", "Spotify", 
                10800000L, 75600000L, 324000000L)); // 3 hours daily

        return appDataList;
    }

    // Getter methods
    public String getPackageName() {
        return packageName;
    }

    public String getName() {
        return name;
    }

    public long getDailyUsageTime() {
        return dailyUsageTime;
    }

    public long getWeeklyUsageTime() {
        return weeklyUsageTime;
    }

    public long getMonthlyUsageTime() {
        return monthlyUsageTime;
    }

}
