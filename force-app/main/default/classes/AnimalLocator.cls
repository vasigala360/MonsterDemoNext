public class AnimalLocator {
	public static String getAnimalNameById(Integer id) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals/'+String.valueOf(id));
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.
        AnimalClass ani;
        if (response.getStatusCode() == 200) {
            // Deserializes the JSON string into collections of primitive data types.
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            // Cast the values in the 'animals' key as a list
            ani = (AnimalClass) JSON.deserialize(JSON.serialize((object) results.get('animal')),AnimalClass.class);
        }
        return ani.name;
    }
    
    public class AnimalClass{
        public String id;
        public String name;
        public String eats;
        public String says;
    }
}