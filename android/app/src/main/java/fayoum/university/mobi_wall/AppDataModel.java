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
        return map;    }

    // Helper method to create dummy data
    public static List<AppDataModel> getDummyAppDataList() {
        List<AppDataModel> appDataList = new ArrayList<>();

        // Watching Series Apps
        appDataList.add(new AppDataModel("com.google.android.youtube", "YouTube", 
                7200000L, 50400000L, 216000000L)); // 120 minutes daily
        
        appDataList.add(new AppDataModel("com.netflix.mediaclient", "Netflix", 
                5400000L, 37800000L, 162000000L)); // 90 minutes daily
        
        appDataList.add(new AppDataModel("com.disney.disneyplus", "Disney+", 
                4500000L, 31500000L, 135000000L)); // 75 minutes daily

        // Learning Apps
        appDataList.add(new AppDataModel("com.duolingo", "Duolingo", 
                3600000L, 25200000L, 108000000L)); // 60 minutes daily
        
        appDataList.add(new AppDataModel("com.khanacademy.android", "Khan Academy", 
                3000000L, 21000000L, 90000000L)); // 50 minutes daily
        
        appDataList.add(new AppDataModel("com.coursera.android", "Coursera", 
                4200000L, 29400000L, 126000000L)); // 70 minutes daily
        
        appDataList.add(new AppDataModel("com.udemy.android", "Udemy", 
                3900000L, 27300000L, 117000000L)); // 65 minutes daily

        // Games Apps
        appDataList.add(new AppDataModel("com.minecraft", "Minecraft", 
                5400000L, 37800000L, 162000000L)); // 90 minutes daily
        
        appDataList.add(new AppDataModel("com.pubg.krmobile", "PUBG Mobile", 
                4500000L, 31500000L, 135000000L)); // 75 minutes daily
        
        appDataList.add(new AppDataModel("com.clashofclans", "Clash of Clans", 
                3300000L, 23100000L, 99000000L)); // 55 minutes daily

        // Music Apps
        appDataList.add(new AppDataModel("com.spotify.music", "Spotify", 
                1500000L, 10500000L, 45000000L)); // 25 minutes daily
        
        appDataList.add(new AppDataModel("com.soundcloud.android", "SoundCloud", 
                1200000L, 8400000L, 36000000L)); // 20 minutes daily

        // Social Media Apps
        appDataList.add(new AppDataModel("com.whatsapp", "WhatsApp", 
                1800000L, 12600000L, 54000000L)); // 30 minutes daily
        
        appDataList.add(new AppDataModel("com.instagram.android", "Instagram", 
                2400000L, 16800000L, 72000000L)); // 40 minutes daily
        
        appDataList.add(new AppDataModel("com.facebook.katana", "Facebook", 
                3000000L, 21000000L, 90000000L)); // 50 minutes daily
        
        appDataList.add(new AppDataModel("com.twitter.android", "Twitter", 
                2100000L, 14700000L, 63000000L)); // 35 minutes daily
        
        appDataList.add(new AppDataModel("com.tiktok", "TikTok", 
                3000000L, 21000000L, 90000000L)); // 50 minutes daily

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
