public class TestDataFactory {
    public static Account createAccount(String name, String sla, String customerPriority, Boolean insertRecord) {
        Account acc = new Account(
            Name = name,
            SLA__c = sla,
            CustomerPriority__c = customerPriority
        );

        if (insertRecord) {
            insert acc;
        }

        return acc;
    }
}
