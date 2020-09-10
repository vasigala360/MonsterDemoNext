public class DailyLeadProcessor implements Schedulable{
    public void execute(SchedulableContext cntxt){
        List<Lead> leadToProcess = [SELECT LeadSource from Lead Where LeadSource = null Order by CreatedDate asc LIMIT 200];
        List<Lead> leadList = new list<Lead>();                   
        for(Lead ld : leadToProcess){
            ld.LeadSource = 'Dreamforce';
            leadList.add(ld);
        }
        	update leadList;
    }
}