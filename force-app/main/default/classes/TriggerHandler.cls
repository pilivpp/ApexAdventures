public abstract class TriggerHandler {
    public void run() {        
        if (!TriggerBypassUtility.shouldBypass(UserInfo.getUserId())) {
            if (Trigger.isBefore && Trigger.isInsert) {
                processBeforeInsert();
            }
            if (Trigger.isBefore && Trigger.isUpdate) {
                processBeforeUpdate();
            }                
        }
    }        
    abstract protected void processBeforeInsert();
    abstract protected void processBeforeUpdate();
}