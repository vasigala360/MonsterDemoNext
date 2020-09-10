@isTest
public class AddPrimaryContactTest {
    @testSetup
    static void createAccounts(){
        list<Account> accList = new List<Account>();
        Account tempAcc;
        for(Integer i=1;i<=50;i++){
            tempAcc = new Account();
            tempAcc.Name = 'TestAcc'+String.valueOf(i);
            tempAcc.BillingState = 'NY';
            accList.add(tempAcc);
        }
        
        insert accList;
        
        accList.clear();
        accList = new List<Account>();
        
        for(Integer i=1;i<=50;i++){
            tempAcc = new Account();
            tempAcc.Name = 'TestAcc'+String.valueOf(i);
            tempAcc.BillingState = 'CA';
            accList.add(tempAcc);
        }
        
        insert accList;
    }
    
    @isTest
    static void testMethod1(){
        Contact con = new Contact();
        con.LastName = 'Jaffa';
        insert con;
        
        AddPrimaryContact queueInst = new AddPrimaryContact(con,'CA');
        
        Test.startTest();
        	System.enqueueJob(queueInst);
        Test.stopTest();
        
        system.assertEquals(50, [Select count() from Contact Where Account.BillingState ='CA']);
    }
}