package fayoum.university.mobi_wall;

import android.app.usage.UsageStats;
import android.app.usage.UsageStatsManager;
import android.content.Context;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

public class AppUsagesStats {
    private final UsageStatsManager usageStatsManager;

    public AppUsagesStats(Context context) {
        this.usageStatsManager = (UsageStatsManager) context.getSystemService(Context.USAGE_STATS_SERVICE);
    }

    public List<AppUsageModel> getDailyAppUsage() {
        return getAppUsageStats(UsageStatsManager.INTERVAL_DAILY,-1);
    }

    public List<AppUsageModel> getWeeklyAppUsage() {
        return getAppUsageStats(UsageStatsManager.INTERVAL_WEEKLY,-7);
    }

    public List<AppUsageModel> getMonthlyAppUsage() {
        return getAppUsageStats(UsageStatsManager.INTERVAL_MONTHLY,-30);
    }

    private List<AppUsageModel> getAppUsageStats(int interval, int amount) {
        List<AppUsageModel> appUsages = new ArrayList<>();

        Calendar calendar = Calendar.getInstance();
        long endTime = calendar.getTimeInMillis();
        calendar.add(Calendar.DAY_OF_MONTH, amount);
        long startTime = calendar.getTimeInMillis();

        List<UsageStats> usageStatsList;
        usageStatsList = usageStatsManager.queryUsageStats(interval, startTime, endTime);


        if (usageStatsList != null && !usageStatsList.isEmpty()) {
            for (UsageStats usageStats : usageStatsList) {
                AppUsageModel appUsage = new AppUsageModel();
                if (usageStats.getPackageName() != null) {
                    appUsage.setPackageName(usageStats.getPackageName());
                    appUsage.setUsageTime(usageStats.getTotalTimeInForeground());
                    appUsages.add(appUsage);
                }
            }
        }

        return appUsages;
    }
}

