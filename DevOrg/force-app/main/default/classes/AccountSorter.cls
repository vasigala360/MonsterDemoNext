public class AccountSorter {
	
    public class AccountWrap{
        public id parentId;
        public map<Integer,set<id>> accHierMap;
    }
    
    public static void sortAccounts(){
        AccountWrap wrapper;
        
        List<AccountWrap> wrapList = new List<AccountWrap>();
        
        Set<id> parentNodes = new Set<id>();
        
        for(Account acc : [Select id,Name from Account Where Self_Lookup__c = null and Name like 'Test %']){
            parentNodes.add(acc.id);
        	wrapper = new AccountWrap();
            wrapper.parentId = acc.id;
            wrapper.accHierMap = new map<Integer,set<id>>();
            wrapList.add(wrapper);
        }
        
        List<Account> firstLevelAccounts = [Select id,Name,Self_Lookup__c from Account where Self_Lookup__c in : parentNodes];
        
        if( firstLevelAccounts.size() > 0 ){
            parentNodes.clear();
            for(AccountWrap wr : wrapList){
                for(Account acc : firstLevelAccounts){
                    if( wr.parentId == acc.Self_Lookup__c ){
                        if( wr.accHierMap.get(1) == null ){
                            wr.accHierMap.put(1,new set<id>{acc.id});
                        }
                        wr.accHierMap.get(1).add(acc.id);
                        parentNodes.add(acc.id);
                    }
                }    
            }
        }
        
        List<Account> nextLevelAccs;
        id parentid;
        for(Integer i=2;i<10;i++){
            if( parentNodes.size() > 0 ){
                nextLevelAccs = [Select id,Name,Self_Lookup__c from Account where Self_Lookup__c in : parentNodes];
                if( nextLevelAccs.size() > 0){
                    parentNodes.clear();
                    
                    for(AccountWrap wr : wrapList){
                		for(Account acc : nextLevelAccs){
                            if( wr.accHierMap.get(i-1) != null){
                                if( wr.accHierMap.get(i-1).contains(acc.Self_Lookup__c )){
                                    if( wr.accHierMap.get(i) == null){
                                        wr.accHierMap.put(i,new set<id>{acc.id});
                                    }
                                    wr.accHierMap.get(i).add(acc.id);
                                }
                            }
                            parentNodes.add(acc.id);
                    	}        
                    }    
                }
                else{
                    
                    nextLevelAccs = [Select id,Name,Self_Lookup__c from Account where Id in : parentNodes];
                    
                    
                    for(Account acc : nextLevelAccs){
                    	
                        parentId = acc.Self_Lookup__c;
                        
                        for(AccountWrap wrap : wrapList){
                            if( wrap.accHierMap.get(i-1) != null){
                                if( wrap.accHierMap.get(i-1).contains(parentId) ){
                                    if( wrap.accHierMap.get(i) == null){
                                        wrap.accHierMap.put(i,new set<id>{acc.id});
                                    }
                                    wrap.accHierMap.get(i).add(acc.id);
                                }
                            }    
                        }
                        
                    }
                }
            }
        }
        system.assert(False,wrapList);
    }
}