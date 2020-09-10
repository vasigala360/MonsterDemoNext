public class ParkLocator {
	public static List<String> country(String countryName){
        ParkService.ParksImplPort inst = new ParkService.ParksImplPort();
        return inst.byCountry(countryName);
    }
}