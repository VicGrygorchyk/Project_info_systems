@IsTest
public with sharing class FindRecordsControllerTest {
    @TestSetup
    static void setup(){
        String[] names = new String[]{'Joe', 'Dick', 'Bob', 'Bill', 'Travis'};
        Account accountTest = new Account(
            Name = 'Account Test'
        );
        insert accountTest;
        List<Contact> contactsTest = new List<Contact>();
        List<Lead> leadsTest = new List<Lead>();
        List<Account> accountsTest = new List<Account>();
        for(Integer i = 0; i < 5; i++){
            Contact contact = new Contact(
                FirstName=names[i],
                LastName=names[i],
                Phone='415.555.1212',
                AccountId = accountTest.Id,
                Email = names[i] + '@gmail.com'
            );
            Lead lead = new Lead(
                Company = 'JohnMiller',
                FirstName = names[i],
                LastName = names[i], 
                Status = 'Open',
                Email = names[i] + names[i] + names[i] + '@gmail.com'
            );
            Account account = new Account(
                Name = names[i]
            );
            leadsTest.add(lead);
            accountsTest.add(account);
            contactsTest.add(contact);
        }
        insert contactsTest;
        insert accountsTest;
        insert leadsTest;
    }

    @IsTest
    static void getResultsTest(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 

        User u = new User(Alias = 'sysadmin', 
                          Email='emailsysadmin@testorg.com', 
                          EmailEncodingKey='UTF-8', 
                          LastName='Testing', 
                          LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', 
                          ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', 
                          UserName='emailsysadmin@testorg.com');
        insert u;
        // Run as user
        system.runAs(u){
            Test.startTest();
                Contact[] cs = [select id, lastvieweddate from contact limit 1 for view];
                Lead[] lds = [select id, lastvieweddate from lead limit 2 for view];
                Account[] accs = [select id, lastvieweddate from account limit 1 for view];
                List<FindRecordsController.SObjectResult> resForEmptyInput = FindRecordsController.getResults('', null, accs[0].id);
                List<FindRecordsController.SObjectResult> rosForNotEmptyInput = FindRecordsController.getResults('Joe', null, accs[0].id);
                Id [] fixedSearchResults= new Id[3];
                fixedSearchResults[0] = accs[0].Id;
                fixedSearchResults[0] = cs[0].Id;
                fixedSearchResults[0] = lds[0].Id;
                System.Test.setFixedSearchResults(fixedSearchResults);
            Test.stopTest();
            System.assertEquals(3, resForEmptyInput.size());
        }
    }
}