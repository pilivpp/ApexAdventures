public class GitHubCommitsHandler {
    @AuraEnabled(cacheable=true)
    public static String fetchCommits() {
        APISettings__mdt settings = [SELECT Endpoint__c FROM APISettings__mdt WHERE MasterLabel = 'GitHubEndpoint' AND Is_Active__c = true LIMIT 1];

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = 'callout:Github/' + settings.Endpoint__c;
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            return response.getBody(); 
        } else {
            System.debug('HTTP Error: '+response.getStatusCode()+' '+response.getStatus());
            return null;
        }
    }
}
