public with sharing class EventAction {
    @InvocableMethod
    public static List<List<String>> getContactsEmails(List<List<Id>> ids) {
        system.debug('ids' + ids);
        List<Id> idList = new List<Id>();
        for(Id id : ids[0]){
            idList.add(id);
        }
        system.debug('idList' + idList);
        List<Contact> contacts = [
            SELECT Id, Email 
            FROM Contact
            WHERE Id IN :idList
        ];
        List<String> emails = new List<String>();
        for(Contact c : contacts){
            if(c.Email != null)
                emails.add(c.Email);
        }
        List<List<String>> emailsToReturn = new List<List<String>>();
        emailsToReturn.add(emails);
        system.debug(emailsToReturn);
        return emailsToReturn;
    }
}