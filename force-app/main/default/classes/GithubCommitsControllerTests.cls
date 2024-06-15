@IsTest
private class GithubCommitsControllerTests {
    public static final String SUCCESS_MESSAGE = 'Success';
    public static final String FAILURE_MESSAGE = 'Failure';
    public static final String MESSAGE_KEY = 'message';
    public static final String CONTENT_TYPE_HEADER = 'Content-Type';
    public static final String CONTENT_TYPE_JSON = 'application/json';

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

        try {
            Test.startTest();
            String response = GithubCommitsController.fetchCommits();
            Test.stopTest();
        } catch (AuraHandledException e) {
            System.assertEquals(FAILURE_MESSAGE, e.getMessage());
        }
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
            JsonWrapperResponse jsonBody = new JsonWrapperResponse(FAILURE_MESSAGE);
            res.setBody(JSON.serialize(jsonBody));
            res.setStatusCode(500);

            return res;
        }
    }    
}
