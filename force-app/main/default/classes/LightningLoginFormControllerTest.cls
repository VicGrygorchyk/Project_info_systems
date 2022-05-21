@IsTest
public with sharing class LightningLoginFormControllerTest {
    @TestSetup
    static void makeData(){
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard Platform Community User' LIMIT 1];
        
        User usr = new User(LastName = 'LIVESTON',
                          FirstName='JASON',
                          Alias = 'jliv',
                          Email = 'jason.liveston@asdf.com',
                          Username = 'jason.liveston@asdf142.com',
                          ProfileId = profileId.id,
                          TimeZoneSidKey = 'GMT',
                          LanguageLocaleKey = 'en_US',
                          EmailEncodingKey = 'UTF-8',
                          LocaleSidKey = 'en_US'
                          );
        insert usr;

        System.setPassword(usr.Id, 'qwerty1234');
    }

    @IsTest
    static void loginTest(){
        
        Test.startTest();
        String message = LightningLoginFormController.login(
            'jason.liveston@asdf142.com',
            'qwerty1234',
            'https://sportinfrastructure-developer-edition.eu40.force.com/lvivsportsevents/s/login/?ec=302&startURL=%2Flvivsportsevents%2Fs%2F'
        );
        Boolean IsUsernamePasswordEnabled = LightningLoginFormController.getIsUsernamePasswordEnabled();
        Boolean IsSelfRegistrationEnabled = LightningLoginFormController.getIsSelfRegistrationEnabled();
        String getSelfRegistrationUrl = LightningLoginFormController.getSelfRegistrationUrl();
        String getForgotPasswordUrl = LightningLoginFormController.getForgotPasswordUrl();
        String setExperienceId = LightningLoginFormController.setExperienceId(null);
        String setExperienceIdRegister = LightningSelfRegisterController.setExperienceId(null);
        String setExperienceIdForgot = LightningForgotPasswordController.setExperienceId(null);
        String setExperienceIdForgotNotNull = LightningForgotPasswordController.setExperienceId('test');
        Test.stopTest();
        
    }
}