@IsTest
public with sharing class EventActionTest {
    @TestSetup
    static void makeData(){
        List<Contact> contacts = new List<Contact>();
        for(Integer i = 0; i < 5; i++){
            Contact contact = new Contact();
            contact.Email = 'test' + i + '@gmail.com';
            contact.FirstName = 'Test Contact';
            contact.LastName = 'Test Contact';
            contacts.add(contact);
        }
        insert contacts;
    }

    @IsTest
    static void getContactsEmails(){
        
        Test.startTest();
        List<Contact> contacts = [SELECT Id FROM Contact WHERE FirstName = 'Test Contact'];
        List<Id> contactIds = new List<Id>();
        for(Contact c : contacts){
            contactIds.add(c.Id);
        }
        List<List<Id>> ids = new List<List<Id>>();
        ids.add(contactIds);
        List<List<String>> emails = EventAction.getContactsEmails(ids);
        Test.stopTest();

        system.assertEquals(5, emails[0].size());
        
    }
}