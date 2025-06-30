package fayoum.university.mobi_wall;

import java.util.ArrayList;
import java.util.List;

public  class AppUsageModel {
        private String packageName;
        private long usageTime;
        private long dailyUsageTime;
        private long weeklyUsageTime;
        private long monthlyUsageTime;

        public String getPackageName() {
            return packageName;
        }

        public void setPackageName(String packageName) {
            this.packageName = packageName;
        }


        public long getDailyUsageTime() {
            return dailyUsageTime;
        }

        public void setDailyUsageTime(long dailyUsageTime) {
            this.dailyUsageTime = dailyUsageTime;
        }

        public long getWeeklyUsageTime() {
            return weeklyUsageTime;
        }

        public void setWeeklyUsageTime(long weeklyUsageTime) {
            this.weeklyUsageTime = weeklyUsageTime;
        }

        public long getMonthlyUsageTime() {
            return monthlyUsageTime;
        }

        public void setMonthlyUsageTime(long monthlyUsageTime) {
            this.monthlyUsageTime = monthlyUsageTime;
        }

        public long getUsageTime() {
            return usageTime;
        }

        public void setUsageTime(long usageTime) {
            this.usageTime = usageTime;
        }

        // Helper method to create dummy data
        public static List<AppUsageModel> getDummyAppUsageList() {
            List<AppUsageModel> appUsageList = new ArrayList<>();

            // Social Media Apps
            AppUsageModel instagram = new AppUsageModel();
            instagram.setPackageName("com.instagram.android");
            instagram.setUsageTime(7200000); // 2 hours in milliseconds
            instagram.setDailyUsageTime(7200000); // 2 hours
            instagram.setWeeklyUsageTime(50400000); // 14 hours
            instagram.setMonthlyUsageTime(216000000); // 60 hours
            appUsageList.add(instagram);

            AppUsageModel whatsapp = new AppUsageModel();
            whatsapp.setPackageName("com.whatsapp");
            whatsapp.setUsageTime(5400000); // 1.5 hours
            whatsapp.setDailyUsageTime(5400000);
            whatsapp.setWeeklyUsageTime(37800000); // 10.5 hours
            whatsapp.setMonthlyUsageTime(162000000); // 45 hours
            appUsageList.add(whatsapp);

            AppUsageModel facebook = new AppUsageModel();
            facebook.setPackageName("com.facebook.katana");
            facebook.setUsageTime(3600000); // 1 hour
            facebook.setDailyUsageTime(3600000);
            facebook.setWeeklyUsageTime(25200000); // 7 hours
            facebook.setMonthlyUsageTime(108000000); // 30 hours
            appUsageList.add(facebook);

            AppUsageModel tiktok = new AppUsageModel();
            tiktok.setPackageName("com.zhiliaoapp.musically");
            tiktok.setUsageTime(9000000); // 2.5 hours
            tiktok.setDailyUsageTime(9000000);
            tiktok.setWeeklyUsageTime(63000000); // 17.5 hours
            tiktok.setMonthlyUsageTime(270000000); // 75 hours
            appUsageList.add(tiktok);

            AppUsageModel twitter = new AppUsageModel();
            twitter.setPackageName("com.twitter.android");
            twitter.setUsageTime(2700000); // 45 minutes
            twitter.setDailyUsageTime(2700000);
            twitter.setWeeklyUsageTime(18900000); // 5.25 hours
            twitter.setMonthlyUsageTime(81000000); // 22.5 hours
            appUsageList.add(twitter);

            // Gaming Apps
            AppUsageModel pubg = new AppUsageModel();
            pubg.setPackageName("com.tencent.ig");
            pubg.setUsageTime(10800000); // 3 hours
            pubg.setDailyUsageTime(10800000);
            pubg.setWeeklyUsageTime(75600000); // 21 hours
            pubg.setMonthlyUsageTime(324000000); // 90 hours
            appUsageList.add(pubg);

            AppUsageModel codm = new AppUsageModel();
            codm.setPackageName("com.activision.callofduty.shooter");
            codm.setUsageTime(5400000); // 1.5 hours
            codm.setDailyUsageTime(5400000);
            codm.setWeeklyUsageTime(37800000); // 10.5 hours
            codm.setMonthlyUsageTime(162000000); // 45 hours
            appUsageList.add(codm);

            AppUsageModel clashRoyale = new AppUsageModel();
            clashRoyale.setPackageName("com.supercell.clashroyale");
            clashRoyale.setUsageTime(1800000); // 30 minutes
            clashRoyale.setDailyUsageTime(1800000);
            clashRoyale.setWeeklyUsageTime(12600000); // 3.5 hours
            clashRoyale.setMonthlyUsageTime(54000000); // 15 hours
            appUsageList.add(clashRoyale);

            AppUsageModel candyCrush = new AppUsageModel();
            candyCrush.setPackageName("com.king.candycrushsaga");
            candyCrush.setUsageTime(1200000); // 20 minutes
            candyCrush.setDailyUsageTime(1200000);
            candyCrush.setWeeklyUsageTime(8400000); // 2.33 hours
            candyCrush.setMonthlyUsageTime(36000000); // 10 hours
            appUsageList.add(candyCrush);

            AppUsageModel minecraft = new AppUsageModel();
            minecraft.setPackageName("com.mojang.minecraftpe");
            minecraft.setUsageTime(3600000); // 1 hour
            minecraft.setDailyUsageTime(3600000);
            minecraft.setWeeklyUsageTime(25200000); // 7 hours
            minecraft.setMonthlyUsageTime(108000000); // 30 hours
            appUsageList.add(minecraft);

            // Learning Apps
            AppUsageModel duolingo = new AppUsageModel();
            duolingo.setPackageName("com.duolingo");
            duolingo.setUsageTime(1800000); // 30 minutes
            duolingo.setDailyUsageTime(1800000);
            duolingo.setWeeklyUsageTime(12600000); // 3.5 hours
            duolingo.setMonthlyUsageTime(54000000); // 15 hours
            appUsageList.add(duolingo);

            AppUsageModel khanAcademy = new AppUsageModel();
            khanAcademy.setPackageName("org.khanacademy.android");
            khanAcademy.setUsageTime(2700000); // 45 minutes
            khanAcademy.setDailyUsageTime(2700000);
            khanAcademy.setWeeklyUsageTime(18900000); // 5.25 hours
            khanAcademy.setMonthlyUsageTime(81000000); // 22.5 hours
            appUsageList.add(khanAcademy);

            AppUsageModel coursera = new AppUsageModel();
            coursera.setPackageName("org.coursera.android");
            coursera.setUsageTime(3600000); // 1 hour
            coursera.setDailyUsageTime(3600000);
            coursera.setWeeklyUsageTime(25200000); // 7 hours
            coursera.setMonthlyUsageTime(108000000); // 30 hours
            appUsageList.add(coursera);

            AppUsageModel udemy = new AppUsageModel();
            udemy.setPackageName("com.udemy.android");
            udemy.setUsageTime(2700000); // 45 minutes
            udemy.setDailyUsageTime(2700000);
            udemy.setWeeklyUsageTime(18900000); // 5.25 hours
            udemy.setMonthlyUsageTime(81000000); // 22.5 hours
            appUsageList.add(udemy);

            AppUsageModel photomath = new AppUsageModel();
            photomath.setPackageName("com.microblink.photomath");
            photomath.setUsageTime(900000); // 15 minutes
            photomath.setDailyUsageTime(900000);
            photomath.setWeeklyUsageTime(6300000); // 1.75 hours
            photomath.setMonthlyUsageTime(27000000); // 7.5 hours
            appUsageList.add(photomath);

            // Other Popular Apps
            AppUsageModel youtube = new AppUsageModel();
            youtube.setPackageName("com.google.android.youtube");
            youtube.setUsageTime(14400000); // 4 hours
            youtube.setDailyUsageTime(14400000);
            youtube.setWeeklyUsageTime(100800000); // 28 hours
            youtube.setMonthlyUsageTime(432000000); // 120 hours
            appUsageList.add(youtube);

            AppUsageModel netflix = new AppUsageModel();
            netflix.setPackageName("com.netflix.mediaclient");
            netflix.setUsageTime(7200000); // 2 hours
            netflix.setDailyUsageTime(7200000);
            netflix.setWeeklyUsageTime(50400000); // 14 hours
            netflix.setMonthlyUsageTime(216000000); // 60 hours
            appUsageList.add(netflix);

            AppUsageModel spotify = new AppUsageModel();
            spotify.setPackageName("com.spotify.music");
            spotify.setUsageTime(10800000); // 3 hours
            spotify.setDailyUsageTime(10800000);
            spotify.setWeeklyUsageTime(75600000); // 21 hours
            spotify.setMonthlyUsageTime(324000000); // 90 hours
            appUsageList.add(spotify);

            return appUsageList;
        }
    }
