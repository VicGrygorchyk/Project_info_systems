public with sharing class ShowSubscriptionsController {
    @AuraEnabled(cacheable=true)
    public static List<DataTableWrapper> getAccounts(Id UserId){
        Contact relatedContact = [
            SELECT Id, MailingAddress
            FROM Contact
            WHERE RelatedUser__c = :UserId
            LIMIT 1
        ];

        List<Subscription__c> subscriptions = [
            SELECT Id, Account__c
            FROM Subscription__c
            WHERE Contact__c = :relatedContact.Id
        ];

        List<Id> accountIds = new List<Id>();
        for(Subscription__c s : subscriptions){
            accountIds.add(s.Account__c);
        }

        List<Account> accs = [
            Select Id, Name, Site, Phone
            FROM Account
            WHERE Id IN :accountIds
        ];

        List<DataTableWrapper> wrappers = new List<DataTableWrapper>();

        for(Account a : accs){
            DataTableWrapper dtw = new DataTableWrapper();
            dtw.Id = a.Id;
            dtw.Name = a.Name;
            dtw.Url = '/lvivsportsevents/s/account/' + a.Id;
            dtw.Site = a.Site;
            dtw.Phone = a.Phone;
            wrappers.add(dtw);
        }

        return wrappers;
    }

    public class DataTableWrapper {
        @AuraEnabled
        public Id Id {get;set;}
        @AuraEnabled
        public String Name {get;set;}
        @AuraEnabled
        public String Url {get;set;}
        @AuraEnabled
        public String Site {get;set;}
        @AuraEnabled
        public String Phone {get;set;}
    }
}