@IsTest
public with sharing class EmailToSubscriberTest {
    @TestSetup
    static void makeData(){
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
    }

    @IsTest
    static void getEmailBodyForSubscribersTest(){
        
        Test.startTest();
        Event event = [SELECT Id FROM Event WHERE Subject = 'SubjectTest' LIMIT 1];
        List<Id> eventId = new List<Id>();
        eventId.add(event.Id);
        List<String> body = EmailToSubscriber.getEmailBodyForSubscribers(eventId);
        Test.stopTest();
        System.assertNotEquals(0, body[0].length());       
    }
}