public with sharing class AccountAddressTriggerHandler {
    public static void matchPostalCode(List<Account> accList){
        for(Account eachAcc : accList){
            if( String.isNotBlank(eachAcc.BillingPostalCode) && eachAcc.Match_Billing_Address__c){
                eachAcc.ShippingPostalCode = eachAcc.BillingPostalCode;
            }
        }
    }
}