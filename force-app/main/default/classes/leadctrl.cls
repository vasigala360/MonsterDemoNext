public with sharing class leadctrl{
    public Lead ld{get;set;}
    public leadCtrl(){
        ld = new Lead();
        ld.Company = 'Datsun';
        ld.CurrencyIsoCode = 'USD';
        ld.Status = 'Open - Not Contacted';
    }
    
    public pagereference save(){
        insert ld;
        return new PageReference('/'+ld.id);
    }
}