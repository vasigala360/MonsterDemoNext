({
	onMenuItemSelected : function(component, name) {
        $A.createComponent(
            "c:" + name,
            [],
            function(newComponent, status, statusDetail) {
                var content = component.find("displayPort");
                content.set("v.body", newComponent);
            }
        );
	}
})