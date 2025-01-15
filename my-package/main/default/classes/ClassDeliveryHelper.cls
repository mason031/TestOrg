public without sharing class ClassDeliveryHelper {
    public ClassDeliveryHelper() {

    }
    
    public static Class_Delivery__c createClassDelivery(String course){
        Class_Delivery__c cd = new Class_Delivery__c(Course__c = course);
        if(Schema.SObjectType.Class_Delivery__c.isCreateable()){
            insert cd;
            return cd;
        }
        else{
            cd.addError('You need proper permissions');
            return null;
        }
    }

    public static void deleteClassDelivery(Id deliveryId){
        //List<Class_Delivery__c> cd = [SELECT Id FROM Class_Delivery__c WHERE Id = :deliveryId  LIMIT 1];
       
        if(Schema.SObjectType.Class_Delivery__c.isDeletable()){
            Database.delete(deliveryId);
        }
        /*
        else{
            //cd[0].addError('You need proper permissions to delete');
            
        }
       */
    }

    public static void changeCourse(Id deliveryId, String course){
        Class_Delivery__c cd = [SELECT Id, Course__c FROM Class_Delivery__c WHERE Id = :deliveryId];
        cd.Course__c = course;
        if(Schema.SObjectType.Class_Delivery__c.fields.Course__c.isUpdateable()){
            update cd;

        }
        else{
            cd.addError('You need proper permissions to update');
        }
    }
}