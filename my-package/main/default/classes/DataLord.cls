public with sharing class DataLord {
    public DataLord() {

    }
    
    public static Integer NumAccounts(){
        return [SELECT COUNT() FROM Account];
    }

    public static Integer NumHot(){
        return [SELECT COUNT() FROM Account WHERE Rating = 'Hot'];
    }

    public static Integer NumComplex(){
        return [SELECT COUNT() FROM Account WHERE Name LIKE '%&%'];
    }

    public static List<Account> BigFive(){
        return [SELECT Name FROM Account ORDER BY AnnualRevenue DESC NULLS LAST LIMIT 5];
    }

    public static Opportunity LastBigOpportunity(){
        return [SELECT Name, CloseDate FROM Opportunity WHERE Amount > 100000 ORDER BY CloseDate DESC LIMIT 1];
    }

    public static List<Contact> MajorPlayers(){
        return [SELECT Name, Account.Name FROM Contact WHERE Account.Rating = 'Hot'];
    }

    
    public static String MostPopularAccount(){
        List<AggregateResult> AccountsAgg = [SELECT Account.Name accName FROM Contact GROUP BY Account.Name ORDER BY COUNT(Id) DESC LIMIT 1];
        String name = (String)AccountsAgg[0].get('accName');
        return name;
    }

    public static List<String> BigLeadSources(){
        List<String> results = new List<String>();
        List<AggregateResult> agg =[SELECT LeadSource, Rating FROM Lead WHERE Rating = 'Hot' AND LeadSource != null GROUP BY LeadSource, Rating ORDER BY Count(LeadSource) DESC LIMIT 5];
        for(AggregateResult a: agg){
            String s = (String)a.get('LeadSource');
            
            String s2 = (String)a.get('Rating');
            results.add(s+'-'+s2);
        }
        return results;
    }

    public static List<List<sObject>> TomFinder(){
        return [FIND 'Tom' RETURNING Contact(Name), Lead(Name)];
    }

    public static List<Account> AandOFinder(){
        List<List<sObject>> newObject = [FIND 'a* AND o*' RETURNING Account(name)];
        List<Account> act = newObject[0];
        return act;
    }

    public static List<List<sObject>> PhoneNumberFinder(){
        List<List<sObject>> newObject = [FIND '*1000' IN PHONE FIELDS RETURNING Account(Name), Contact(Name), Lead(Name)];
        return newObject;
    }

    public static void SpawnContacts (){
        List<Contact> contactList = new List<Contact>();
        for(Integer i = 0; i<200;i++){
            String firstName = 'John'+ i;
            String lastName = 'Doe'+ i;
            Contact newPerson = new Contact(FirstName = firstName, LastName = lastName);
            contactList.add(newPerson);
        }
        insert contactList;
    }
    public static void CreateHomes (){
        List<Account> accountList = new List<Account>();
        Account newHome = new Account(name = 'home1');
        Account newHome2 = new Account(name = 'home2');
        Account newHome3 = new Account(name = 'home3');
        accountList.add(newHome);
        accountList.add(newHome2);
        accountList.add(newHome3);
        insert accountList;
    }
    public static void Relocate(){
        List<Contact> toDelete = [SELECT Id FROM Contact ORDER BY CreatedDate DESC LIMIT 50];
        delete toDelete;
    }
    public static void AssignHomes(){
        List<Contact> johnDoes = [SELECT Id FROM Contact WHERE FirstName LIKE 'John%' AND LastName LIKE 'Doe%'];
        List<Account> homes = [SELECT Id FROM Account WHERE Name LIKE 'home%'];
        for(Contact c: johnDoes){
            Integer num = (Integer)(Math.random()*3);
            
            c.AccountId=homes[num].Id;
            
        }
        update johnDoes;
    }

    public static void Play(){
        Savepoint save = Database.setSavepoint();
        System.debug('Number of contacts at start: ' + [SELECT COUNT() FROM Contact]);
        System.debug('Number of accounts at start: ' + [SELECT COUNT() FROM Account]);
        SpawnContacts();
        CreateHomes();
        Relocate();
        AssignHomes();
        System.debug('Number of contacts at finish: ' + [SELECT COUNT() FROM Contact]);
        System.debug('Number of accounts at finish: ' + [SELECT COUNT() FROM Account]);
        List<AggregateResult> agg = [SELECT Account.Name Name, COUNT(Id) Num FROM Contact GROUP BY AccountId, Account.Name ORDER BY COUNT(Id) DESC];
        List<String> results = new List<String>();
        for(AggregateResult a: agg){
            results.add(a.get('Name')+' has '+a.get('Num')+' amount of contacts');
        }
        System.debug('Number of related contacts for each account' + results);
        Database.rollback(save);
        System.debug('Rolled back');

    }


    
    
}