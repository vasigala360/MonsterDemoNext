@isTest
public class TestVerifyDate {
	@isTest
    static void testDate1GreaterThanDate2(){
        Date date1 = System.today()+60;
        Date date2 = System.today();
        
        Integer totalDays = Date.daysInMonth(date1.year(), date1.month());
		Date lastDay = Date.newInstance(date1.year(), date1.month(), totalDays);
		
        Date resultantDate = VerifyDate.CheckDates(date1,date2);
        
        system.assertEquals(resultantDate,lastDay,'Verifying that Date1 > Date 2 by 60 days then given end of month of Date 1');
    }
    
    @isTest
    static void testDate2GreaterThanAMonth(){
        Date date1 = System.today();
        Date date2 = System.today()+60;
        
        Integer totalDays = Date.daysInMonth(date1.year(), date1.month());
		Date lastDay = Date.newInstance(date1.year(), date1.month(), totalDays);
		
        Date resultantDate = VerifyDate.CheckDates(date1,date2);
        
        system.assertEquals(resultantDate,lastDay,'Verifying that Date2 > Date 1 by 60 days then given end of month of Date 1');
    }
    
    @isTest
    static void testDate2WithinAMonth(){
    	Date date1 = System.today();
        Date date2 = System.today()+24;
        
        Date resultantDate = VerifyDate.CheckDates(date1,date2);
        
        system.assertEquals(resultantDate,System.today()+24,'Verifying that Date1 > Date 2 by 60 days then given end of month of Date 1');    
    }
}