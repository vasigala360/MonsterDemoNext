@isTest
public class LeadProcessorTest {
	@testSetup
    static void createLeads(){
        Integer leadCount = 0;
        List<Lead> leadList = new List<Lead>();
        Lead l; 
        for(Integer i=leadCount;i<200;i++){
            l = new Lead();
            l.LastName = 'Test '+String.valueOf(i);
            l.Company = 'Test Company '+String.valueOf(i);
            l.LeadSource = 'Web';
            l.Status = 'Open - Not Contacted';
			leadList.add(l);
        }
        List<Database.SaveResult> res = Database.insert(leadList,false);
        
    }
    
    @isTest
    static void testBatchProcess(){
        LeadProcessor proc;
        
        for(Lead eachL : [Select Id,LeadSource from Lead]){
            system.assertEquals('Web',eachL.LeadSource,'Asserting for Default Lead Source');
        }
        
        Test.startTest();
        	proc = new LeadProcessor();
        	Database.executeBatch(proc,2000);
        Test.stopTest();
        
        system.assertEquals([select count() from Lead],200,'Asserting for Lead Count');
        for(Lead eachL : [Select Id,LeadSource from Lead]){
            system.assertEquals('Dreamforce',eachL.LeadSource,'Asserting for right Lead Source');
        }
    }
    
    @isTest
    static void testNegativeBatch(){
        
        delete [Select Id from Lead];
        
        LeadProcessor proc;
        Test.startTest();
        	proc = new LeadProcessor();
        	Database.executeBatch(proc,2000);
        Test.stopTest();
        
        system.assertEquals([select count() from Lead],0,'Asserting for Lead Count');
    }
}