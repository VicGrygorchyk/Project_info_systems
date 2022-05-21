public with sharing class SelectAccountController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(Id ContactId){
        List<Subscription__c> subscriptions = [
            SELECT Id, Account__c 
            FROM Subscription__c
            WHERE Contact__c = :ContactId
            AND IsOrganizer__c = true
        ];

        Set<Id> accountIds = new Set<Id>();
        for(Subscription__c subscription : subscriptions){
            accountIds.add(subscription.Account__c);
        }

        List<Account> accounts = [
            Select Id, Name
            FROM Account
            WHERE Id IN :accountIds
        ];

        return accounts;
    }
}