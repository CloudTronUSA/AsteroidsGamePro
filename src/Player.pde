// player class extending from entity class
// handles player specific attributes and methods

final class Player extends Entity {
	private double energy;
    private double maxEnergy;

    private double hpRegenRate;
	private double energyRechargeRate;
    private double ultAttackCost;
    private double ultAttackMultiplier;
    private double ultAttackRange;

    private int ultAtkCooldown;
    private int ultAttackCooldownTimer; // ms

    private int abilityCost;
    private int abilityCooldown; // ms
    private int abilityCooldownTimer; // ms

    private int damageTakenFlashLength;
    private int damageTakenFlashTimer;

    private boolean rotationLock;   // lock rotation to mouse
    private boolean xMovementLock;  // lock movement in x-axis
    private boolean yMovementLock;  // lock movement in y-axis
	
	public Player(double initPosX, double initPosY) {
		super(
            initPosX, initPosY, // pos
            96, 96, // size
            0,  // rotation
            "assets/images/game_player_spaceship.png", // image path
            3.2,  // speed
            1000,    // max health
            20  // damage
        );

        maxEnergy = 100;    // default: 100
        energy = maxEnergy;
        energyRechargeRate = 1; // default: 1 energy per tick
        hpRegenRate = 0.1;  // default: 0.5 hp per tick

        ultAttackCost = 100; // default: 50 energy
        ultAttackMultiplier = 5; // default: 5x damage
        ultAttackRange = 400; // default: 400
        ultAtkCooldown = 1000;  // default: 1000 ms
        ultAttackCooldownTimer = 0;

        damageTakenFlashLength = 80;
        damageTakenFlashTimer = 0;

        takeDamageCooldown = 200;   // increase the cooldown for player

        abilityCost = 50; // default: 50 energy
        abilityCooldown = 1000; // default: 1000 ms
        abilityCooldownTimer = 0;
    }
	
    // get the angle between player and mouse
	private double getRelativeAngleToMouse() {
        double deltaX = mouseX - transform.x;
        double deltaY = mouseY - transform.y;
    
        // using atan2 function and convert to degrees
        double angle = atan2((float)deltaY, (float)deltaX) * (180 / PI);
		angle += 90;

        if (rotationLock) {
            // cap the angle to upwards only
            angle = 0;
        }
		
		return angle;
	}

    // ability
    public void hyperspaceAbility() {
        if (energy >= abilityCost && millis() > abilityCooldownTimer) {
            energy -= abilityCost;
            abilityCooldownTimer = millis() + abilityCooldown;
            // teleport to a random location
            transform.x = random(0, width);
            transform.y = random(0, height);
            takeDamageCooldownTimer = millis() + 1000; // invulnerable for 1s
        }
    }

    // expect a list of entities to check for collision
	public double ultAttack(ArrayList<Entity> entities) {
        double totalDamageDealt = 0;
        if (energy >= ultAttackCost && millis() > ultAttackCooldownTimer) {
            energy -= ultAttackCost;
            ultAttackCooldownTimer = millis() + ultAtkCooldown;
            
            // do ult attack
            double thisAtkDamage = damage * ultAttackMultiplier;
            
            // check each entity to see if it is within range
            for (int i=0; i<entities.size(); i++) {
                Entity entity = entities.get(i);
                double distance = dist(
                    (float)transform.x, (float)transform.y,
                    (float)entity.getTransform().x, (float)entity.getTransform().y
                );
                if (distance <= ultAttackRange) {
                    totalDamageDealt += entity.takeDamage(thisAtkDamage);
                }
            }
        }
        return totalDamageDealt;
    }

    // modified attack for player (launch a bullet)
    public boolean attack(ArrayList<Bullet> bullets) {
        if (millis() > attackCooldownTimer) {
            attackCooldownTimer = millis() + attackCooldown;
            // create a bullet
            bullets.add(new Bullet(this));
        }
    }

    // modified takeDamage for player
    public double takeDamage(double damage) {
        double dmgTaken = super.takeDamage(damage);
        if (dmgTaken > 0) {
            damageTakenFlashTimer = millis() + damageTakenFlashLength;
        }
        return dmgTaken;
    }

    protected void draw() {
        if (millis() < damageTakenFlashTimer) {
			tint(255, 180, 180);
		}
		super.draw();
		noTint();
    }
	
	public void update(double inputXAxis, double inputYAxis) {
		// direction control: Mode1: always face mouse
		transform.rotation = this.getRelativeAngleToMouse();
		
		// direction control: Mode2: from control
		//if (inputXAxis != 0 || inputYAxis != 0) {
		//	double angleTheta = atan2(inputXAxis, inputYAxis) * (180 / PI);
		//	transform.rotation = (angleTheta) % 360;
		//}
		
		// move towards mouse
		// double vectorDirX = mouseX - posX;
		// double vectorDirY = mouseY - posY;
		// double vectorDirM = sqrt(vectorDirX*vectorDirX + vectorDirY*vectorDirY);	// normalize
		// vectorDirX = vectorDirX / vectorDirM;
		// vectorDirY = vectorDirY / vectorDirM;
		// move(vectorDirX*inputYAxis, vectorDirY*inputYAxis);
		
		// move by key
        if (xMovementLock) {
            inputXAxis = 0;
        }
        if (yMovementLock) {
            inputYAxis = 0;
        }

		move(inputXAxis, inputYAxis*-1);
		
        // energy recharge
		if (energy + energyRechargeRate <= maxEnergy)
			energy += energyRechargeRate;

        // hp regen
        if (health > 0 && health + hpRegenRate <= maxHealth)    // only regen if not dead
            health += hpRegenRate;

        // draw player
        this.draw();
	}

    // getter methods
    public double getEnergy() {return energy;}
    public double getMaxEnergy() {return maxEnergy;}
    public double getDamage() {return damage;}
    public double getHealth() {return health;}
    public double getMaxHealth() {return maxHealth;}

    // setter methods
    public void setRotationLock(boolean lock) {rotationLock = lock;}
    public void setXMovementLock(boolean lock) {xMovementLock = lock;}
    public void setYMovementLock(boolean lock) {yMovementLock = lock;}
} 