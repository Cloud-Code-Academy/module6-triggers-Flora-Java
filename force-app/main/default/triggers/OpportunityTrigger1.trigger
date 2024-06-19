trigger OpportunityTrigger1 on Opportunity (before update, after update, before delete, after delete) {
    if(Trigger.isBefore && Trigger.isUpdate) {
        for(Opportunity opp : Trigger.new) {
            if (opp.Amount < 5000) {
                opp.addError('Opportunity amount must be greater than 5000');
            }   
        }
    }
    if(Trigger.isBefore && Trigger.isDelete) {
        Set<Id> accountIds = new Set<Id>();
        //get all Opp Ids
        for (Opportunity opp : Trigger.old) {
        	if (opp.AccountId != null) {
            	accountIds.add(opp.AccountId);
        	}
    	}
        Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, Industry FROM Account
        WHERE Id IN :accountIds]);
        
        for (Opportunity opp : Trigger.old) {
            Account relatedAccount = accountMap.get(opp.AccountId);
           // String industry = relatedAccount.Industry;
            if (opp.StageName == 'Closed Won' && relatedAccount.Industry == 'Banking') {
                opp.addError('Cannot delete closed opportunity for a banking account that is won');
            }
        }
    }
    if(Trigger.isBefore && Trigger.isUpdate){
        Set<Id> accountIds = new Set<Id>();
         for (Opportunity opp : Trigger.new) {
        	if (opp.AccountId != null) {
            	accountIds.add(opp.AccountId);
        	}
    	}
        Map<Id,Contact> mapContact = new Map<Id,Contact>();
        if (!accountIds.isEmpty()) {
        	for (Contact contact : [SELECT Id, AccountId, Title FROM Contact
                WHERE AccountId IN :accountIds AND Title = 'CEO']) {
            	mapContact.put(contact.AccountId, contact);
        	}
    	}
        for(Opportunity oppUpdt : Trigger.new) {
            if (mapContact.containsKey(oppUpdt.AccountId)) {
            	Contact ceoContact = mapContact.get(oppUpdt.AccountId);
            	oppUpdt.Primary_Contact__c = ceoContact.Id; 
        	} 
        }
    }
}