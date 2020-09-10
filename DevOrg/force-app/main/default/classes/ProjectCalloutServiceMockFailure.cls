global class ProjectCalloutServiceMockFailure implements HttpCalloutMock {
   global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"Reply":"Project creation Failed"}');
        res.setStatusCode(500);
        res.setStatus('Error Message');
        return res;
   }
}