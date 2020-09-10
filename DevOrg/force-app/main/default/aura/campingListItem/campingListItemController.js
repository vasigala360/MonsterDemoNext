({
    packItem : function(component, event, helper) {
        var markItem=component.get("v.item",true);
        markItem.Packed__c=true;
        component.set("v.item",markItem);
        var btnClick=event.getSource();//Button
        btnClick.set("v.disabled",true);
    }
})