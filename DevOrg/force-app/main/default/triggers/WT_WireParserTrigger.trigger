trigger WT_WireParserTrigger on TestWireDocInventory__c (after insert) {
    
    TestWireDocInventory__c docRec = Trigger.new[0];
    
    Document doc;
    
    try{
        doc = [Select id,body from document where id =:docRec.Document_Id__c];
    }
    catch(Exception e){
    
    }
    
    if( doc != null ){
        //WT_WireParser.abc(doc.body.toString());
    }
}