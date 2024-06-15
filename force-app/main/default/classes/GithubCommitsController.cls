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

    private static AuraHandledException newAuraHandleException(String message) {
        AuraHandledException auraHandleException = new AuraHandledException(message);
        auraHandleException.setMessage(message);
        return auraHandleException;
    }
}