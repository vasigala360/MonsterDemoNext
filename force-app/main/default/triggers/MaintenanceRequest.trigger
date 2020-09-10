trigger MaintenanceRequest on Case (before update, after update) {
    if( Trigger.isUpdate && Trigger.isafter){
        MaintenanceRequestHelper.updateWorkOrders(Trigger.oldMap,Trigger.newMap);      
    }
}