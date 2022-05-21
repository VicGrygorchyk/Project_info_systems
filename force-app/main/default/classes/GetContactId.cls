public with sharing class GetContactId {
    @InvocableMethod
    public static List<Id> getContact(){
        Id UserId = UserInfo.getUserId();
        Contact c = [SELECT Id FROM Contact WHERE RelatedUser__c = :UserId LIMIT 1];
        List<Id> contactId = new List<Id>();
        contactId.add(c.Id);
        return contactId;
    }
}