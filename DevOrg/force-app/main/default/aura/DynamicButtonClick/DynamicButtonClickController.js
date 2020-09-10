({
	handleClick : function(component, event, helper) {
		var buttonComp = event.getSource();
        var buttonLabel = buttonComp.get("v.label");
        component.set("v.message",buttonLabel);
	},
    handleClick2: function(component, event, helper) {
        var newMessage = event.getSource().get("v.label");
        component.set("v.message", newMessage);
    },
    handleClick3: function(component, event, helper) {
        component.set("v.message", event.getSource().get("v.label"));
        console.log(JSON.stringify(event.getSource().get("v.label")));
    }
})