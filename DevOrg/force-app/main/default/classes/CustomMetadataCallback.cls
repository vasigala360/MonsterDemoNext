public class CustomMetadataCallback implements Metadata.DeployCallback {
    public void handleResult(Metadata.DeployResult result,
                             Metadata.DeployCallbackContext context) {
        if (result.status == Metadata.DeployStatus.Succeeded) {
            System.debug('success:::::::::::::::::: '+ result);
            insert new Account(Name='Successful Exec');
        } else {
            // Deployment was not successful
            System.debug('fail::::::::::::::::::::  '+ result);
        }
    }
    
    public static void insertMetaRecord(){
        // Set up custom metadata to be created in the subscriber org.
        Metadata.CustomMetadata customMetadata =  new Metadata.CustomMetadata();
        customMetadata.fullName = 'VAT_Rate.Maine_Bola';
        customMetadata.label = 'Maine_Bola';
        
        Metadata.CustomMetadataValue customField1 = new Metadata.CustomMetadataValue();
        customField1.field = 'Default__c';
        customField1.value = true;
        
        Metadata.CustomMetadataValue customField2 = new Metadata.CustomMetadataValue();
        customField2.field = 'Rate__c';
        customField2.value = 9.75;
        
        customMetadata.values.add(customField1);
        customMetadata.values.add(customField2);
        
        Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
        mdContainer.addMetadata(customMetadata);
        
        // Setup deploy callback, MyDeployCallback implements
        // the Metadata.DeployCallback interface (code for
        // this class not shown in this example)
        CustomMetadataCallback callback = new CustomMetadataCallback();
        
        // Enqueue custom metadata deployment
        // jobId is the deployment ID
        Id jobId = Metadata.Operations.enqueueDeployment(mdContainer, callback);
    }
}