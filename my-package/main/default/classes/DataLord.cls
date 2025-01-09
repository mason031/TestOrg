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
    
    
}
