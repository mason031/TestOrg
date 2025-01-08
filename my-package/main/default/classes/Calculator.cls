public with sharing class Calculator {
    public Calculator() {

    }
    
    public Integer Add(Integer num, Integer num2){
        return num + num2;
    }

    public Integer Multiply(Integer num, Integer num2){
        Integer sum = 0;
        for(Integer i = 0; i < num; i++){
            sum = Add(sum, num2);
        }
            return sum;
    }
    public Integer Divide(Integer num, Integer num2){
        if (num2==0){
            return 0;
        }
        Integer count = 0;
        Integer left = num;
        while(num>=num2){
            num = Add(num, -num2);
            count += 1;
        }
        return count;
    }
    public Integer Mod(Integer num, Integer num2){
        if (num2==0){
            return 0;
        }
        Integer count = 0;
        Integer left = num;
        while(num>num2){
            num = Add(num, -num2);
            count += 1;
                
        }
        return num;
    }
    
}