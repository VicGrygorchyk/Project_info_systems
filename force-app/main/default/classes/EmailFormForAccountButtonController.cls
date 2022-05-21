public with sharing class EmailFormForAccountButtonController {
    @AuraEnabled
    public static void sendEmail(Id AccountId, List<String> emailAdresses, List<Id> contentDocumentsIds, String subject, String body){
        try {
            List<ContentVersion> ContentVersions = [
                SELECT Id
                FROM ContentVersion
                WHERE ContentDocumentId IN :contentDocumentsIds
            ];
            List<Id> contentVersionIds = new List<Id>();
            for(ContentVersion cv : ContentVersions)
                contentVersionIds.add(cv.Id);

            List<Subscription__c> subscriptions = [
                SELECT Id, Contact__c 
                FROM Subscription__c
                WHERE Account__c = :AccountId
            ];
            Set<Id> relatedConTactsIds = new Set<Id>();
            for(Subscription__c subscription : subscriptions){
                relatedConTactsIds.add(subscription.Contact__c);
            }
            List<Contact> relatedContacts = [SELECT Id, Email FROM Contact WHERE Id IN :relatedConTactsIds];
            for(Contact c : relatedContacts){
                emailAdresses.add(c.Email);
            }
            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
            for(String emailAdress: emailAdresses){
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new String[] {emailAdress});
                email.setSubject(subject);
                email.setHtmlBody(body);
                email.setEntityAttachments(contentVersionIds);
                emails.add(email);
        }
            Messaging.sendEmail(emails);
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
        
    }
}