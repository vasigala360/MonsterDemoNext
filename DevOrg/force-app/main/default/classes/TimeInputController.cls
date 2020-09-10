public class TimeInputController implements Metadata.DeployCallback{
    
    public void handleResult(Metadata.DeployResult result,
                             Metadata.DeployCallbackContext context) {
        if (result.status == Metadata.DeployStatus.Succeeded) {
            System.debug('Success');
        } else {
            System.debug('fail: '+ result);
        }
    }
    
	@AuraEnabled
    public static String wirePrefix(){
        String keyPrefix;
        keyPrefix = Schema.getGlobalDescribe().get('Account').getDescribe().getKeyPrefix();
        return keyPrefix;
    }
    
    @AuraEnabled
    public static String getStartAndEndTimes(){
        String concatString;
        List<SamplePay__mdt> payRecords = [Select id,QualifiedApiName,Values__c from SamplePay__mdt
                                           WHERE QualifiedApiName in ('Wire_Transfer_Start_Time','Wire_Transfer_End_Time')];
        for(SamplePay__mdt record : payRecords){
            if( String.isNotBlank( record.Values__c )){
                if( record.QualifiedApiName.contains('Start') )
                	concatString += 'StartTime-'+record.Values__c+',';
            	if( record.QualifiedApiName.contains('End') )
                	concatString += 'EndTime-'+record.Values__c+',';
            }
        }
        if( concatString.endsWith(',') ){
            concatString = concatString.removeEnd(',');
        }
        return concatString;
    }
    
    @AuraEnabled
    public static void updateTimeMetadataRecords(String startTime,String endTime){
        String[] startArray,endArray;
        Integer starthour,startminute,endhour,endminute;
        
        String startMer,endMer;
        startMer = 'AM';
        endMer = 'AM';
        
        String startEntry,endEntry;
        
        startArray = startTime.split(':');
        endArray = endTime.split(':'); 
        
        startHour = Integer.valueOf(startArray[0]);
        startminute = Integer.valueOf(startArray[1]);
        endhour = Integer.valueOf(endArray[0]);
        endminute = Integer.valueOf(endArray[1]);
        
        if( startHour > 12 ){
            startHour = startHour - 12;
            startMer = 'PM';
        }
        if( endHour > 12 ){
            endHour = endHour - 12;
            endMer = 'PM';
        }
        
        startEntry = ( startMinute == 0 ? String.valueOf(startHour)+':'+'0'+String.valueOf(startMinute)+' '+startMer:
                      String.valueOf(startHour)+':'+String.valueOf(startMinute)+' '+startMer);
        
        endEntry = ( endMinute == 0 ? String.valueOf(endHour)+':'+'0'+String.valueOf(endMinute)+' '+endMer:
                      String.valueOf(endHour)+':'+String.valueOf(endMinute)+' '+endMer);
        
        
        
        Boolean updateStart,updateEnd;
        updateStart = false;
        updateEnd = false;
        
        SamplePay__mdt startRecord,endRecord;
        
        List<SamplePay__mdt> payRecords = [Select id,QualifiedApiName,Values__c from SamplePay__mdt
                                           WHERE QualifiedApiName in ('Wire_Transfer_Start_Time','Wire_Transfer_End_Time')];
        for(SamplePay__mdt record : payRecords){
            if( String.isNotBlank( record.Values__c )){
                if( ! record.QualifiedApiName.contains(startEntry) ){
                	updateStart = true;
                    startRecord = record;
                }    
                if( ! record.QualifiedApiName.contains(endEntry) ){
                	updateEnd = true;
                    endRecord = record;
                }    
            }
        }
        
        MetadataService.MetadataPort service = new  MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        
        service.SessionHeader.sessionId = getSessionIdFromVFPage(Page.SessionId);
        
        
        MetadataService.DeleteResult [] results = new MetadataService.DeleteResult []{};
        Metadata.CustomMetadata customStartToInsert,customEndToInsert;
        Metadata.CustomMetadataValue customStartToInsertVal,customEndToInsertVal;
        Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
        
        if( updateStart ){
            results =service.deleteMetadata('CustomMetadata',new List<String>{'SamplePay.Wire_Transfer_Start_Time'});
            if( results[0].success){
        		customStartToInsert = new Metadata.CustomMetadata();
                customStartToInsert.label = 'Wire Transfer Start Time';
                customStartToInsert.fullName = 'SamplePay.Wire_Transfer_Start_Time';
                
                customStartToInsertVal = new Metadata.CustomMetadataValue();
                customStartToInsertVal.field = 'Values__c';
                customStartToInsertVal.value = startEntry;   
                
                customStartToInsert.values.add(customStartToInsertVal);
                mdContainer.addMetadata(customStartToInsert);
                
            }	
        }
        results.clear();
        if( updateEnd ){
            results =service.deleteMetadata('CustomMetadata',new List<String>{'SamplePay.Wire_Transfer_End_Time'});
            if( results[0].success){
        		customEndToInsert = new Metadata.CustomMetadata();
                customEndToInsert.label = 'Wire Transfer End Time';
                customEndToInsert.fullName = 'SamplePay.Wire_Transfer_End_Time';
                
                customEndToInsertVal = new Metadata.CustomMetadataValue();
                customEndToInsertVal.field = 'Values__c';
                customEndToInsertVal.value = endEntry;   
                
                customEndToInsert.values.add(customEndToInsertVal);
                
                mdContainer.addMetadata(customEndToInsert);
            }
        }
        
        Metadata.Operations.enqueueDeployment(mdContainer, new TimeInputController());
    }
    
    public static String getSessionIdFromVFPage(PageReference visualforcePage){
        String content = visualforcePage.getContent().toString();
        Integer s = content.indexOf('Start_Of_Session_Id') + 'Start_Of_Session_Id'.length(),
                e = content.indexOf('End_Of_Session_Id');
        return content.substring(s, e);
    }
}