trigger BatchApexErrorTrigger on BatchApexErrorEvent (after insert) {
    BatchLeadConvertErrors__c tempErrorLog;
    List<BatchLeadConvertErrors__c> errorLogList = new List<BatchLeadConvertErrors__c>();
    for(BatchApexErrorEvent errorEvnt : Trigger.new){
        tempErrorLog = new BatchLeadConvertErrors__c();
        tempErrorLog.AsyncApexJobId__c = errorEvnt.AsyncApexJobId;
        tempErrorLog.Records__c = errorEvnt.JobScope;
        tempErrorLog.StackTrace__c = errorEvnt.StackTrace;
        errorLogList.add(tempErrorLog);
    }
    if( errorLogList.size() > 0 ){
        insert errorLogList;
    }
}