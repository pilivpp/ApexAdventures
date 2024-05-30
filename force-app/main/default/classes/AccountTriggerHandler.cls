public with sharing class AccountTriggerHandler extends TriggerHandler{
    public AccountTriggerHandler(String triggerName) {
        super(triggerName);
    }

    protected override void processBeforeInsert() {
        AccountTriggerHelper.validatePriorityBeforeInsert(Trigger.new);     
    }
    
    protected override void processBeforeUpdate() {
        AccountTriggerHelper.validatePriorityBeforeUpdate(Trigger.new);
    }
}