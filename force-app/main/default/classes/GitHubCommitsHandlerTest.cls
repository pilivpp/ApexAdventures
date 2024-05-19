@isTest
private class GitHubCommitsHandlerTest {
    @isTest
    static void testFetchCommitsActiveEndpoint() {
        Test.setMock(HttpCalloutMock.class, new GitHubCommitsHandlerMock(true));

        Test.startTest();
        String result = GitHubCommitsHandler.fetchCommits();
        Test.stopTest();

        System.assertNotEquals(null, result);
    }

    @isTest
    static void testFetchCommitsNoActiveEndpoint() {
        Test.setMock(HttpCalloutMock.class, new GitHubCommitsHandlerMock(false));

        Test.startTest();
        String result = GitHubCommitsHandler.fetchCommits();
        Test.stopTest();

        System.assertEquals(null, result);
    }

    private class GitHubCommitsHandlerMock implements HttpCalloutMock {
        private Boolean isActive;
        
        public GitHubCommitsHandlerMock(Boolean isActive) {
            this.isActive = isActive;
        }

        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            if (isActive) {
                res.setHeader('Content-Type', 'application/json');
                res.setBody('[{"commit": {"message": "Initial commit"}}]');
                res.setStatusCode(200);
            } else {
                res.setStatusCode(404);
                res.setStatus('Not Found');
            }
            return res;
        }
    }
}
