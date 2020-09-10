trigger AccountAddressTrigger on Account (before insert,before Update) {
    AccountAddressTriggerHandler.matchPostalCode(Trigger.New);
}