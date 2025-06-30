package fayoum.university.mobi_wall;
import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Build;
import androidx.annotation.RequiresApi;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

public class InstalledAppsProvider {
    private final Context context;

    public InstalledAppsProvider(Context context) {
        this.context = context;
    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    public List<Map<String, Object>> getInstalledApps() {


        /* Getting app usages */
        AppUsagesStats appUsageStats = new AppUsagesStats(context);
        Map<String, AppUsageModel> appUsageMap = new HashMap<>();

        List<AppUsageModel> monthly = appUsageStats.getMonthlyAppUsage();


        for (AppUsageModel appUsage : monthly) {
            appUsage.setMonthlyUsageTime(appUsage.getUsageTime());
            appUsageMap.put(appUsage.getPackageName(), appUsage);
        }

        List<AppUsageModel> weekly = appUsageStats.getWeeklyAppUsage();


        for (AppUsageModel appUsage : weekly) {
            Objects.requireNonNull(appUsageMap.get(appUsage.getPackageName())).setWeeklyUsageTime(appUsage.getUsageTime());
        }

        List<AppUsageModel> daily = appUsageStats.getDailyAppUsage();

        for (AppUsageModel appUsage : daily) {
            Objects.requireNonNull(appUsageMap.get(appUsage.getPackageName())).setDailyUsageTime(appUsage.getUsageTime());
        }


        ///////////////////////////////////////////////////////////////////////////////////////////////

        List<Map<String, Object>> installedApps = new ArrayList<>();

        PackageManager packageManager = context.getPackageManager();


        int flags = PackageManager.GET_META_DATA |
            PackageManager.GET_SHARED_LIBRARY_FILES |
            PackageManager.GET_UNINSTALLED_PACKAGES;

        List<PackageInfo> packageInfo = packageManager.getInstalledPackages(flags);


        for (PackageInfo info : packageInfo) {
//            if ((info.applicationInfo.flags & (ApplicationInfo.FLAG_UPDATED_SYSTEM_APP | ApplicationInfo.FLAG_SYSTEM)) <= 0) {
            if ((info.applicationInfo.flags & ApplicationInfo.FLAG_SYSTEM) == 1 && (!info.packageName.contains("youtube"))) continue;
//            if (!((info.applicationInfo.flags &(ApplicationInfo.FLAG_UPDATED_SYSTEM_APP | ApplicationInfo.FLAG_SYSTEM)) != 0)) {

                long dailyUsage = 0;
                long weeklyUsage = 0;
                long monthlyUsage = 0;


                if (appUsageMap.containsKey(info.packageName)) {

                    dailyUsage = Objects.requireNonNull(appUsageMap.get(info.packageName)).getDailyUsageTime();
                    weeklyUsage = Objects.requireNonNull(appUsageMap.get(info.packageName)).getWeeklyUsageTime();
                    monthlyUsage = Objects.requireNonNull(appUsageMap.get(info.packageName)).getMonthlyUsageTime();

                }

                installedApps.add(new AppDataModel(info.packageName, packageManager.getApplicationLabel(info.applicationInfo).toString(), dailyUsage, weeklyUsage, monthlyUsage).toMap());
        }

        return installedApps;
    }

    public List<Map<String, Object>> getDummyInstalledApps(){
        List<Map<String, Object>> dummyApps = new ArrayList<>();

        for (AppDataModel appData : AppDataModel.getDummyAppDataList()) {
            dummyApps.add(appData.toMap());
        }

        return dummyApps;
    }

}


