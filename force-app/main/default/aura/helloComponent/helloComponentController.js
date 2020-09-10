({
    handleClick: function(cmp, event, helper) {
     var navService = cmp.find("navService");
     var pageReference = {
                         "type": "standard__component",
                         "attributes": {
                                         "componentName": "c__helloTarget"
                                       }, 
                         "state": {
                             'message':'This is the target page'
                         }
                        };
     navService.navigate(pageReference);
    },
    performActivitySelected : function(component,event,helper) {
        var navSelected= $A.get("e.c:navSelected");
        navSelected.setParams({ "name" : "helloTarget" });
        navSelected.fire();
    }
})