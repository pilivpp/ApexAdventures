public with sharing class GithubCommitsController {
    public static final String CALLOUT_GITHUB = 'callout:Github/';

    @AuraEnabled(cacheable=true)
    public static String fetchCommits() {
        try {            
            HttpRequest request = GithubCommitsService.createRequest();
            String response = GithubCommitsService.catchResponse(request);

            return response;            
        } catch (Exception e) {
            throw newAuraHandleException(GlobalConsts.ERROR_FETCHING_COMMITS + ' ' + e.getMessage());
        }        
    }

    @AuraEnabled
    public static String createCase(String commitDataJson){
        try {
            CaseCommitWrapper commitData = (caseCommitWrapper) JSON.deserialize(commitDataJson, CaseCommitWrapper.class);
            Case newCaseWithCommit = new Case(
                Commit_SHA__c = commitData.sha
            );

            insert newCaseWithCommit;
            return newCaseWithCommit.Id;
        } catch (Exception e) {
            throw newAuraHandleException(GlobalConsts.ERROR_CREATING_CASE + ' ' + e.getMessage());
        }
    }

    private static AuraHandledException newAuraHandleException(String message) {
        AuraHandledException auraHandleException = new AuraHandledException(message);
        auraHandleException.setMessage(message);
        return auraHandleException;
    }

    private class CaseCommitWrapper {
        @AuraEnabled
        public String sha;
    }
}