@RestResource(urlMapping='/Accounts/*/contacts')
global class AccountManager {
	
    global class AccountWrapper{
       public Account acc;
       public List<Contact> conList;
    }
    
    @HttpGet
    global static Account getAccount(){
        
        RestRequest request = RestContext.request;
        
    	String accId = request.requestURI.substringBetween('/Accounts/','/contacts');
        
        List<Account> accList = [Select ID,Name,(Select Id,Name from Contacts) from Account Where id =:accId];
        
        return accList[0];
    }
}