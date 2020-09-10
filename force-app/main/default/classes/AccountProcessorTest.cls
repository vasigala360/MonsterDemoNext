@isTest
public class AccountProcessorTest {
	@testSetup
    static void createTestData(){
        Account acc = new Account();
        acc.Name ='Test Account';
        insert acc;
        
        if( acc.id != null){
            List<Contact> conList;

            Contact con1 = new Contact();
            con1.LastName = 'Con1';
            con1.AccountId = acc.id;

			Contact con2 = new Contact();
            con2.LastName = 'Con1';
            con2.AccountId = acc.id;

			Contact con3 = new Contact();
            con3.LastName = 'Con1';
            con3.AccountId = acc.id; 
            
            conList = new List<Contact>{con1,con2,con3};
                
            insert conList;
        }
    }
    
    @isTest
    static void testPositive(){
        List<Account> dbAcc = [Select Id from Account where Name = 'Test Account'];
        
        Test.startTest();
        	AccountProcessor.countContacts(new List<Id>{dbAcc[0].id});
        Test.stopTest();
            
        dbAcc = [Select Id,Number_of_Contacts__c from Account where Name = 'Test Account']; 
        
        system.assertEquals(dbAcc[0].Number_of_Contacts__c,3,'Asserting for Number of expected Contacts');
    }
    
    @isTest
    static void testNegative(){
        List<Account> dbAcc = [Select Id,(Select Id from Contacts) from Account where Name = 'Test Account'];
        
        if( dbAcc.size() > 0){
            
            delete dbAcc[0].contacts;
            
        }
        
        Test.startTest();
        	AccountProcessor.countContacts(new List<Id>{dbAcc[0].id});
        Test.stopTest();
            
        dbAcc = [Select Id,Number_of_Contacts__c from Account where Name = 'Test Account']; 
        
        system.assertEquals(dbAcc[0].Number_of_Contacts__c,null,'Asserting for Number of expected Contacts');
    }
}