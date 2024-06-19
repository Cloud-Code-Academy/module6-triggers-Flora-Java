trigger AccountTrigger1 on Account (before insert, after insert) {
  // Author: Flora Lopez
    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
            for(Account acct :Trigger.new) {
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
    }
    List<Contact> contacts = new List<Contact>();
    if(Trigger.isAfter && Trigger.isInsert) {
        for(Account acc : Trigger.new){
            contacts.add( new Contact(
                    LastName = 'DefaultContact',
                    Email = 'default@email.com',
                	AccountId = acc.Id
              ));
        }    
    }
    if (!contacts.isEmpty()) {
        	insert contacts;
    	}
}