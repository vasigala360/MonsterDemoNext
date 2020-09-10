public class OpportunitySelector{

    public static List<Opportunity> getAllOpportunities(Integer noofRecords){
        List<Opportunity> returnList = new List<Opportunity>();
        Integer recCount = 1;
        for(Opportunity opp : [Select id,Name,DeliveryInstallationStatus__c
                                     from Opportunity]){
            if( recCount <= noOfRecords )
                returnList.add(opp);                             
        }
        return returnList;
    }
}