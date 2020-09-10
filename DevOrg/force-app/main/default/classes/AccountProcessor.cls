public class AccountProcessor {
    
    @future
    public static void countContacts(List<Id> accIds){
        List<Account> accToUpdate = new List<Account>();
        for(Account eachAcc : [Select Id,(Select Id from Contacts),Number_of_Contacts__c from Account Where id IN : accIds]){
            if( eachAcc.contacts.size() > 0){
                eachAcc.Number_of_Contacts__c = eachAcc.contacts.size();
                accToUpdate.add(eachAcc);
            }
        }
        if( accToUpdate.size() > 0){
            Database.update(accToUpdate,false);
        }
    }
}