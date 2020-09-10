public with sharing class KudoListController {
    
    public Boolean renderReceivedTable{
        get{
            if( getReceivedKudos().size() == 0){
                renderReceivedTable = false;
            }
            return renderReceivedTable;
        }
        set;}
    public Boolean renderPresentedTable{
        get{
            if( getPresentedKudos().size() == 0){
                renderPresentedTable = false;
            }
            return renderPresentedTable;
        }
        set;}

    public Boolean renderNoRecievedMsg{
        get{
            if(!renderReceivedTable){
                renderNoRecievedMsg = true;
            }
            return renderNoRecievedMsg;
        }
        set;}
    public Boolean renderNoPresentedMsg{
        get{
            if(!renderPresentedTable){
                renderNoPresentedMsg = true;
            }
            return renderNoPresentedMsg;
        }
        set;}   
    
    public KudoListController() {
        
        if(ApexPages.currentPage().getParameters().containsKey('saveSucc')){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Kudo Successfully Posted ! Please visit Chatter Feed to see...'));
        }

        renderPresentedTable = true;
        renderReceivedTable = true;

        renderNoPresentedMsg = false;
        renderNoRecievedMsg = false;
    }

    public ApexPages.StandardSetController kudosPresented {
        get {
            if(kudosPresented == null) {
                kudosPresented = new ApexPages.StandardSetController(Database.getQueryLocator(
                                    [SELECT Id,Description__c,Kudo_Type__c,Presented_To__c,Presented_To__r.Name
                                    FROM Kudo__c 
                                    Where CreatedById =:UserInfo.getUserId() ORDER BY CreatedDate DESC]));
            }
            return kudosPresented;
        }
        set;
    }

    public List<Kudo__c> getPresentedKudos() {
        return (List<Kudo__c>) kudosPresented.getRecords();

    }

    public ApexPages.StandardSetController kudosReceived {
        get {
            if(kudosReceived == null) {
                kudosReceived = new ApexPages.StandardSetController(Database.getQueryLocator(
                                    [SELECT Id,Description__c,Kudo_Type__c,Presented_To__c,CreatedById,CreatedBy.Name
                                    FROM Kudo__c 
                                    Where Presented_To__c =:UserInfo.getUserId() ORDER BY CreatedDate DESC]));
            }
            return kudosReceived;
        }
        set;
    }

    public List<Kudo__c> getReceivedKudos() {
        return (List<Kudo__c>) kudosReceived.getRecords();
    }

    public PageReference redirectToCreatePage(){

        String urlString = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/KudoEditPage';
        
        PageReference kudoTab = new PageReference(urlString);
        kudoTab.setRedirect(true);
        
        return kudoTab;
    }
}