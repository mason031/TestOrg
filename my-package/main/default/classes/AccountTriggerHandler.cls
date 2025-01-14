public with sharing class AccountTriggerHandler {
    public AccountTriggerHandler() {

    }
    public static void main(){

        switch on Trigger.operationType{
            when BEFORE_INSERT{
                
            }
            when BEFORE_UPDATE{

            }
            when AFTER_INSERT{
                //createRelatedContact(trigger.new);
            }
            when AFTER_UPDATE{

            }
            when BEFORE_DELETE{
                preventDeletionWithContacts(trigger.old);
            }
            when AFTER_DELETE{

            }
            when AFTER_UNDELETE{

            }
        }
    }
    public static void preventDeletionWithContacts(List<Account> accounts){
        List<Contact> contacts = [SELECT AccountId FROM Contact];
        Set<Id> AccountIds = new Set<Id>();
        for(Contact c: contacts){
            AccountIds.add(c.AccountId);
        }

        for(Account a: accounts){
            if(AccountIds.contains(a.Id)){
                a.addError('Cannot delete an account with contacts');
            }
        }
    }
    
    public static void createRelatedContact(List<Account> accounts){
        List<Contact> contactsToAdd = new List<Contact>();
        for(Account a: accounts){
            Contact c = new Contact(LastName = a.name);
            c.AccountId = a.Id;
            contactsToAdd.add(c);
        }
        Database.insert(contactsToAdd);
    }
        
    //getting an account list with the 
    
}