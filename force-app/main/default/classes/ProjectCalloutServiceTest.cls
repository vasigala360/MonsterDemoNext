@isTest
private class ProjectCalloutServiceTest {
    
    @testSetup
    static void createTestData(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Transac1';
        opp.Accountid = acc.id;
        opp.CloseDate = System.today()+30;
        opp.StageName = 'Closed Won';
        opp.Type = 'New Project';
        insert opp;
        
        ServiceTokens__c st = new ServiceTokens__c(
                name = 'ProjectServiceToken',
                Token__c = 'test-service-token'
        );
        insert st;
    }
    @isTest
    static void testSuccessCallout(){
        
        Opportunity opp = [Select id,Name,StageName,Type from Opportunity];
        
        Test.startTest();
        	Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock());
            ProjectCalloutService.postOpportunityToPMS(new List<Id>{opp.Id});    
        Test.stopTest();
        
    }
    @isTest
    static void testFailureCallout(){
        
        Opportunity opp = [Select id,Name,StageName,Type from Opportunity];
        
        Test.startTest();
        	Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure());
            ProjectCalloutService.postOpportunityToPMS(new List<Id>{opp.Id});
        Test.stopTest();
        
    }
}