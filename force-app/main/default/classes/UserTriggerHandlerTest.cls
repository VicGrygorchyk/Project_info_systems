@IsTest
public with sharing class UserTriggerHandlerTest {
    @TestSetup
    static void makeData(){
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
    }
    @IsTest
    static void checkContacts(){
        List<Contact> cons = [
            SELECT Id, Name FROM Contact
        ];
        system.debug(cons);
        
    }
    
}