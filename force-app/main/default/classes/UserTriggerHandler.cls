public without sharing class UserTriggerHandler extends TriggerHandler{
    private Map<Id, User> newUserMap;

    public UserTriggerHandler() {
        this.newUserMap = (Map<Id, User>) Trigger.newMap;
    }

    public override void afterInsert(){
        createContacts();
    }

    private void createContacts(){
        List<Contact> createdContacts = new List<Contact>();
        for(User user: (List<User>) Trigger.New){
            Contact contact = new Contact(
                FirstName = user.FirstName,
                LastName = user.LastName,
                MailingCountry = user.Country,
                MailingCity = user.City,
                MailingStreet = user.Street,
                MailingPostalCode = user.PostalCode,
                RelatedUser__c = user.Id,
                Email = user.Email
            );
            createdContacts.add(contact);
        }
        system.debug(createdContacts);
        insert createdContacts;
    }
}