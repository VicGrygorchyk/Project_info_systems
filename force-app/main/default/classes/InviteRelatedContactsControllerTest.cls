@IsTest
public with sharing class InviteRelatedContactsControllerTest {
    @TestSetup
    static void makeData(){
        String[] names = new String[]{'Joe', 'Dick', 'Bob', 'Bill', 'Travis'};
        Account account = new Account(
            Name = 'AccountTest'
        );
        insert account;

        List<Contact> cs = new List<Contact>();
        for(Integer i = 0; i < 5; i++){
            Contact contact = new Contact(
                FirstName=names[i],
                LastName=names[i],
                Phone='415.555.1212',
                AccountId = account.Id,
                Email = names[i] + '@gmail.com'
            );
            cs.add(contact);
        }
        insert cs;

        List<Subscription__c> subscriptions = new List<Subscription__c>();
        for(Contact c : cs){
            Subscription__c s = new Subscription__c();
            s.Account__c = account.Id;
            s.Contact__c = c.Id;
            s.IsOrganizer__c = false;
            subscriptions.add(s);
        }
        insert subscriptions;

    }

    @IsTest
    static void getRelatedContactsTest(){
        
        Test.startTest();
        Account a = [SELECT Id FROM Account LIMIT 1];
        List<Contact> cs = InviteRelatedContactsController.getRelatedContacts(a.Id);
        Test.stopTest();

        system.assertEquals(5, cs.size());
        
    }
}