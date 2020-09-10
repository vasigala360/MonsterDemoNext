public class AddPrimaryContact implements Queueable{
    
    public String stateAbbr;
    public Contact contactSent;
    
    public AddPrimaryContact(Contact cnt,String abbr){
        stateAbbr = abbr;
        contactSent = cnt;
    }
    public void execute(QueueableContext cntxt){
        List<Contact> conList = new List<Contact>();
        Contact tempContact;
        
        for(Account acc :  [Select Name from Account Where BillingState =:stateAbbr LIMIT 200]){
    		tempContact = contactSent.clone(false,true,false,false);
            tempContact.AccountId = acc.id;
            conList.add(tempContact);
        }
        
        insert conList;
    }
}