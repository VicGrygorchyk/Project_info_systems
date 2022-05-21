@IsTest
public with sharing class SelectAccountControllerTest {
    @TestSetup
    static void makeData(){
        String[] names = new String[]{'Joe', 'Dick', 'Bob', 'Bill', 'Travis'};
        Contact contact = new Contact(
                FirstName=names[0],
                LastName=names[0],
                Phone='415.555.1212',
                Email = names[0] + '@gmail.com'
            );
        
        insert contact;

        List<Account> accounts = new List<Account>();
        for(Integer i = 0; i < 5; i++){
            Account account = new Account(
                Name = names[i]
            );
            accounts.add(account);
        }
        insert accounts;

        List<Subscription__c> subscriptions = new List<Subscription__c>();
        for(Account a : accounts){
            Subscription__c s = new Subscription__c();
            s.Account__c = a.Id;
            s.Contact__c = contact.Id;
            s.IsOrganizer__c = true;
            subscriptions.add(s);
        }
        insert subscriptions;
    }

    @IsTest
    static void getAccountsTest(){
        
        Test.startTest();
        Contact c = [SELECT Id FROM Contact LIMIT 1];
        List<Account> accs = SelectAccountController.getAccounts(c.Id);
        Test.stopTest();

        system.assertEquals(5, accs.size());
        
    }
}