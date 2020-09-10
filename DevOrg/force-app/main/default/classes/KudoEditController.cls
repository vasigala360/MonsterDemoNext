public with sharing class KudoEditController{
    
    public Map<Id,String> groupNameMap{
        get{
            if(groupNameMap == null){
                groupNameMap = new Map<Id,String>();
                for(CollaborationGroup eachGroup : [SELECT Id,Name from CollaborationGroup]){
                    groupNameMap.put(eachGroup.Id,eachGroup.Name);
                }
            }
            return groupNameMap;
        }
        set;
    }
    
    public Map<Id,String> userEmailMap{
      get{
          if(userEmailMap == null){
             userEmailMap = new Map<Id,String>();
          }
          return userEmailMap;
      }
      set;}

    public List<SelectOption> lstAvailableOptions {
      get{
       
         if( lstAvailableOptions == null){
             lstAvailableOptions = new List<SelectOption>();
             for(User userobj:[SELECT Id,Name ,Email, SmallPhotoUrl FROM User Where IsActive = true]){
              
                lstAvailableOptions.add(new SelectOption(userobj.Id, userobj.Name+'-->'+userobj.SmallPhotoUrl));

                if(!userEmailMap.containsKey(userobj.Id)){
                    userEmailMap.put(userobj.Id,userobj.Email);
                }
             }
         }
         return lstAvailableOptions;  

      }
      set;}
    public List<SelectOption> lstSelectedOptions {
      get{
         if( lstSelectedOptions == null){
             lstSelectedOptions = new List<SelectOption>();
         }
         return lstSelectedOptions;  
      }
      set;}
    
    public String description{
      get{
         if( description == null){
             description = '';
         }
         return description;  
      }
      set;}
    
    public List<SelectOption> types {
      get{
         if( types == null){
             types = new List<SelectOption>();
             types.add(new SelectOption('Group','Group'));
             types.add(new SelectOption('Individual','Individual'));
         }
         return types;  
      }
      set;}
    
    public String typeOfKudo{
      get{
         if( typeOfKudo == null){
             typeOfKudo = 'Group';
         }
         return typeOfKudo;  
      }
      set;}
    
    public List<SelectOption> groups {
      get{
         if( groups == null){
             groups = new List<SelectOption>();
             for(CollaborationGroup each : [SELECT Id,Name FROM CollaborationGroup]){
                 groups.add(new SelectOption(each.Id,each.Name));
             }
         }
         return groups;  
      }
      set;}
    
    public String groupName{
      get{
         if( groupName == null){
             groupName = '';
         }
         return groupName;  
      }
      set;}
    
    public class kudoContainer{
        
        Set<Id> selectedIds{get;set;}
        
        List<Kudo__c> kudosToPost{get;set;}
        
        List<String> toAddressesToEmail{get;set;}
        
        private kudoContainer(List<String> toAddressesToEmail,Set<Id> selectedIds){
            this.toAddressestoEmail = toAddressestoEmail;
            this.selectedIds = selectedIds;
        }
    }
     
    public KudoEditController(ApexPages.StandardController ctrl){  
        
        if(ApexPages.currentPage().getParameters().containsKey('prevSave')){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Done Posting Prev Kudo !! Please Go On Creating another One.'));
        }
    }


    public PageReference save(){
    
        Set<Id> selectedIds = new Set<Id>();
        
        for(SelectOption each : lstSelectedOptions){
            selectedIds.add(each.getValue());
        }
        
        if( description == '' ){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please Enter Some Description'));
        }
        if( lstSelectedOptions.size() == 0 ){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please Select Some Employees To Appreciate'));
        }
        
        if( typeOfKudo == 'Group' && selectedIds.size() == 1){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please Select Some More Employees to Post a Group Post'));
        }
        
        if(selectedIds.contains(UserInfo.getUserId())){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Sorry You cannot include yourself in a Kudo'));
        }
        
        Boolean safeToProceed = true;
        
        for(ApexPages.Message eachMsg: ApexPages.getMessages()){
                if(eachMsg.getSeverity().name() == 'ERROR'){
                    safeToProceed = false;
                }
        }
        
        List<Kudo__c> kudosToInsert = new List<Kudo__c>();
        Kudo__c tempKudo;
        
        if(selectedIds.size() > 0 && safeToProceed){ 
            
            Boolean skipRedirect = false;
            
            Savepoint groupSavePoint = Database.setSavepoint();
            
            try{
                
                KudoContainer container;
                
                if(typeOfKudo == 'Group'){
                    container = buildKudo('Group',groupName,selectedIds);
                }
                else {
                    container = buildKudo('Individual',groupName,selectedIds);
                }
                
                if(insertKudos(container)){
                    // Posting To Chatter
                    Boolean postResult = KudoChatterPoster.postToChatter(typeOfKudo,container.kudosToPost[0].Description__c,container.kudosToPost[0].Group_Id__c, selectedIds); 
                    
                    // Provision of Success Message
                    if(postResult){
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Done Posting !! Please Check Feed.'));
                    }
                }
            }
            catch(Exception e){
                system.assert(false,e.getStackTraceString());
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'An Error Occured :'+e.getMessage()));
                Database.rollBack(groupSavePoint);
            }
            
            for(ApexPages.Message eachMsg: ApexPages.getMessages()){
                if(eachMsg.getSeverity().name() == 'ERROR'){
                    skipRedirect = true;
                }
            }
            
            if( !skipRedirect ){
                return redirectToKudoTab(); 
            }
            
            else{
                return null;
            }
            
        }
        else {
            return null;
        }
    }
    
    private Boolean insertKudos(KudoContainer container){
        Boolean successfulInsertion = true;
        for(Database.SaveResult eachRes : Database.insert(container.kudosToPost,true)){
             if(eachRes.getErrors().size() !=0){
            successfulInsertion = false;
         }
        }
        
    return successfulInsertion;
    }
    
    private KudoContainer buildKudo(String kudoType,String groupName,Set<Id> selectedIds){
        
        List<Kudo__c> kudoList = new List<Kudo__c>();
        
        String[] toAddresses;
        
        Kudo__c tempKudo;
        
        KudoContainer container;
        
        for(Id eachMember : selectedIds){
            
            toAddresses = new String[] {};              
            
            if(userEmailMap.containsKey(eachMember)){
                toAddresses.add(userEmailMap.get(eachMember));
            }
        }
        
        container = new KudoContainer(toAddresses,selectedIds);    
        
        for(Id eachMember : selectedIds){ 
               
            tempKudo = new Kudo__c();
            tempKudo.Kudo_Type__c = kudoType;
            tempKudo.Group_Id__c = Id.valueOf(groupName);  
            tempKudo.Group_Name__c = groupNameMap.get(groupName);
            tempKudo.Presented_To_Email__c = userEmailMap.get(eachmember);
                tempKudo.Description__c = this.description;  
            tempKudo.Presented_To__c = eachmember;
            
            kudoList.add(tempKudo);
        }

        container.kudosToPost = kudoList;
        
        return container;
    }
    
    private PageReference redirectToKudoTab(){

          String urlString = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/KudosTabOverride';
        
        PageReference kudoTab = new PageReference(urlString);
        kudoTab.setRedirect(true);
        
      kudoTab.getParameters().put('saveSucc','SUCCESS');

        return kudoTab;
    }
       
    public PageReference saveAndNew(){
        
        Map<String,String> paramMap = ApexPages.currentPage().getParameters();
        
        if(paramMap.containsKey('prevSave')){
            paramMap.remove('prevSave');
        }
    
        PageReference pref = save();
        
        PageReference newPage;
        
        if( pref != null){
            
        String urlString = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/KudoEditPage';
        
            newPage = new PageReference(urlString);
            newPage.setRedirect(true);
        
            newPage.getParameters().put('prevSave','Success');  
        }
        return newPage;
    }
    
    public PageReference cancel(){
    
      String urlString = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/KudoTabOverride';
        
        PageReference kudoTab = new PageReference(urlString);
        kudoTab.setRedirect(true);
        
        return kudoTab;
    }
    
}