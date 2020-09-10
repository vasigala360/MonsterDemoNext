@isTest
public class TestRestrictContactByName {
	@testSetup
    static void createAccount(){
    	Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
    } 
    
    @isTest
    static void testAddingError(){
        
        List<Account> acc = [Select Id from Account Where Name = 'Test Account'];
        
        Contact con = new Contact();
        con.LastName = 'INVALIDNAME';
        con.FirstName = 'Evin';
        con.AccountId = acc[0].id;
        
        Test.startTest();
        	Database.SaveResult res = Database.insert(con,false);    
    	Test.stopTest();
        
        System.assert(!res.isSuccess());
        System.assert(res.getErrors().size() > 0);
        System.assertEquals('The Last Name "INVALIDNAME" is not allowed for DML',
                             res.getErrors()[0].getMessage());
    }
    
    @isTest
    static void testGoodCondition(){
        List<Account> acc = [Select Id from Account Where Name = 'Test Account'];
        
        Contact con = new Contact();
        con.LastName = 'Lewis';
        con.FirstName = 'Evin';
        con.AccountId = acc[0].id;
        
        Test.startTest();
        	Database.SaveResult res = Database.insert(con,false);    
    	Test.stopTest();
        
        System.assert(res.isSuccess());
        System.assert(res.getErrors().size() == 0);
    }
}