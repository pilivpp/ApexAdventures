public with sharing class TriggerBypassUtility {
    private static Boolean bypassAccountTrigger  = false;
    private static Set<Id> bypassUserIds = new Set<Id>();

    public static void enableBypassAccountTrigger() {
        bypassAccountTrigger = true;
    }
    
    public static void disableBypassAccountTrigger() {
        bypassAccountTrigger = false;
    }

    public static void enableBypassTriggersForUser(Id userId) {
        bypassUserIds.add(userId);
    }

    public static void disableBypassTriggersForUser(Id userId) {
        bypassUserIds.add(userId);
    }    

    public static Boolean shouldBypass(Id userId) {
        return  bypassAccountTrigger || bypassUserIds.contains(userId);
    }
}