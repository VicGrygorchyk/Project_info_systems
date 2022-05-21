public with sharing class SelectEventController {
    @AuraEnabled(cacheable=true)
    public static List<Event> getEvents(Id ContactId, Id AccountId){
        List<Subscription__c> subscriptions = [
            SELECT Id, Account__c 
            FROM Subscription__c
            WHERE Contact__c = :ContactId
            AND Account__c = :AccountId
            AND IsOrganizer__c = true
        ];

        Set<Id> accountIds = new Set<Id>();
        for(Subscription__c subscription : subscriptions){
            accountIds.add(subscription.Account__c);
        }

        List<Campaign> campaigns = [
            SELECT Id 
            FROM Campaign
            WHERE Account__c IN :accountIds
        ];

        List<Event> events = [
            SELECT Id, Subject
            FROM Event 
            WHERE WhatId IN :campaigns
        ];
        system.debug('events' + events);
        return events;
    }
}