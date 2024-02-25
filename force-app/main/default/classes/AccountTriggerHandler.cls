public with sharing class AccountTriggerHandler extends TriggerHandler{
    protected override void processBeforeInsert() {
        if (TriggerBypassUtility.shouldBypass(UserInfo.getUserId())) {
            return;
        }
        AccountTriggerHelper.validatePriorityBeforeInsert(Trigger.new);
    }
    
    protected override void processBeforeUpdate() {
        if (TriggerBypassUtility.shouldBypass(UserInfo.getUserId())) {
            return;
        }        
        AccountTriggerHelper.validatePriorityBeforeUpdate(Trigger.new);
    }
}