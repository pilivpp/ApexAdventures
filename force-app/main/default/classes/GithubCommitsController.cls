public with sharing class GithubCommitsController {
    public static final String CALLOUT_GITHUB = 'callout:Github/';
    private static final String COMMIT_SUPPORT_RECORD_TYPE_NAME = 'Commit_Support';

    @AuraEnabled(cacheable=true)
    public static String fetchCommits() {
        try {
            HttpRequest request = GithubCommitsService.createRequest();
            String response = GithubCommitsService.catchResponse(request);

            return response;
        } catch (Exception e) {
            Log__c commitErrorLog = new Log__c(
                Name = GlobalConsts.FETCH_COMMITS_ERROR,
                Error_Description__c = GlobalConsts.ERROR_FETCHING_COMMITS + ' ' + e.getMessage()
            );

            insert commitErrorLog;
            throw caseCommitSupportException(GlobalConsts.ERROR_FETCHING_COMMITS + ' ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static String createCase(String commitDataJson) {
        try {
            CaseCommitWrapper commitData = (CaseCommitWrapper) JSON.deserialize(commitDataJson, CaseCommitWrapper.class);
            
            Id commitSupportRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName()
                .get(COMMIT_SUPPORT_RECORD_TYPE_NAME).getRecordTypeId();
            
            Case newCaseWithCommit = new Case(
                Commit_SHA__c = commitData.sha,
                RecordTypeId = commitSupportRecordTypeId,
                Priority = GlobalConsts.CASE_PRIORITY_HIGH
            );

            insert newCaseWithCommit;
            return newCaseWithCommit.Id;
        } catch (Exception e) {
            Log__c commitErrorLog = new Log__c(
                Name = GlobalConsts.CREATE_COMMITS_ERROR,
                Error_Description__c = GlobalConsts.ERROR_CREATING_CASE + ' ' + e.getMessage()
            );

            insert commitErrorLog;
            throw caseCommitSupportException(GlobalConsts.ERROR_CREATING_CASE + ' ' + e.getMessage());
        }
    }

    private static AuraHandledException caseCommitSupportException(String message) {
        AuraHandledException auraHandleException = new AuraHandledException(message);
        auraHandleException.setMessage(message);
        
        return auraHandleException;
    }

    private class CaseCommitWrapper {
        @AuraEnabled public String sha;
    }
}