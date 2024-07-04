@IsTest
private class GithubCommitsControllerTests {
    public static final String SUCCESS_MESSAGE = 'Success';
    public static final String MESSAGE_KEY = 'message';
    public static final String CONTENT_TYPE_HEADER = 'Content-Type';
    public static final String CONTENT_TYPE_JSON = 'application/json';
    private static final String TEST_SHA = '123abc';
    private static final String INVALID_JSON = 'Invalid Json';    

    @IsTest
    static void testFetchCommitsSuccess() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        Test.startTest();
        String response = GithubCommitsController.fetchCommits();
        Test.stopTest();
        
        JsonWrapperResponse jsonReponse = (JsonWrapperResponse) JSON.deserialize(response, JsonWrapperResponse.class);
        String messageKeyValue = jsonReponse.message;

        System.assertEquals(SUCCESS_MESSAGE, messageKeyValue);        
    }

    @IsTest
    static void testFetchCommitsFailure() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseErrorGenerator());

        Test.startTest();
        try {            
            String response = GithubCommitsController.fetchCommits();            
        } catch (AuraHandledException e) {            
            System.assert(e.getMessage().contains(GlobalConsts.ERROR_FETCHING_COMMITS));
        }
        Test.stopTest();        

        List<Log__c> errorLogs = [SELECT Id, Name FROM Log__c];            
        System.assertEquals(1, errorLogs.size());
        System.assertEquals(GlobalConsts.FETCH_COMMITS_ERROR, errorLogs[0].Name);        
    }

    @IsTest
    static void testCreateCaseSuccess() {
        CaseCommitWrapper wrapper = new CaseCommitWrapper();
        wrapper.sha = TEST_SHA;
        String commitDataJson = JSON.serialize(wrapper);

        Test.startTest();
        String caseId = GithubCommitsController.createCase(commitDataJson);
        Test.stopTest();

        System.assertNotEquals(null, caseId);        
    }

    @IsTest
    static void testCreateCaseFailure() {
        Test.startTest();
        try {
            GithubCommitsController.createCase(INVALID_JSON); 
        }
        catch (AuraHandledException e) {
            System.assert(e.getMessage().contains(GlobalConsts.ERROR_CREATING_CASE));            
        }        
        Test.stopTest();    

        List<Log__c> errorLogs = [SELECT Id, Name FROM Log__c];            
        System.assertEquals(1, errorLogs.size());
        System.assertEquals(GlobalConsts.CREATE_COMMITS_ERROR, errorLogs[0].Name);                
    }    

    private class CaseCommitWrapper {
        public String sha;
    }

    private class JsonWrapperResponse {
        String message;

        public JsonWrapperResponse(String message) {
            this.message = message;
        }
    }
    
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader(CONTENT_TYPE_HEADER, CONTENT_TYPE_JSON);            
            JsonWrapperResponse jsonBody = new JsonWrapperResponse(SUCCESS_MESSAGE);
            res.setBody(JSON.serialize(jsonBody));
            res.setStatusCode(200);

            return res;
        }
    }

    private class MockHttpResponseErrorGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader(CONTENT_TYPE_HEADER, CONTENT_TYPE_JSON);
            res.setBody(null);
            res.setStatusCode(500);

            return res;
        }
    }    
}
