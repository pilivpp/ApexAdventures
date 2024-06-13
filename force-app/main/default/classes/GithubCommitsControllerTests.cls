@IsTest
private class GithubCommitsControllerTests {

    @IsTest
    static void testFetchCommitsSuccess() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        String response = GithubCommitsController.fetchCommits();

        System.assert(response.contains('{"message":"Success"}'));        
    }

    @IsTest
    static void testFetchCommitsFailure() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseErrorGenerator());

        try {
            String response = GithubCommitsController.fetchCommits();
        } catch (AuraHandledException e) {
            System.assert(e.getMessage().contains(GlobalConsts.ERROR_FETCHING_COMMITS));
        }
    }
    
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"message":"Success"}');
            res.setStatusCode(200);

            return res;
        }
    }

    private class MockHttpResponseErrorGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"message":"' + GlobalConsts.ERROR_FETCHING_COMMITS + '"}');
            res.setStatusCode(500);
            
            return res;
        }
    }    
}