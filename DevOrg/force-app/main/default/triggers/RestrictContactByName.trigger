trigger RestrictContactByName on Contact (before insert, before update,after insert) {
    //check contacts prior to insert or update for invalid data
    if( !Trigger.isAfter && !Trigger.isInsert){
        For (Contact c : Trigger.New) {
            if(c.LastName == 'INVALIDNAME') {   //invalidname is invalid
                c.AddError('The Last Name "'+c.LastName+'" is not allowed for DML');
            }
    
        }
    }
    else{
        //List<Account> accList = [Select id,Name,(Select id,Name from Contacts) from Account where id =:trigger.new[0].AccountId];
        //system.assert(false,accList[0].Contacts.size());
    }
}