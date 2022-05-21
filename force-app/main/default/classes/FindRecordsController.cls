public with sharing class FindRecordsController {
    public FindRecordsController() {}

    @AuraEnabled(cacheable=true)
    public static List<SObJectResult> getResults(String value, List<String> selectedRecIds, Id AccountId) {
        List<Subscription__c> subscriptions = [
            SELECT Id, Contact__c 
            FROM Subscription__c
            WHERE Account__c = :AccountId
        ];
        Set<Id> relatedConTactsIds = new Set<Id>();
        for(Subscription__c subscription : subscriptions){
            relatedConTactsIds.add(subscription.Contact__c);
        }

        List<SObJectResult> sObjectResultList = new List<SObJectResult>();
        if(selectedRecIds == null){
            selectedRecIds = new List<String>();
        }
        if(String.isEmpty(value)){
            for(Contact c : [
                SELECT Id, Name, Email 
                FROM Contact
                WHERE LastViewedDate != null
                AND Id NOT IN :selectedRecIds
                AND Id NOT IN :relatedConTactsIds
                ORDER BY LastViewedDate DESC NULLS LAST
                LIMIT 3
            ]){
                sObjectResultList.add(new sObjectResulT(c.Name, c.Id, c.Email, 'standard:contact', 'Contact'));
            }
            for(Lead l : [
                SELECT Id, Name, Email 
                FROM Lead
                WHERE LastViewedDate != null
                AND Id NOT IN :selectedRecIds
                ORDER BY LastViewedDate DESC NULLS LAST
                LIMIT 3
            ]){
                sObjectResultList.add(new sObjectResulT(l.Name, l.Id, l.Email, 'standard:lead', 'Lead'));
            }
        }
        else {
            value ='*' + value + '*';
            List<List<SObject>> records = [
                FIND :value 
                IN Name FIELDS
                RETURNING 
                Contact (Id, Name, Email WHERE Id NOT IN :selectedRecIds AND Id NOT IN :relatedConTactsIds), 
                Lead(Id, Name, Email WHERE Id NOT IN :selectedRecIds)
            ];
            for(Contact c: (List<Contact>) records[0]){
                sObjectResultList.add(new sObjectResulT(c.Name, c.Id, c.Email, 'standard:contact', 'Contact'));
            }
            for(Lead l: (List<Lead>)records[1]){
                sObjectResultList.add(new sObjectResulT(l.Name, l.Id, l.Email, 'standard:lead', 'Lead'));
            }
        }
        return sObjectResultList;
    }
    
    public class SObjectResult {
        @AuraEnabled
        public String recName;
        @AuraEnabled
        public Id recId;
        @AuraEnabled
        public String recEmail;
        @AuraEnabled
        public String iconName;
        @AuraEnabled
        public String type;

        public SObJectResult(String recNameTemp, Id recIdTemp, String recEmailTemp, String iconNameTemp, String typeTemp) {
            recName = recNameTemp;
            recId = recIdTemp;
            recEmail = recEmailTemp;
            iconName = iconNameTemp;
            type = typeTemp;
        }
        public SObJectResult() {
          
        }
    }
}