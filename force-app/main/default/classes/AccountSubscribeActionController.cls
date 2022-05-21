public with sharing class AccountSubscribeActionController {
    @AuraEnabled
    public static Boolean isSubscriber(Id AccountId){
        Id UserId = UserInfo.getUserId();
        Contact c = [SELECT Id FROM Contact WHERE RelatedUser__c = :UserId LIMIT 1];
        Integer numberOfSubscriptions = [
            SELECT COUNT() 
            FROM Subscription__c
            WHERE Account__c = :AccountId
            AND Contact__c = :c.Id
        ];
        system.debug('isSub: ' + numberOfSubscriptions);
        if(numberOfSubscriptions > 0){
            return true;
        }
        else return false;
    }

    @AuraEnabled
    public static void follow(Id AccountId){
        Id UserId = UserInfo.getUserId();
        Contact c = [SELECT Id FROM Contact WHERE RelatedUser__c = :UserId LIMIT 1];
        Subscription__c s = new Subscription__c();
        s.Contact__c = c.Id;
        s.Account__c = AccountId;
        insert s;
   }

    @AuraEnabled
    public static void unfollow(Id AccountId){
       Id UserId = UserInfo.getUserId();
        Contact c = [SELECT Id FROM Contact WHERE RelatedUser__c = :UserId LIMIT 1];
        List<Subscription__c> subscriptions = [
            SELECT Id 
            FROM Subscription__c
            WHERE Account__c = :AccountId
            AND Contact__c = :c.Id
        ];
        delete subscriptions;
    }
}