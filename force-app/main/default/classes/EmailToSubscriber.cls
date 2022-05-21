public with sharing class EmailToSubscriber {
    @InvocableMethod
    public static List<String> getEmailBodyForSubscribers(List<Id> eventId){
        Event event = [
            SELECT Id, StartDateTime, EndDateTime, Description, WhatId
            FROM Event 
            WHERE Id = :eventId[0]
            LIMIT 1
        ];
        Campaign campaign = [
            SELECT Id, Account__c
            FROM Campaign
            WHERE Id = :event.WhatId
            LIMIT 1
        ];
        Account account = [
            SELECT Id, Name
            FROM Account
            WHERE Id = :campaign.Account__c
            LIMIT 1
        ];
        String body = 'Вас було запрошено на нову подію\n' + 
                    'Локація: ' + account.Name + '\n' +
                    'Початок: ' + event.StartDateTime + '\n' +
                    'Кінець: ' + event.EndDateTime + '\n' +
                    'Детальна інформація: ' + event.Description;
        system.debug('body:' + body);
        List<String> returnList = new List<String>();
        returnList.add(body);
        return returnList;
    }
}