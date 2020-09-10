global class CheckScheduler implements Schedulable{
	global static void execute(SchedulableContext sc){
        DateTime returnTime;
        returnTime = System.now();
        Integer offset = UserInfo.getTimezone().getOffset(returnTime);
        returnTime = returnTime.addSeconds(offset/1000);
        
        String cronExp = '';
        returnTime = returnTime.addMinutes(30);
        
        String targetTime = JSON.serialize(returnTime);
        
        Integer hour = Integer.valueOf(targetTime.split('T')[1].split(':')[0]);
        Integer min = Integer.valueOf(targetTime.split('T')[1].split(':')[1]);
        
        system.assert(false,JSON.serialize(hour)+JSON.serialize(min));
    }
    global static void triggerFraudSchedule(){
        String cronString = '0 49 9 * * ?';
        System.Schedule('Invoke Schedule for day',cronString,new CheckScheduler());
    }    
}