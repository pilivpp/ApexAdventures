public with sharing class GithubCommitsService {
    public static final String CALLOUT_GITHUB = 'callout:Github/';

    public static HttpRequest createRequest() {
        try {
            APISettings__mdt settings = [SELECT Endpoint__c FROM APISettings__mdt WHERE MasterLabel = 'GitHubEndpoint' AND Is_Active__c = true LIMIT 1];            
            HttpRequest request = new HttpRequest();
            String endpoint = CALLOUT_GITHUB + settings.Endpoint__c;
            request.setEndpoint(endpoint);
            request.setMethod('GET');
    
            return request;            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public static String catchResponse(HttpRequest request) {
        try {
            Http http = new Http();
            HttpResponse response = http.send(request);

            return response.getBody();             
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());            
        }
    }
}