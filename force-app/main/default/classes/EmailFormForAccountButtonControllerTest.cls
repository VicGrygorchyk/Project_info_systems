@IsTest
public with sharing class EmailFormForAccountButtonControllerTest {
    @TestSetup
    static void makeData(){
        Id UserId = UserInfo.getUserId();

        Contact contact = new Contact(
            FirstName = 'Test Contact',
            LastName = 'Test Contact',
            Email = 'test@test.com',
            RelatedUser__c = UserId
        );
        insert contact;

        Account account = new Account(
            Name = 'Test'
        );
        insert account;

        Subscription__c subscription = new Subscription__c(
            Contact__c = contact.Id,
            Account__c = account.Id
        );
        insert subscription;
    }

    @IsTest
    static void sendEmailTest(){
        Account account = [SELECT Id FROM Account LIMIT 1];
        List<String> emailAdresses = new List<String>();
        List<Id> contentDocumentsIds = new List<Id>();
        String subject = 'subjectTest';
        String body = 'bodyTest';
        
        EmailFormForAccountButtonController.sendEmail(account.Id, emailAdresses, contentDocumentsIds, subject, body);
        Integer invocations = Limits.getEmailInvocations();
        system.assertEquals(1, invocations, 'An email should be sent');
    }
}