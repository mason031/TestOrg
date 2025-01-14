public with sharing class Car extends Vehicle{
    public Car() {
        this(0,0,0,'Placeholder');
    }
    public Car(Integer speed, Integer Occupants, Integer Capacity, String Name){
        super(speed, Occupants, Capacity, Name);
        this.TireRotation = 0;
        this.SteeringRotation = 0;
        this.Media.add(Medium.LAND);
    }
    private Integer SteeringRotation{
        get{
            if (this.SteeringRotation>=-1440 && this.SteeringRotation <=1440){
                return this.SteeringRotation;
            }
            else{
                throw new IllegalArgumentException('Steering rotation must be between -1440 and 1440');
            }
        }
        set{
            if (value>=-1440 && value <=1440){
                this.SteeringRotation = value;
            }
            else{
                throw new IllegalArgumentException('Steering rotation must be between -1440 and 1440');
            }
        }
    }

    public Integer TireRotation{
        
        get{
            if (this.TireRotation>=-90 && this.TireRotation <=90){
                return this.TireRotation;
            }
            else{
                throw new IllegalArgumentException('Steering rotation must be between -1440 and 1440');
            }
        }
        private set{
            if (value>=90 && value <=90){
                this.TireRotation = value;
            }
            else{
                throw new IllegalArgumentException('Steering rotation must be between -1440 and 1440');
            }
        }
    }

    public Integer Gear{
        get{
            return this.Gear;
        }
        private set{
            this.Gear = value;
        }
    }

    public override void Turn(Integer degrees){
        this.SteeringRotation = this.SteeringRotation+degrees;
        this.TireRotation = this.SteeringRotation + degrees/16;
    }

    public override void Accelerate(Integer value){
        super.Accelerate(value); 
        this.Gear = (Integer)Math.ceil(0.4444 * (Math.sqrt(this.speed)));
    }


    
}