@isTest
public class AnimalLocatorTest {
	@isTest
    static void testMethod1(){
        
        Test.setMock(HttpCalloutMock.class, new AnimalLocatorMock());
        
        String response;
        
        Test.startTest();
         response = AnimalLocator.getAnimalNameById(1);
        Test.stopTest();
        
        system.assertEquals('chicken',response);
    }
}