@isTest
private class AccountTriggerHandlerTest {
    @isTest static void testProcessBeforeInsertWithBypass() {
        TriggerBypassUtility.enableBypassAccountTrigger();

        Test.startTest();
        Account testAccount = new Account(Name='Test Account', SLA__c=GlobalConsts.ACCOUNT_SLA_GOLD, CustomerPriority__c=GlobalConsts.ACCOUNT_PRIORITY_LOW);
        insert testAccount;
        Test.stopTest();

        Account insertedAccount = [SELECT Id, Name FROM Account WHERE Id = :testAccount.Id];
        System.assertNotEquals(null, insertedAccount);

        TriggerBypassUtility.disableBypassAccountTrigger();
    }

    @isTest static void testProcessBeforeInsertWithBypassForUser() {
        Id userId = UserInfo.getUserId();
        TriggerBypassUtility.enableBypassTriggersForUser(userId);

        Test.startTest();
        Account testAccount = new Account(Name='Test Account', SLA__c=GlobalConsts.ACCOUNT_SLA_GOLD, CustomerPriority__c=GlobalConsts.ACCOUNT_PRIORITY_LOW);
        insert testAccount;
        Test.stopTest();

        Account insertedAccount = [SELECT Id, Name FROM Account WHERE Id = :testAccount.Id];
        System.assertNotEquals(null, insertedAccount);

        TriggerBypassUtility.disableBypassTriggersForUser(userId);
    }    

    @isTest static void testProcessBeforeInsertWithoutBypass() {
        Account testAccount = new Account(Name='Test Account', SLA__c=GlobalConsts.ACCOUNT_SLA_GOLD, CustomerPriority__c=GlobalConsts.ACCOUNT_PRIORITY_LOW);
        
        Test.startTest();
        try {
            insert testAccount;
        } catch (DmlException e) {
            System.assert(e.getMessage().contains(GlobalConsts.ACCOUNT_ERROR_MESSAGE_PRIORITY_BEFORE_INSERT));
        }
        Test.stopTest();
    }

    @isTest static void testProcessBeforeUpdate() {
        Account testAccount = new Account(Name='Test Account', SLA__c=GlobalConsts.ACCOUNT_SLA_GOLD, CustomerPriority__c=GlobalConsts.ACCOUNT_PRIORITY_HIGH);
        insert testAccount;

        Test.startTest();
        testAccount.CustomerPriority__c = GlobalConsts.ACCOUNT_PRIORITY_LOW;
        try {
            update testAccount;
        } catch (DmlException e) {
            System.assert(e.getMessage().contains(GlobalConsts.ACCOUNT_ERROR_MESSAGE_PRIORITY_BEFORE_UPDATE));
        }
        Test.stopTest();
    }

    @isTest static void testValidatePriorityBeforeUpdateSetsIndustry() {
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;

        testAccount.CustomerPriority__c = GlobalConsts.ACCOUNT_PRIORITY_HIGH;
        testAccount.SLA__c = GlobalConsts.ACCOUNT_SLA_GOLD;

        Test.startTest();
        update testAccount;
        Test.stopTest();

        Account updatedAccount = [SELECT Industry FROM Account WHERE Id = :testAccount.Id];

        System.assertEquals(GlobalConsts.ACCOUNT_INDUSTRY_BANKING, updatedAccount.Industry);
    }    
}
