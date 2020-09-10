({
	onSelect : function(component,event,helper){
        var getWhichBtn = event.getSource().getLocalId();
        var getRadioLabel = event.getSource().get("v.label");
        component.set("v.selectedRadio" , getRadioLabel);
        component.set("v.storeRadioId" , getWhichBtn);    
        var action = component.get("c.generatePicklistValues");
        action.setParams({
            "radioId": getWhichBtn
        });
        
        action.setCallback(this, function(response) {
            var returnedPicklistValues	=	response.getReturnValue();
            var opts1 = [];
            var counter = 1;
            for(var pickListValue in returnedPicklistValues){
                if( counter === 1 ){
                    opts1.push({
                        "value": pickListValue,
                        "key": returnedPicklistValues[pickListValue],
                        "selected": true
                	});
                    component.set("v.selectedValue",pickListValue);
                }
                else{
                	opts1.push({
                        "value": pickListValue,
                        "key": returnedPicklistValues[pickListValue],
                        "selected": false
                	});    
                }
                counter++;
            }
            
            component.set("v.options",opts1);
        });
        $A.enqueueAction(action);
	}
})