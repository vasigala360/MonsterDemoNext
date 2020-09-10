({
	doInit : function(component, event, helper) {
		window.open("https://pawdevtest-dev-ed.lightning.force.com/lightning/r/Job_Application__c/a0N7F000006Rak7UAC/view");
        setTimeout(function(){
            		$A.get("e.force:closeQuickAction").fire(); 
		}, 100);
    }
})