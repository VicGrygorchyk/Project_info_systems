public with sharing class EventCalendarController {
    @AuraEnabled
    public static List<Event> fetchAllEvents(Id userId){
        Contact contact = [
            SELECT Id 
            FROM Contact 
            WHERE RelatedUser__c = :userId
            LIMIT 1
        ];
        List<CampaignMember> campaignMembers = [
            SELECT Id, CampaignId
            FROM CampaignMember
            WHERE ContactId = :contact.Id
        ];
        List<Id> campaignIds = new List<Id>();
        for(CampaignMember cm : campaignMembers){
            campaignIds.add(cm.CampaignId);
        }
        List<Event> eventList = new List<Event>();
        eventList = [
            Select Id, Subject, WhatId, WhoId, 
                Description, EndDate, EndDateTime, OwnerId,
                ActivityDate, ActivityDateTime
            From Event 
            WHERE WhatId IN :campaignIds
        ];
        return eventList;
    }
}