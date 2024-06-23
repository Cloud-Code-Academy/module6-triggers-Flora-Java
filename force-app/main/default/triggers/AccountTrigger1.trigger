trigger AccountTrigger1 on Account (before insert, after insert) {
  // Author: Flora Lopez
    if(Trigger.isBefore && Trigger.isInsert) {
            AccountTriggerHandler.beforeInsert(Trigger.new);
    }
    List<Contact> contacts = new List<Contact>();
    if(Trigger.isAfter && Trigger.isInsert) {
        AccountTriggerHandler.afterInsert(Trigger.new);
    }
}