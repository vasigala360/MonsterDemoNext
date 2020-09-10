public class TaskCreator {
    public static void createTaksForClosedOppty(Map<Id,Opportunity> newMap,Map<Id,Opportunity> oldMap){
        List<Task> taskListToInsert = new List<Task>();
        Task tempTask;
        
        if( oldMap != null){
        	Opportunity oldOpp,newOpp;
            for(Id eachOppId : newMap.keySet()){
                oldOpp = oldMap.get(eachOppId);
                newOpp = newMap.get(eachOppId);
                if( newOpp.StageName == 'Closed Won' && oldOpp.StageName != 'Closed Won'){
                    temptask = new Task();
                    tempTask.WhatId = newOpp.id;
                    tempTask.Subject = 'Follow Up Test Task';
                    taskListToInsert.add(temptask);
                }
            }    
        }
        else{
            for(Opportunity eachOpp : newMap.values()){
                if( eachOpp.StageName == 'Closed Won'){
                    tempTask = new Task();
 					tempTask.WhatId = eachOpp.id;
                    tempTask.Subject = 'Follow Up Test Task';
                    taskListToInsert.add(temptask);                   
                }
            }    
        }
        
        if( taskListToInsert.size() > 0){
            insert taskListToInsert;
        }
    }
}