public class RandomContactFactory {
    public static List<Contact> generateRandomContacts(Integer noOfContacts,String lastName){
        List<Contact> conList = new List<Contact>();
        Contact con;
        if( noOfContacts > 0){
        	for(Integer i=0;i<noOfContacts;i++){
            	con = new Contact();
                con.LastName = lastName;
                con.FirstName = 'Test '+String.valueOf(i+1);
            	conList.add(con);
            }    
        }
        return conList;
    }
}