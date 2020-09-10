global without sharing class LeadProcessor implements Database.Batchable<sobject>,Database.Stateful{
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('Select Id,LeadSource from Lead');
    }
    global void execute(Database.BatchableContext bc,List<Sobject> recds){
        List<Lead> leadList = new List<Lead>();
        for(Lead l : (List<Lead>)recds){
            l.LeadSource = 'Dreamforce';
            leadList.add(l);
        }
        update leadList;
    }
    global void finish(Database.BatchableContext bc){
        
    }
}