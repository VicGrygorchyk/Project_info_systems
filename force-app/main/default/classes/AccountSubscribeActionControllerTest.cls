@IsTest
public with sharing class AccountSubscribeActionControllerTest {
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
            Name = 'Test'
        );
        insert account;
    }

    @IsTest
    static void isSubscriberTest(){
        Account a = [SELECT Id FROM Account WHERE Name = 'Test' LIMIT 1];
        Test.startTest();
        Boolean isSubscriber;
        isSubscriber = AccountSubscribeActionController.isSubscriber(a.Id);
        Test.stopTest();
        system.assertEquals(false, isSubscriber);
        
    }


    @IsTest
    static void followTest(){
        Account a = [SELECT Id FROM Account WHERE Name = 'Test' LIMIT 1];

        Test.startTest();
        AccountSubscribeActionController.follow(a.Id);
        Test.stopTest();

        List<Subscription__c> s = [SELECT Id FROM Subscription__c];
        system.assertEquals(1, s.size());
        
    }

    @IsTest
    static void unfollowTest(){
        Account a = [SELECT Id FROM Account WHERE Name = 'Test' LIMIT 1];

        Test.startTest();
        AccountSubscribeActionController.follow(a.Id);
        AccountSubscribeActionController.unfollow(a.Id);
        Test.stopTest();

        List<Subscription__c> s = [SELECT Id FROM Subscription__c];
        system.assertEquals(0, s.size());
        
    }
}