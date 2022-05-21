@IsTest
public with sharing class SelectEventControllerTest {
    @TestSetup
    static void makeData(){
        Account account = new Account(
            Name = 'AccountTest'
        );
        insert account;

        Contact contact = new Contact(
                FirstName='Test',
                LastName='Test',
                Phone='415.555.1212',
                Email = 'test' + '@gmail.com'
            );
        insert contact;
        
        Subscription__c subscription = new Subscription__c(
            Contact__c = contact.Id,
            Account__c = account.Id,
            IsOrganizer__c = true
        );
        insert subscription;

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
    }

    @IsTest
    static void getEventsTest(){
        
        Test.startTest();
        Contact c = [SELECT Id FROM Contact LIMIT 1];
        Account a = [SELECT Id FROM Account LIMIT 1];
        List<Event> events = SelectEventController.getEvents(c.Id, a.Id);
        Test.stopTest();

        system.assertEquals(1, events.size());
        
    }
}