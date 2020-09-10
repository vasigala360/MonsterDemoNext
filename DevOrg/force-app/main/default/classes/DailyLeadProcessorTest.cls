@isTest
public class DailyLeadProcessorTest {
	@testSetup
    static void createLeads(){
        Lead tempLead;
        List<Lead> tempList = new List<Lead>();
        for(Integer i=0;i<200;i++){
            tempLead = new Lead(LastName='Test '+String.valueOf(i),Company='TestCompany '+String.valueOf(i),Status='Open - Not Contacted');
        	tempList.add(tempLead);
        }
        insert tempList;
    }
    
    @isTest
    static void testMethod1(){
        
        system.assertEquals(200,[Select count() from Lead Where LeadSource = null] );
        
        Test.startTest();
        	DailyLeadProcessor sched = new DailyLeadProcessor();
        	System.schedule('Sample Job','0 0 0 * * ?', sched);
        Test.stopTest();
    }
    
}