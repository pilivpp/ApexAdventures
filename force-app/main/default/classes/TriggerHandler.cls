public abstract class TriggerHandler {
    public void run() {        
        if (Trigger.isBefore && Trigger.isInsert) {
            processBeforeInsert();
        }
        if (Trigger.isBefore && Trigger.isUpdate) {
            processBeforeUpdate();
        }     
    }    
    
    abstract protected void processBeforeInsert();
    abstract protected void processBeforeUpdate();

}