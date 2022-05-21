public with sharing class AccountsMapController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(Id userId, Double maxDistance, List<String> types) {
        system.debug('types: ' + types);
        Address address;
        Contact relatedContact = [
            SELECT Id, MailingAddress
            FROM Contact
            WHERE RelatedUser__c = :userId
            LIMIT 1
        ];
        system.debug(relatedContact.MailingAddress);
        address = relatedContact.MailingAddress;

        List<Account> accounts;
        if(types != null && types.size() > 0){
            String typesStringValue = '';
            for(String type: types){
                typesStringValue += type + ';';
            }
            typesStringValue = typesStringValue.removeEnd(';');
    
            accounts = [
                SELECT Id, Name, ShippingLatitude, ShippingLongitude, ShippingCountry, ShippingStreet, ShippingCity
                FROM Account 
                WHERE ShippingLatitude != null
                AND ShippingLongitude != null
                AND DISTANCE(
                    ShippingAddress,
                    :address,
                    'km') < :maxDistance
                AND SportTypes__c includes (:typesStringValue)
            ];
        } else {
            accounts = [
                SELECT Id, Name, ShippingLatitude, ShippingLongitude, ShippingCountry, ShippingStreet, ShippingCity
                FROM Account 
                WHERE ShippingLatitude != null
                AND ShippingLongitude != null
                AND DISTANCE(
                    ShippingAddress,
                    :address,
                    'km') < :maxDistance
            ];
        }
        
        return accounts;
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getSports(){
        List<String> pickListValuesList= new List<String>();
         Schema.DescribeFieldResult fieldResult = Account.SportTypes__c.getDescribe();
         List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
         for( Schema.PicklistEntry pickListVal : ple){
             pickListValuesList.add(pickListVal.getLabel());
         }     
         return pickListValuesList;
     }
}