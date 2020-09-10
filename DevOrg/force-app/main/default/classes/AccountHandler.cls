public inherited sharing class AccountHandler{

    public static Account insertNewAccount(String accName){
        try{
            Account acc;
            if( String.isNotBlank( accName ) )
                acc = new Account(name=accName);
            insert acc;
            return acc;
        }
        catch(Exception e){
            return null;
        }   // My comment I wrote on August
    }
}