public class FlowPickListGenerator {
	@AuraEnabled
    public static Map<String,String> generatePicklistValues(string radioId){
        Map<String,String> mapPicklist  =   new Map<String,String>();
        if( radioId == 'r0'){
            mapPicklist.put('Option 1','Option 1');
            mapPicklist.put('Option 2','Option 2');
        }
        else if(radioId == 'r1'){
            for(Account acc : [Select Id,Name from Account]){
                mapPicklist.put(acc.Name,acc.Name);
            }
        }
        return mapPicklist;
    }
}