package fayoum.university.mobi_wall;

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
    }
