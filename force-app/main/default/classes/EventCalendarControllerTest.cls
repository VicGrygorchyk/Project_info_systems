@IsTest
public with sharing class EventCalendarControllerTest {
    @TestSetup
    static void makeData(){
        Id UserId = UserInfo.getUserId();

        Contact contact = new Contact(
            FirstName = 'Test Contact',
            LastName = 'Test Contact',
            RelatedUser__c = UserId
        );
        insert contact;

        Account account = new Account(
            Name = 'AccountTest'
        );
        insert account;

        Campaign campaign = new Campaign(
            Name = 'CampaignTest',
            Account__c = account.Id
        );
        insert campaign;

        Event event = new Event(
            Subject = 'SubjectTest',
            StartDateTime = Date.today(),
            EndDateTime = Date.today().addDays(1),
            Description = 'DescriptionTest',
            WhatId = campaign.Id
        );
        insert event;

        CampaignMember cm = new CampaignMember(
            Account__c = account.Id,
            CampaignId = campaign.Id,
            ContactId = contact.Id,
            Status='Sent'
        );
        insert cm;
    }

    @IsTest
    static void fetchAllEventsTest(){
        
        Test.startTest();
        Id UserId = UserInfo.getUserId();
        List<Event> events = EventCalendarController.fetchAllEvents(UserId);
        Test.stopTest();
        System.assertEquals(1, events.size());
    }
}