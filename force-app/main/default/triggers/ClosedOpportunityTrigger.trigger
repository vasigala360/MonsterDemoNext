trigger ClosedOpportunityTrigger on Opportunity (after insert,after update) {
    TaskCreator.createTaksForClosedOppty(Trigger.newMap,Trigger.oldMap);
}