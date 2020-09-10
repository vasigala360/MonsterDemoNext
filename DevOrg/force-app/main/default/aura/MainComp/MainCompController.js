({
   doInit : function(component, event, helper) {
      $A.createComponent(
         "c:Component1",
         {
 
         },
         function(newCmp){
            if (component.isValid()) {
               component.set("v.body", newCmp);
            }
         }
      );
   }
   
})