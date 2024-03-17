public virtual class TriggerHandler {
    private String triggerName;

    public TriggerHandler(String triggerName) {
        this.triggerName = triggerName;
    }

    public void run() {        
        if (!TriggerBypassUtility.shouldBypass(this.triggerName, UserInfo.getUserId())) {
            if (Trigger.isBefore && Trigger.isInsert) {
                processBeforeInsert();
            }
            if (Trigger.isBefore && Trigger.isUpdate) {
                processBeforeUpdate();
            }         
            if (Trigger.isAfter && Trigger.isInsert) {
                processAfterInsert();
            }
            if (Trigger.isAfter && Trigger.isUpdate) {
                processAfterUpdate();
            }
            if (Trigger.isBefore && Trigger.isDelete) {
                processBeforeDelete();
            }
            if (Trigger.isAfter && Trigger.isDelete) {
                processAfterDelete();
            }    
            if (Trigger.isAfter && Trigger.isUndelete) {
                processAfterUndelete();
            }                      
        }
    }        
    protected virtual void processBeforeInsert() {}
    protected virtual void processBeforeUpdate() {}    
    protected virtual void processAfterInsert() {}
    protected virtual void processAfterUpdate() {}    
    protected virtual void processBeforeDelete() {}   
    protected virtual void processAfterDelete() {}
    protected virtual void processAfterUndelete() {}
}
