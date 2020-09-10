public inherited sharing class StringArrayTest{

    public static List<String> generateStringArray(Integer sizeParam){
        List<String> listToReturn = new List<String>();
        
        for(Integer i=0;i<sizeParam;i++){
            listToReturn.add('Test '+String.valueOf(i));
        }
        
        return listToReturn;
    }
}