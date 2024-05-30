@isTest
private class AccountTriggerHandlerTest {
    @isTest static void testProcessBeforeInsertWithBypass() {
        TriggerBypassUtility.disableTrigger('AccountTrigger');

        Test.startTest();
        Account testAccount = TestDataFactory.createAccount('Test Account', GlobalConsts.ACCOUNT_SLA_GOLD, GlobalConsts.ACCOUNT_PRIORITY_LOW, true);
        Test.stopTest();

        Account insertedAccount = [SELECT Id, Name FROM Account WHERE Id = :testAccount.Id];
        System.assertNotEquals(null, insertedAccount);

        TriggerBypassUtility.enableTrigger('AccountTrigger');
    }

    @isTest static void testProcessBeforeInsertWithBypassForUser() {
        Id userId = UserInfo.getUserId();
        TriggerBypassUtility.enableBypassTriggersForUser(userId);

        Test.startTest();
        Account testAccount = TestDataFactory.createAccount('Test Account', GlobalConsts.ACCOUNT_SLA_GOLD, GlobalConsts.ACCOUNT_PRIORITY_LOW, true);
        Test.stopTest();

        Account insertedAccount = [SELECT Id, Name FROM Account WHERE Id = :testAccount.Id];
        System.assertNotEquals(null, insertedAccount);

        TriggerBypassUtility.disableBypassTriggersForUser(userId);
    }    

    @isTest static void testProcessBeforeInsertWithoutBypass() {
        Account testAccount = TestDataFactory.createAccount('Test Account', GlobalConsts.ACCOUNT_SLA_GOLD, GlobalConsts.ACCOUNT_PRIORITY_LOW, false);
        String errorMessage = '';
        
        Test.startTest();
        try {
            insert testAccount;            
        } catch (DmlException e) {        
            errorMessage = e.getMessage();
        }        
        Test.stopTest();

        System.assert(errorMessage.contains(GlobalConsts.ACCOUNT_ERROR_MESSAGE_PRIORITY_BEFORE_INSERT));
    }

    @isTest static void testProcessBeforeUpdate() {
        Account testAccount = TestDataFactory.createAccount('Test Account',  GlobalConsts.ACCOUNT_SLA_GOLD, GlobalConsts.ACCOUNT_PRIORITY_HIGH, true);
        String errorMessage = '';

        Test.startTest();
        try {
            testAccount.CustomerPriority__c = GlobalConsts.ACCOUNT_PRIORITY_LOW;            
            update testAccount;            
        } catch (DmlException e) {        
            errorMessage = e.getMessage();
        }        
        Test.stopTest();

        System.assert(errorMessage.contains(GlobalConsts.ACCOUNT_ERROR_MESSAGE_PRIORITY_BEFORE_UPDATE));
    }

    @isTest static void testValidatePriorityBeforeUpdateSetsIndustry() {
        Account testAccount = TestDataFactory.createAccount('Test Account', null, GlobalConsts.ACCOUNT_PRIORITY_HIGH, true);
        testAccount.SLA__c = GlobalConsts.ACCOUNT_SLA_GOLD;

        Test.startTest();
        update testAccount;
        Test.stopTest();

        Account updatedAccount = [SELECT Industry FROM Account WHERE Id = :testAccount.Id];

        System.assertEquals(GlobalConsts.ACCOUNT_INDUSTRY_BANKING, updatedAccount.Industry);
    }    
}
