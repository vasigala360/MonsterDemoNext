global class ProjectCalloutServiceMock implements HttpCalloutMock {
   global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"Reply":"Project created"}');
        res.setStatusCode(201);
        res.setStatus('OK');
        return res;
   }
}