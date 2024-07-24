public with sharing class AccountTriggerHandler {
    public static void beforeInsert(List<Account> newAccounts) {
        for(Account acct :newAccounts) {
            if (!String.isBlank(acct.Phone) &&
                !String.isBlank(acct.Website) &&
                !String.isBlank(acct.Fax)){
                acct.Rating = 'Hot';  
                }
            if(acct.type == null) {
                acct.type = 'Prospect';
            }
            if(!String.isBlank(acct.ShippingStreet) &&
                !String.isBlank(acct.ShippingCity) &&
                !String.isBlank(acct.ShippingState) &&
                !String.isBlank(acct.ShippingPostalCode) &&
                !String.isBlank(acct.ShippingCountry)) {
                String streetacc = acct.ShippingStreet;
                acct.BillingStreet = acct.ShippingStreet;
                acct.BillingCity = acct.ShippingCity;
                acct.BillingState = acct.ShippingState;
                acct.BillingPostalCode = acct.ShippingPostalCode;
                acct.BillingCountry = acct.ShippingCountry;
            }
        }
    }

    public static void afterInsert(List<Account> newInsertedAccounts) {
        List<Contact> contacts = new List<Contact>();
        for(Account acc : newInsertedAccounts){
            contacts.add( new Contact(LastName = 'DefaultContact', 
            Email = 'default@email.com',
            AccountId = acc.Id
            ));
        }
        if (!contacts.isEmpty()) {
            insert as user contacts;
        }    
    }
}