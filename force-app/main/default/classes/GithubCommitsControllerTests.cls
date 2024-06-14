@IsTest
private class GithubCommitsControllerTests {
    public static final String SUCCESS_MESSAGE = 'Success';
    public static final String FAILURE_MESSAGE = 'Failure';
    public static final String MESSAGE_KEY = 'message';
    public static final String CONTENT_TYPE_HEADER = 'Content-Type';
    public static final String CONTENT_TYPE_JSON = 'application/json';
    public static final String SUCCESS_BODY = '{"' + MESSAGE_KEY + '":"' + SUCCESS_MESSAGE + '"}';
    public static final String FAILURE_BODY = '{"' + MESSAGE_KEY + '":"' + FAILURE_MESSAGE + '"}';

    @IsTest
    static void testFetchCommitsSuccess() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        String response = GithubCommitsController.fetchCommits();
        Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(response);
        String messageKeyValue = (String) jsonResponse.get(MESSAGE_KEY);

        System.assertEquals(SUCCESS_MESSAGE, messageKeyValue);        
    }

    @IsTest
    static void testFetchCommitsFailure() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseErrorGenerator());

        try {
            String response = GithubCommitsController.fetchCommits();
        } catch (AuraHandledException e) {
            System.assertEquals(FAILURE_MESSAGE, e.getMessage());
        }
    }
    
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader(CONTENT_TYPE_HEADER, CONTENT_TYPE_JSON);
            res.setBody(SUCCESS_BODY);
            res.setStatusCode(200);

            return res;
        }
    }

    private class MockHttpResponseErrorGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader(CONTENT_TYPE_HEADER, CONTENT_TYPE_JSON);
            res.setBody(FAILURE_BODY);
            res.setStatusCode(500);

            return res;
        }
    }    
}
