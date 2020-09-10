public with sharing class FileUploadController {
 
 
    @AuraEnabled
    public static Id saveChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId) {
        if (fileId == '') {
            fileId = saveTheFile(parentId, fileName, base64Data, contentType);
        }
        return Id.valueOf(fileId);
    }
 
    public static Id saveTheFile(Id parentId, String fileName, String base64Data, String contentType) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
 
        Document doc = new Document();
        doc.FolderId = [Select id,Name from Folder where name = 'Wire Record Document Folder'][0].id;
 		doc.Body = EncodingUtil.base64Decode(base64Data);
        doc.Name = fileName;
        insert doc;
 		
        TestWireDocInventory__c testdoc = new TestWireDocInventory__c();
        testdoc.Document_Id__c = doc.id;
        insert testdoc;
        
        return doc.Id;
    }
}