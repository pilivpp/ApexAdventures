public with sharing class AccountTriggerHandler extends TriggerHandler{
    protected override void processBeforeInsert() {
        AccountTriggerHelper.validatePriorityBeforeInsert(Trigger.new);
     
    }
    
    protected override void processBeforeUpdate() {
        AccountTriggerHelper.validatePriorityBeforeUpdate(Trigger.new);
    }
}