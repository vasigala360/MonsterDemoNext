({
	NavigateComponent : function(component,event,helper) {
      $A.createComponent(
         "c:Component2",
         {
           "res" : event.getParam("result")
         },
         function(newCmp){
            if (component.isValid()) {
                component.set("v.body", newCmp);
            }
         }
      );
   }
})