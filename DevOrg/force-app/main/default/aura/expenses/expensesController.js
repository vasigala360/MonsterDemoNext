({
	
    doInit : function(component, event, helper) {
        var mydate = component.get("v.newExpense.Date__c");
        if(mydate){
            component.set("v.formatdate", new Date(mydate));
        }
    },
    clickCreate: function(component, event, helper) {
        var validExpense = component.find('expenseform').reduce(function (validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        
        var inputCmp = component.find("expenseformCL");
        var value = inputCmp.get('v.value');
        
        if(value === '' || value == null) {
            inputCmp.setCustomValidity('Enter Client Name');
        }
        inputCmp.reportValidity();

        // If we pass error checking, do some real work
        if(validExpense && value != null){
            // Create the new expense
            var newExpense = component.get("v.newExpense");
            console.log("Create expense: " + JSON.stringify(newExpense));
            helper.createExpense(component, newExpense);
        }
    }
})