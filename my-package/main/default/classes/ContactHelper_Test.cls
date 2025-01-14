/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class ContactHelper_Test {


    @TestSetup
    public static void setupData(){
        Account a = new Account(Name = 'Test');
        Contact c = new Contact(FirstName = 'John', LastName = 'Doe', email = 'JohnDoe@123.com', AccountId = a.Id);
        insert a;
        insert c;
    }
    @isTest
    public static void emailValidationTestPositive() {
        Account a = [SELECT Id FROM Account  WHERE Name = 'Test' LIMIT 1];
        Contact toTest = new Contact(FirstName = 'John', LastName = 'Doe', email = '1234@123.com', AccountId = a.Id);
        Test.startTest();
        Database.SaveResult sr = Database.insert(toTest);
        Test.stopTest();
        Assert.areEqual(sr.isSuccess(), true);
        
        // TO DO: implement unit test

    }
    @isTest
    public static void emailValidationTestNegative() {
        Account a = [SELECT Id FROM Account WHERE Name = 'test' LIMIT 1];
        Contact toTest = new Contact(FirstName = 'John', LastName = 'Doe', email = '1234567@1234.com', AccountId = a.Id);
        Test.startTest();
        Database.SaveResult sr = Database.insert(toTest);
        Test.stopTest();
        Assert.areEqual(!sr.isSuccess(), false);
        
        // TO DO: implement unit test

    }
    @isTest
    public static void emailValidationTestMultiplePositive(){
        List <Contact> toInsert = new List<Contact>();
        Account a = [SELECT Id FROM Account WHERE Name = 'test' LIMIT 1];
        Contact toTest = new Contact(FirstName = 'John', LastName = 'Doe', email = '1234@123.com', AccountId = a.Id);
        Contact test2 = new Contact(FirstName = 'James', LastName = 'Doe', email = '124@123.com', AccountId = a.Id);
        toInsert.add(toTest);
        toInsert.add(test2);
        Test.startTest();
        List<Database.SaveResult> sr = Database.insert(toInsert);
        Test.stopTest();
        for(Database.SaveResult s: sr){
            Assert.areEqual(s.isSuccess(), true);
        }
        
    }
    @isTest
    public static void emailValidationTestMultipleNegative(){
        List <Contact> toInsert = new List<Contact>();
        Account a = [SELECT Id FROM Account WHERE Name = 'test' LIMIT 1];
        Contact toTest = new Contact(FirstName = 'John', LastName = 'Doe', email = '1234@1234.com', AccountId = a.Id);
        Contact test2 = new Contact(FirstName = 'James', LastName = 'Doe', email = '124@1234.com', Accountid = a.Id);
        toInsert.add(toTest);
        toInsert.add(test2);
        Test.startTest();
        List<Database.SaveResult> sr = Database.insert(toInsert);
        Test.stopTest();
        for(Database.SaveResult s: sr){
            Assert.areEqual(!s.isSuccess(), false);
        }
        
    }

}