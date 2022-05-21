public with sharing class InviteRelatedContactsController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getRelatedContacts(Id AccountId){
        List<Subscription__c> subscriptions = [
            SELECT Id, Contact__c 
            FROM Subscription__c
            WHERE Account__c = :AccountId
        ];

        Set<Id> relatedConractsIds = new Set<Id>();
        for(Subscription__c subscription : subscriptions){
            relatedConractsIds.add(subscription.Contact__c);
        }

        List<Contact> relatedContacts = [
            Select Id, Name, Email
            FROM Contact
            WHERE Id IN :relatedConractsIds
        ];

        return relatedContacts;
    }
}