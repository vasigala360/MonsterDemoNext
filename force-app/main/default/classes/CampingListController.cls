public with sharing class CampingListController {
    // STERN LECTURE ABOUT WHAT'S MISSING HERE COMING SOON
    @AuraEnabled
    public static List<Camping_Item__c> getItems() {
        return [SELECT Id, Name, Packed__c, Price__c, Quantity__c, CreatedDate 
                FROM Camping_Item__c];
    }
    @AuraEnabled
    public static Camping_Item__c saveItem(Camping_Item__c item){
        insert item;
        return item;
    }
}