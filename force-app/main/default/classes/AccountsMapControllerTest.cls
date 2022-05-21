@IsTest
public with sharing class AccountsMapControllerTest {
    @TestSetup
    static void setup(){
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        
        User usr = new User(LastName = 'LIVESTON',
                          FirstName='JASON',
                          Alias = 'jliv',
                          Email = 'jason.liveston@asdf.com',
                          Username = 'jason.liveston@asdf142.com',
                          ProfileId = profileId.id,
                          TimeZoneSidKey = 'GMT',
                          LanguageLocaleKey = 'en_US',
                          EmailEncodingKey = 'UTF-8',
                          LocaleSidKey = 'en_US'
                          );
        insert usr;

        List<Account> accs = new List<Account>();
        
        for(Integer i = 0; i <5; i++){
            accs.add(new Account(
                Name = 'Test' + i,
                ShippingLatitude = i, 
                ShippingLongitude = 4 - i,
                SportTypes__c = 'soccer'
            ));
        }
        insert accs;

    }

    @IsTest
    private static void getMapItemsTest(){
        User u = [SELECT Id FROM User WHERE LastName='LIVESTON' LIMIT 1];
        Contact contact = [SELECT Id, MailingLatitude, MailingLongitude  FROM Contact WHERE LastName = 'LIVESTON'];
        contact.MailingLatitude = 0;
        contact.MailingLongitude = 0;
        update contact;
        // Account mainAccount = new Account(
        //     Name = 'Main',
        //     MailingLatitude = 0, 
        //     MailingLongitude = 0, 
        //     BillingLatitude = 10, 
        //     BillingLongitude = -5
        // );
        // insert mainAccount;
        List<String> emptyTypes = new List<String>();
        List<String> types = new List<String>();
        types.add('soccer');

        List<Account> lessThan1000MailingDistance = AccountsMapController.getAccounts(u.Id, 1000, types);
        List<Account> lessThan1000MailingDistanceAllAccountOwnLeads = AccountsMapController.getAccounts(u.Id, 1000, emptyTypes);
        System.assertEquals(5, lessThan1000MailingDistance.size());
        System.assertEquals(5, lessThan1000MailingDistanceAllAccountOwnLeads.size());
    }

    @IsTest
    static void getSportsTest(){
        List<String> sports = AccountsMapController.getSports();
        System.assertNotEquals(sports.size(), 0);
    }
}