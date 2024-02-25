public with sharing class AccountTriggerHelper {
    public static void validatePriorityBeforeInsert(List<Account> accounts) {
        for (Account account : accounts) {
            if (account.SLA__c == GlobalConsts.ACCOUNT_SLA_GOLD && account.CustomerPriority__c != GlobalConsts.ACCOUNT_PRIORITY_HIGH) {
                account.addError(GlobalConsts.ACCOUNT_ERROR_MESSAGE_PRIORITY_BEFORE_INSERT);                     
            }
        }   
    }
    
    public static void validatePriorityBeforeUpdate(List<Account> accounts) {
        for (Account account : accounts) {
            if (account.SLA__c == GlobalConsts.ACCOUNT_SLA_GOLD && account.CustomerPriority__c != GlobalConsts.ACCOUNT_PRIORITY_HIGH) {
                account.addError(GlobalConsts.ACCOUNT_ERROR_MESSAGE_PRIORITY_BEFORE_UPDATE);                
            } else {
                account.Industry = GlobalConsts.ACCOUNT_INDUSTRY_BANKING;                
            }
        }        
    }
}