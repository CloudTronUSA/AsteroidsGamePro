// asteroid class inherits from Entity class

class Asteroid extends Entity {
    protected double rotationPerTick; 
    protected double direction;

    private int damageTakenFlashLength;
    private int damageTakenFlashTimer;

	public Asteroid() {
        super(
            0, 0, // pos
            0, 0, // size
            0,  // rotation
            "assets/images/game_asteroid_a.png", // image path
            0,  // speed
            0,    // max health
            0  // damage
        );

        // define the base information
        int baseSizeX = 100;
        int baseSizeY = 76;
        int baseHP = 100;
        int baseDamage = 10;
        double baseSpeed = 1.5;
		
        // initialize the asteroid
        int initPosX = 0;
        int initPosY = 0;

		int spawnOption = (int) random(0, 4);
        // switch does not work for pjs for some reason
        if (spawnOption == 0) {
			initPosX = (int) random(1,width);
			initPosY = 1;
        } else if (spawnOption == 1) {
			initPosX = (int) random(1,width);
			initPosY = height - 1;
        } else if (spawnOption == 2) {
            initPosX = 1;
			initPosY = (int) random(1,height);
        } else {
            initPosX = width - 1;
			initPosY = (int) random(1,height);
		}

        transform.x = initPosX;
        transform.y = initPosY;
		
		// randomly scale the sprite (size, hp, damage, speed)
		double scale = random(0.7, 2);

		int initSizeX = (int) (baseSizeX * scale);
		int initSizeY = (int) (baseSizeY * scale);
        eResize(initSizeX, initSizeY);
				
		maxHealth = ( (int)(baseHP * scale) );
        health = maxHealth;
		damage = ((int) (baseDamage * scale));
        speed = ((baseSpeed * random(0.8, 1.2)));

        // set the asteroid's rotation and direction
        rotationPerTick = random(-1, 1);    // this is the rotation of the sprite
        direction = random(0, 360);  // this is the direction of the movement
	
        attackCooldown = 0;
        damageTakenFlashLength = 50;
        damageTakenFlashTimer = 0;
    }
		
	private double[] getNewMovement() {
		double newRotation = (transform.rotation + rotationPerTick ) % 360;
        direction = (direction + random(-3, 3)) % 360;
				
		double movementPerTickX = sin(radians((float)direction));
		double movementPerTickY = -1 * cos(radians((float)direction));

        return new double[] {movementPerTickX, movementPerTickY, newRotation};
	}
	
    // custom takeDamage method
	public double takeDamage(double damage) {
		double realDamageTaken = super.takeDamage(damage);
		
		if (realDamageTaken <= 0)
			return realDamageTaken;
		
        damageTakenFlashTimer = millis() + damageTakenFlashLength;

        // calc the new scale based how much the hp changed
        double scale = 1 - (realDamageTaken / maxHealth);

        if (transform.w * scale < 100) {
            return realDamageTaken; // don't scale down too much
        }

		eResize( (int)(transform.w * scale), (int)(transform.h * scale) );
        return realDamageTaken;
	}

    // custom draw
    public void draw() {
        double transparency = (155 * (health / maxHealth)) + 100; // 100-255

        // set transparency based on hp
        if (millis() < damageTakenFlashTimer)
			tint(255, (int)(transparency/2));
		else
            tint(255, (int)transparency);

        super.draw();
        noTint();
    }
	
	public void update() {
		double[] movement = getNewMovement();
		move(movement[0], movement[1]);
        transform.rotation = movement[2];
		
		this.draw();
	}

    // setters
    public void setDirection(double newDirection) {direction = newDirection;}
    public void setSpeed(double newSpeed) {speed = newSpeed;}
}

// special asteroid class inherits from Asteroid class
// this asteroid will only spawn from the top and move downwards
class SpecialAsteroid extends Asteroid {
    public SpecialAsteroid() {
        super();

        // set the asteroid to be spawned from the top
        transform.x = random(1, width);
        transform.y = 1;

        speed *= 1.4; // double the speed
        maxHealth *= 0.5; // reduce the health
        health = maxHealth;

        direction = random(160, 200);  // this is the direction of the movement
    }

    // override the new movement method (does not change direction)
    private double[] getNewMovement() {
        double newRotation = (transform.rotation + rotationPerTick ) % 360;
                
        double movementPerTickX = sin(radians((float)direction));
        double movementPerTickY = -1 * cos(radians((float)direction));

        return new double[] {movementPerTickX, movementPerTickY, newRotation};
    }

    // override the update method
    public void update() {
        double[] movement = getNewMovement();
		move(movement[0], movement[1]);
        transform.rotation = movement[2];

        // check if the asteroid is out of bounds
        if (isOutOfBounds()) {
            discard();
        } else {
            this.draw();
        }
    }
}