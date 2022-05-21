@IsTest
public with sharing class GetContactIdTest {
    @TestSetup
    static void makeData(){
        Id UserId = UserInfo.getUserId();

        Contact contact = new Contact(
            FirstName = 'Test Contact',
            LastName = 'Test Contact',
            RelatedUser__c = UserId
        );
        insert contact;
    }

    @IsTest
    static void getContactTest(){
        
        Test.startTest();
        Contact c = [SELECT Id FROM Contact LIMIT 1];
        List<Id> contactId = GetContactId.getContact();
        Test.stopTest();
        System.assertEquals(contactId[0], c.Id);
        
    }
}