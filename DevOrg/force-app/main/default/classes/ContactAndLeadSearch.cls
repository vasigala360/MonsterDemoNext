public inherited sharing class ContactAndLeadSearch{

    public static List<List<Sobject>> searchContactsAndLeads(String param){
        if( String.isNotBlank( param )){
            String searchQuery = 'FIND \'' + param + '\' IN NAME FIELDS RETURNING Lead(Name,FirstName,LastName ), Contact(FirstName,LastName )';
            List<List<sObject>> searchConLead = search.query(searchQuery);
            return searchConLead;       
        }
        return null;
    }
}