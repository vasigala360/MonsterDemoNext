public inherited sharing class ContactSearch{

    public static List<Contact> searchForContacts(String lastName,String mailingPostalCode){
        if( String.isNotBlank(lastName) && String.isNotBlank(mailingPostalCode)){
            List<Contact> contToReturn = [Select id,Name,FirstName,LastName,Email from Contact where LastName =:lastName
                                            and MailingPostalCode =:mailingPostalCode];
            return contToReturn;
        }
        return null;
    }
}