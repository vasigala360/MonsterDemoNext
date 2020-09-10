@isTest
public class AccountManagerTest {
	@testSetup
    static void createTestData(){
        Account acc = new Account();
        acc.Name = 'ICC';
        insert acc;
        
        Contact con1 = new Contact();
        con1.AccountId = acc.id;
        con1.LastName = 'David';
        
 		Contact con2 = new Contact();
        con2.AccountId = acc.id;
        con2.LastName = 'David';       
    
        insert new List<Contact>{con1,con2};
    }
    
    
    @istest
    static void testRest(){
        
        id accountId = [Select id from Account].id;
        
        RestRequest request = new RestRequest();
        request.requestUri =
            'services/apexRest/Accounts/'+accountId+'/contacts';
        request.httpMethod = 'GET';
        request.addHeader('Content-Type', 'application/json');
        RestContext.request = request;
        
        
        AccountManager.getAccount(); 
    }
}