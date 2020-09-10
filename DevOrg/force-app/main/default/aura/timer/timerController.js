({
    doInit : function(component, event, helper) {
        var action = component.get("c.wirePrefix");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.wirePrefix",response.getReturnValue());
            }
        });
        
        var action2 = component.get("c.getStartAndEndTimes");
        action2.setCallback(this, function(response){
            var state2 = response.getState();
            if( state2 === "SUCCESS"){
                if( response.getReturnValue().includes("StartTime") && 
                   response.getReturnValue().includes("EndTime")){
        			var twoTimes = response.getReturnValue().split(",");
                    var startTime,endTime;
                    twoTimes.forEach(function(item){
                        if( item.includes("StartTime")){
                            startTime = item.split('-')[1].split(" ");
                            if( startTime[1] == 'PM'){
                                var hour = startTime[0].split(':')[0];
                                var min = startTime[0].split(':')[1];
                            	
                                hour = parseInt(hour) + 12;
                                startTime = hour+':'+min+':'+'00.000';
                            }
                            else{
                                var hour = startTime[0].split(':')[0];
                                var min = startTime[0].split(':')[1];
                            	
                                if( hour < 10){
                                    hour = '0'+hour;
                                }
                                startTime = hour+':'+min+':'+'00.000';
                            }
                        }
                        else{
                            endTime = item.split('-')[1].split(" ");
                            if( endTime[1] == 'PM'){
                                var hour = endTime[0].split(':')[0];
                                var min = endTime[0].split(':')[1];
                            	
                                hour = parseInt(hour) + 12;
                                endTime = hour+':'+min+':'+'00.000';
                            }
                            else{
                                var hour = endTime[0].split(':')[0];
                                var min = endTime[0].split(':')[1];
                            	
                                if( hour < 10){
                                    hour = '0'+hour;
                                }
                                endTime = hour+':'+min+':'+'00.000';
                            }
                        }
                    });
                    component.set("v.startTime",startTime);
                    component.set("v.endTime",endTime);
                }
            }
        });
        
        $A.enqueueAction(action);
        $A.enqueueAction(action2);
        
        
    },
    saveTime :function(component, event, helper){
        var start = component.get("v.startTime");
        var end = component.get("v.endTime");
        
        if(start == "" || end == ""){
            alert('Please check , either of Start,End (or) both times are not specified.');
            return;
        }
        
        if( start === end){
            alert('Start and End times cannot be the same');
            return;
        }
        
        alert('Your metadata update request has been submitted.Changes would reflect in another 5 minutes.Please click on Exit button now.');
        
        var action = component.get("c.updateTimeMetadataRecords");
        
        action.setParams({  startTime : start,
                          	endTime : end});
        $A.enqueueAction(action);
    },
    exit :function(component, event, helper){
		var urlEvent = $A.get("e.force:navigateToURL");
        var keyPrefix = component.get("v.wirePrefix");
        urlEvent.setParams({
          "url": "/"+keyPrefix+"/o"
        });
        urlEvent.fire();
    }
})