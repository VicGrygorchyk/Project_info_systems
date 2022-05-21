/**
 * An apex class that creates a portal user
 */
public without sharing class SiteRegisterController {
    // PORTAL_ACCOUNT_ID is the account on which the contact will be created on and then enabled as a portal user.
    // you need to add the account owner into the role hierarchy before this will work - please see Customer Portal Setup help for more information.       
    private static Id PORTAL_ACCOUNT_ID = '001x000xxx35tPN';
    
    public SiteRegisterController () {
    }

    public String firstName {get; set;}
    public String lastName {get; set;}
    public String username {get; set;}
    public String email {get; set;}
    public String street {get; set;}
    public String city {get; set;}
    public String password {get; set {password = value == null ? value : value.trim(); } }
    public String confirmPassword {get; set { confirmPassword = value == null ? value : value.trim(); } }
    public String communityNickname {get; set { communityNickname = value == null ? value : value.trim(); } }
    public Exception e;

    public String getE () {
        return e?.getMessage();
    }

    private boolean isValidPassword() {
        return password == confirmPassword;
    }
    
    public PageReference registerUser() {
        try {
            if (!isValidPassword()) {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.site.passwords_dont_match);
                ApexPages.addMessage(msg);
                return null;
            }    
            Profile communityUserProfile = [
                SELECT ID 
                FROM Profile 
                WHERE Name = 'Standard Platform Community User'
                LIMIT 1
            ];
            User u = new User();
            u.FirstName = firstName;
            u.LastName = lastName;
            u.Username = username;
            u.Alias = 'testplat';
            u.Email = email;
            u.CommunityNickname = communityNickname;
            u.ProfileId = communityUserProfile.Id;
            u.Street = street;
            u.City = city;
            u.LocaleSidKey = 'en_US';
            u.TimeZoneSidKey = 'GMT';
            u.LanguageLocaleKey = 'en_US';
            u.EmailEncodingKey = 'UTF-8';
            insert u;
        } catch (Exception e) {
            this.e = e;
        }
        // it's okay if password is null - we'll send the user a random password in that case
        
        
        // String accountId = PORTAL_ACCOUNT_ID;

        // // lastName is a required field on user, but if it isn't specified, we'll default it to the username
        // String userId = Site.createPortalUser(u, accountId, password);
        // if (userId != null) { 
        //     if (password != null && password.length() > 1) {
        //         return Site.login(username, password, null);
        //     }
        //     else {
        //         PageReference page = System.Page.SiteRegisterConfirm;
        //         page.setRedirect(true);
        //         return page;
        //     }
        // }
        return null;
    }
}