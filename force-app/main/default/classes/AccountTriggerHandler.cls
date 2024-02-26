public with sharing class AccountTriggerHandler extends TriggerHandler{
    protected override void processBeforeInsert() {
        if (!TriggerBypassUtility.shouldBypass(UserInfo.getUserId())) {
            AccountTriggerHelper.validatePriorityBeforeInsert(Trigger.new);
        }        
    }
    
    protected override void processBeforeUpdate() {
        if (!TriggerBypassUtility.shouldBypass(UserInfo.getUserId())) {
            AccountTriggerHelper.validatePriorityBeforeUpdate(Trigger.new);
        }                
    }
}