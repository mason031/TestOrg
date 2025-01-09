public with sharing class Calculator {
    public Calculator() {

    }
    public Integer Calculate(String s){
        List<String> chars = s.split('(?<=\\d)(?=\\D)|(?<=\\D)(?=\\d)|(?<=\\W)(?=\\w)|(?<=\\w)(?=\\W)|(?=[()])|(?<=[()])');
        List<String> RPNExpression = new List<String>();
        List<String> Operators = new List<String>();
        String LastOperator = '';
        for(Integer i = 0; i < chars.size();i++){
            /*
            if (chars[i] == ' '){
                continue;
            }
            */
            if (chars[i].isNumeric()){
                
                RPNExpression.add(chars[i]);
            }
            else{
                //System.debug('operators'+Operators);
                if(chars[i].contains('+') || chars[i].contains('-')){
                    
                    while(Operators.size()>0 &&  (Operators[Operators.size()-1].contains('+')
                          ||Operators[Operators.size()-1].contains('-')
                          ||Operators[Operators.size()-1].contains('/')
                          ||Operators[Operators.size()-1].contains('*'))){
                        //System.debug('Popping from operators onto expression stack');
                        String popped = Operators.remove(Operators.size()-1);
                        //System.debug(popped);
                        RPNExpression.add(popped);
                    }
                    Operators.add(chars[i]);
                    //LastOperator = 'Add/Sub';
                }
                else if(chars[i].contains('*') || chars[i].contains('/')){
                    while(Operators.size()>0 
                          && (Operators[Operators.size()-1].contains('*')
                          ||Operators[Operators.size()-1].contains('/')
                          ))
                    {
                        String popped = Operators.remove(Operators.size()-1);
                        
                        RPNExpression.add(popped);
                    }
                    Operators.add(chars[i]);
                    //LastOperator = 'Mult/Div';
                }
                else{
                    if(chars[i].contains('(')){
                        Operators.add(chars[i]);
                        //LastOperator = '(';
                    }
                    else if(chars[i].contains(')')){
                        //String popped =  Operators.remove(Operators.size()-1);
                        String popped = '';
                        while(Operators.size()>0 && !popped.contains('(')){
                            popped = Operators.remove(Operators.size()-1);
                            if(popped.contains('(')){
                                break;
                            }
                            RPNExpression.add(popped);
                        }
                    }

                }


                }
            }
            for(Integer i = Operators.size()-1; i >=0;i--){
                RPNExpression.add(Operators[i]);
            }
            System.debug('Your Reverse Polish Notation Expression'+RPNExpression);
        	System.debug('Operator Stack'+Operators);
        Integer ans = CalculateRPN(RPNExpression);
        System.debug(ans);
        return ans;
    }
        
    private Integer CalculateRPN(List<String> RPN){
        Integer num1;
        Integer num2;
        List<Integer> Stack = new List<Integer>();
        for(String val: RPN){
            if(val.isNumeric()){
                Stack.add(Integer.valueOf(val));
            }
            else{
                if(val.contains('+')){
                    num2 = Stack.remove(Stack.size()-1);
                    num1 = Stack.remove(Stack.size()-1);
                    Integer sum = num1+num2;
                    Stack.add(sum);
                }
                if(val.contains('-')){
                    num2 = Stack.remove(Stack.size()-1);
                    num1 = Stack.remove(Stack.size()-1);
                    Integer difference = num1-num2;
                    Stack.add(difference);
                }
                if(val.contains('*')){
                    num2 = Stack.remove(Stack.size()-1);
                    num1 = Stack.remove(Stack.size()-1);
                    Integer product = num1*num2;
                    Stack.add(product);
                }
                if(val.contains('/')){
                    num2 = Stack.remove(Stack.size()-1);
                    num1 = Stack.remove(Stack.size()-1);
                    Integer dividend = num1/num2;
                    Stack.add(dividend);
                }
            }
        }
        return Stack[0];
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