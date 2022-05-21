@IsTest
public with sharing class ShowSubscriptionsControllerTest {
    @TestSetup
    static void makeData(){
        Id UserId = UserInfo.getUserId();

        Account account = new Account(
            Name = 'AccountTest'
        );
        insert account;

        Contact contact = new Contact(
                FirstName='Test',
                LastName='Test',
                Phone='415.555.1212',
                Email = 'test' + '@gmail.com',
                RelatedUser__c = UserId
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
    static void getAccountsTest(){
        
        Test.startTest();
        Id UserId = UserInfo.getUserId();
        List<ShowSubscriptionsController.DataTableWrapper> result = ShowSubscriptionsController.getAccounts(UserId);

        Test.stopTest();

        System.assertEquals(1, result.size());
        
    }
}