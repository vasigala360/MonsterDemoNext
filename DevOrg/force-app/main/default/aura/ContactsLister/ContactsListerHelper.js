({
    loadContacts : function(component) {
    	var action = component.get("c.getContacts");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.contacts", response.getReturnValue());
                component.set("v.contactList", response.getReturnValue());
                this.updateTotal(component);
            }
            // Display toast message to indicate load status
            var toastEvent = $A.get("e.force:showToast");
            if (state === 'SUCCESS'){
                toastEvent.setParams({
                    "title": "Success!",
                    "message": " Your contacts have been loaded successfully."
                });
            }
            else {
                toastEvent.setParams({
                    "title": "Error!",
                    "message": " Something has gone wrong."
                });
            }
            toastEvent.fire();
        });
    	$A.enqueueAction(action);
    },
    updateTotal: function(component) {
        var contacts = component.get("v.contacts");
        component.set("v.totalContacts", contacts.length);
    }
})