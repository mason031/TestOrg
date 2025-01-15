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
private class ClassDeliveryHelper_Test {


    @TestSetup
    static void makeData(){
        Profile SalesTeam = [SELECT Id FROM Profile WHERE Name = 'Sales Team'];
        Profile StandardUser = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        User salesTeamMember = new User(
            Alias = 'jdoe123', 
            LastName = 'Doe',
            Username = 'jdoeSalesTeam@12345.com',
            ProfileId= SalesTeam.Id,
            LocaleSidKey='en_US',
            LanguageLocaleKey='en_US',
            email = 'asdfklj@sdflkwoi.com',
            EmailEncodingKey='UTF-8',
            TimeZoneSidKey='America/Los_Angeles');
        insert salesTeamMember;
        User nonSalesTeam = new User(
            Alias = 'jdoe12', 
            LastName = 'Doe',
            Username = 'jdoeStandard@12345.com',
            ProfileId= StandardUser.Id,
            LocaleSidKey='en_US',
            LanguageLocaleKey='en_US',
            email = 'asdfklj@sdflkwoi.com',
            EmailEncodingKey='UTF-8',
            TimeZoneSidKey='America/Los_Angeles');
        insert nonSalesTeam;
        User SalesTeamManager = new User(
            Alias = 'jdoe321', 
            LastName = 'Doe',
            Username = 'jdoeManager@12345.com',
            ProfileId= SalesTeam.Id,
            LocaleSidKey='en_US',
            LanguageLocaleKey='en_US',
            email = 'asdfklj@sdflkwoi.com',
            EmailEncodingKey='UTF-8',
            TimeZoneSidKey='America/Los_Angeles');
        insert SalesTeamManager;
        PermissionSet ps = [SELECT Id 
                FROM PermissionSet 
                WHERE Name = 'Sales_Team_Manager'];
        insert new PermissionSetAssignment(AssigneeId = SalesTeamManager.id, PermissionSetId = ps.Id);

    }
    @isTest
    public static void createDeliveryPositive() {
        // TO DO: implement unit test
        
        User salesTeamMember = [SELECT Id FROM User WHERE Username = 'jdoeSalesTeam@12345.com'];
        System.runAs(salesTeamMember){
            Class_Delivery__c cd= ClassDeliveryHelper.createClassDelivery('Salesforce');
            Class_Delivery__c cd2 = [SELECT Id FROM Class_Delivery__c WHERE Course__c = 'Salesforce'];
            Assert.areEqual(cd.Id, cd2.Id);
        }
        //Class_Delivery__c cd= ClassDeliveryHelper.createClassDelivery('Salesforce');
        //Class_Delivery__c cd2 = [SELECT Id FROM Class_Delivery__c WHERE Course__c = 'Salesforce'];
        
    }
    @isTest
    public static void createDeliveryNegative() {
        // TO DO: implement unit test
        //Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        
        User nonSalesTeam = [SELECT Id FROM User WHERE Username = 'jdoeStandard@12345.com']; 
        System.runAs(nonSalesTeam){
            Class_Delivery__c cd= ClassDeliveryHelper.createClassDelivery('Salesforce');
            //Class_Delivery__c cd2 = [SELECT Id FROM Class_Delivery__c WHERE Course__c = 'Salesforce'];
            Assert.areEqual(null, cd);
        }
        //Class_Delivery__c cd= ClassDeliveryHelper.createClassDelivery('Salesforce');
        //Class_Delivery__c cd2 = [SELECT Id FROM Class_Delivery__c WHERE Course__c = 'Salesforce'];
        
    }

    @isTest
    public static void deleteDeliveryPositive(){
        Test.startTest();
        User manager = [SELECT Id FROM User WHERE Username = 'jdoeManager@12345.com'];
        
        
  
        //Class_Delivery__c cd2 = [SELECT Id FROM Class_Delivery__c WHERE Id = :cd.Id];
        //System.debug(cd2);
        System.runAs(manager){
            Class_Delivery__c cd = ClassDeliveryHelper.createClassDelivery('Salesforce');
            ClassDeliveryHelper.deleteClassDelivery(cd.Id);
            List<Class_Delivery__c > cdCheck = [SELECT Id FROM Class_Delivery__c WHERE Id = :cd.Id LIMIT 1];

            Assert.areEqual(0, cdCheck.size());
            
        }   
    
        Test.stopTest();
    }

    @isTest
    public static void deleteDeliveryNegative(){
        User salesTeamMember = [SELECT Id FROM User WHERE Username = 'jdoeSalesTeam@12345.com'];
        
        System.runAs(salesTeamMember){
            Class_Delivery__c cd = ClassDeliveryHelper.createClassDelivery('Salesforce');
            ClassDeliveryHelper.deleteClassDelivery(cd.Id);
            Class_Delivery__c cdCheck = [SELECT Id FROM Class_Delivery__c WHERE Id = :cd.Id LIMIT 1];
            Assert.areEqual(cdCheck.Id, cd.Id);
        }   
    }

    @isTest
    public static void changeCoursePositive(){
        User salesTeamMember = [SELECT Id FROM User WHERE Username = 'jdoeSalesTeam@12345.com'];
        System.runAs(salesTeamMember){
            Class_Delivery__c cd = ClassDeliveryHelper.createClassDelivery('Salesforce');
            ClassDeliveryHelper.changeCourse(cd.Id, 'C#');
            
            Class_Delivery__c cdCheck = [SELECT Id, Course__c FROM Class_Delivery__c WHERE Id = :cd.Id LIMIT 1];
            Assert.areEqual('C#', cdCheck.Course__c);
        }
    }

    @isTest
    public static void changeCourseNegative(){
        User nonSalesTeam = [SELECT Id FROM User WHERE Username = 'jdoeStandard@12345.com'];
        System.runAs(nonSalesTeam){
            Class_Delivery__c cd = new Class_Delivery__c(Course__c = 'Salesforce');
            insert cd;

            ClassDeliveryHelper.changeCourse(cd.Id, 'C#');
            
            Class_Delivery__c cdCheck = [SELECT Id, Course__c FROM Class_Delivery__c WHERE Id = :cd.Id LIMIT 1];
            Assert.areEqual('Salesforce', cdCheck.Course__c);
        }
    }
    

    
}