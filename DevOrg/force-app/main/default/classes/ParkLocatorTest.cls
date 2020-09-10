@isTest
public class ParkLocatorTest{

@isTest
static void testCallout(){

Test.setMock(WebServiceMock.class,new ParkServiceMock());

Test.startTest();
    
    ParkService.byCountryResponse response = new ParkService.byCountryResponse();
    
    response.return_x = ParkLocator.country('Germany');
    
Test.stopTest();
    
    system.assertEquals(response.return_x[0],'Jaffa');

}

}