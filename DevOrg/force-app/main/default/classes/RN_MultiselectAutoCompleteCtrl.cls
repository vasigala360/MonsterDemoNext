public with sharing class RN_MultiselectAutoCompleteCtrl 
{
    public SelectOption[] leftOptions   { get; set; }
    public SelectOption[] rightOptions  { get; set; }
    public String strSelectedOptions    { get; set; }
    
    public RN_MultiselectAutoCompleteCtrl()
    {
        rightOptions = new List<SelectOption>();
        leftOptions = new List<SelectOption>();
        strSelectedOptions = '';
    }
    public void assignToSelectedOption()
    {    
        set<String> setString = new set<String>();
        
        for(String strValue: strSelectedOptions.split(',')){
            setString.add(strValue.trim());
        }
        
        rightOptions.clear();
        
        for(SelectOption objOption: leftOptions)
        {
            if(setString.contains(objOption.getValue()))
                rightOptions.add(objOption);
        }
    }
    public string getMultiselectOptions()
    {
        String strJSON = '[';
        for(SelectOption objOption: leftOptions)
        {
            strJSON += ',{\"id\":"' + objOption.getValue() + '", \"name\":"' + objOption.getLabel()+ '"}';
        }
        strJSON = strJSON.replaceFirst(',', '') + ']';
        return strJSON;
    }
}