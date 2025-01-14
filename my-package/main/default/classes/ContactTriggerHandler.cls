public with sharing class ContactTriggerHandler {
    public ContactTriggerHandler() {

    }
    public static void main(){

        switch on Trigger.operationType{
            when BEFORE_INSERT{
                setDefaultValueForEmail(trigger.new);
                emailDomainValidation(trigger.new);
            }
            when BEFORE_UPDATE{
                emailDomainValidation(trigger.new);
            }
            when AFTER_INSERT{

            }
            when AFTER_UPDATE{
                updatePhoneField((List<Contact>)trigger.new, (Map<Id,Contact>)trigger.oldMap);
                
            }
            when BEFORE_DELETE{
              
            }
            when AFTER_DELETE{

            }
            when AFTER_UNDELETE{

            }
        }
    }

    public static void emailDomainValidation(List<Contact> contacts){
        Map <Id, Id> contactToAccountMap = New Map<Id, Id>();
        List<Id> accountIds = new List<Id>();

        for(Contact c: contacts){
            Id accountId = c.accountId;
            if(c.accountId == null){
                continue;
            }
            accountIds.add(accountId);
            contactToAccountMap.put(c.Id, accountId);
            //accountToEmailMap.put(accountId, c.email);
        }

        //List<Account> accounts = [SELECT Id FROM Account WHERE Id IN :contactToAccountMap.values()];
        List<Contact> emailContacts = [SELECT Id, AccountId, Email FROM Contact WHERE Account.Id In :contactToAccountMap.values()];
        Map<Id, List<Contact>> accountToContactList = New Map<Id, List<Contact>>();
        for(Contact c: emailContacts){
            if (accountToContactList.get(c.AccountId)==null){
                List<Contact> accountContacts = new List<Contact>();

                accountContacts.add(c);
                accountToContactList.put(c.AccountId, accountContacts);
            }
            else{
                accountToContactList.get(c.AccountId).add(c);
            }
        }

        for(Contact c: contacts){
            if(c.accountId == null){
                continue;
            }
            List<Contact> accountContacts = accountToContactList.get(c.accountId);
            if(accountContacts==null){
                continue;
            }
            for(Contact cCompare: accountContacts){
                if (cCompare.email == null){
                    continue;
                }

                if (c.email.split('@')[1] != cCompare.email.split('@')[1]){
                    c.addError('Email must be in same domain as other contacts');
                }
            }
            
        }

        
    }

    public static void updatePhoneField(List<Contact> contacts, Map <Id, Contact> oldMap){
        Map <Id, String> accountToPhoneMap = new Map<Id, String>();
        for(Contact c: contacts){
            Id accountId = c.AccountId;
            Contact oldC = oldMap.get(c.Id);
            if(oldC.Phone != c.Phone){
                accountToPhoneMap.put(accountId, c.Phone);
            }
        }
        List<Account> accounts = [SELECT Id FROM Account WHERE Id IN :accountToPhoneMap.keySet() ];

        for(Account a: accounts){
            a.Phone = accountToPhoneMap.get(a.Id);
        }
        Database.update(accounts);

    }
    public static void setDefaultValueForEmail(List<Contact> contacts){

        for (Contact c: contacts){
            if(String.isEmpty(c.email)){
                c.email = 'defaultemail@123.com';
            }
        }
    }
}