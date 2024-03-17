public with sharing class TriggerBypassUtility {
    private static Boolean bypassAccountTrigger  = false;
    private static Set<Id> bypassUserIds = new Set<Id>();
    private static Map<String, Boolean> bypassTriggers = new Map<String, Boolean>();

    static {
        loadBypassSettings();
    }

    public static void enableTrigger(String triggerName) {
        bypassTriggers.put(triggerName, false); 
    }

    public static void disableTrigger(String triggerName) {
        bypassTriggers.put(triggerName, true); 
    }

    public static void enableBypassTriggersForUser(Id userId) {
        bypassUserIds.add(userId);
    }

    public static void disableBypassTriggersForUser(Id userId) {
        bypassUserIds.add(userId);
    }    

    public static Boolean shouldBypass(String triggerName, Id userId) {
        Boolean bypassForUser = bypassUserIds.contains(userId);
        Boolean bypassForTrigger = bypassTriggers.containsKey(triggerName) && bypassTriggers.get(triggerName);
        return bypassForUser || bypassForTrigger;
    }

    private static void loadBypassSettings() {
        List<BypassTrigger__mdt> settings = [SELECT UserId__c FROM BypassTrigger__mdt WHERE IsActive__c = TRUE];
        
        for (BypassTrigger__mdt setting : settings) {
            bypassUserIds.add(setting.UserId__c);
        }
    }    
}