public with sharing abstract class Vehicle {
    public Vehicle() {
        this(0,0,0,'Placeholder');
        
    }
    public Vehicle(Integer speed, Integer Occupants, Integer Capacity, String Name){
        setSpeed(speed);
        this.Occupants = Occupants;
        this.Capacity = Capacity;
        this.Name = Name;
    }

    public enum Medium {LAND, AIR, WATER}

    public Integer speed;

    public Integer getSpeed(){
        if(this.speed >= 0){
            return this.speed;
        }
        else{
            throw new IllegalArgumentException('speed is negative');
        }
    }

    private void setSpeed(Integer value){
        if(value >= 0){
            this.speed = value;
        }
        else{
            throw new IllegalArgumentException('speed is negative');
        }
    }

   

    public String Name{
        get{
            return this.Name;
        }
        private set{
            this.Name = value;
        }
    }
    public Integer Occupants{
        get {
            if(this.Occupants >= 0){
                return this.Occupants;
            }
            else{
                throw new IllegalArgumentException('occupants is negative');
            }
        }
        set{
            if(value >= 0){
                this.Occupants = value;
            }
            else{
                throw new IllegalArgumentException('occupants is negative');
            }
        }
    }

    public Integer Capacity{
        get {
            if(this.Capacity > 1){
                return this.Capacity;
            }
            else{
                throw new IllegalArgumentException('Capacity is negative');
            }
        }
        private set{
            if(value > 1){
                this.Capacity = value;
            }
            else{
                throw new IllegalArgumentException('Capacity is negative');
            }
        }
    }

    protected List<Medium> Media {get;set;}

    public virtual void Accelerate(Integer value){
        setSpeed(getSpeed()+value);
    }

    public abstract void Turn(Integer degrees);

    public void PrintInfo(){
        System.debug('Speed: ' + getSpeed() + 'Name: ' + this.Name + 'Number of Occupants: ' + this.Occupants + 'Media: ' + this.Media);
    }






}