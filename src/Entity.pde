// Entity base class
// any object that moves, have health, and can collide should inherit from this class

class Entity extends Sprite {
    protected double speed;
    
    protected double health; // default: set to maxHealth on spawn
    protected double maxHealth;

    protected double damageReduction; // default: 0
    protected int takeDamageCooldown; // default: 100 ms
    protected int takeDamageCooldownTimer;    // ms
    
    protected double damage;
    protected double damageMultiplier;   // default: 1
    protected int attackCooldown; // default: 100 ms
    protected int attackCooldownTimer;    // ms

    protected double collisionDetectionDistance;  // default: auto calculate based on size
    protected boolean isCollidable;   // default: true

    protected boolean toBeDiscarded = false;
    
    // constructor
    public Entity(
        double initPosX, double initPosY,
        int initSizeX, int initSizeY,
        double initRotation,
        String imagePath,
        double initSpeed,
        double initMaxHealth,
        double initDamage
    ) {
        super(initPosX, initPosY, initSizeX, initSizeY, initRotation, imagePath);
        
        speed = initSpeed;

        maxHealth = initMaxHealth;
        health = maxHealth;

        damageReduction = 0;
        takeDamageCooldown = 100;
        takeDamageCooldownTimer = 0;

        damage = initDamage;
        damageMultiplier = 1;
        attackCooldown = 100;
        attackCooldownTimer = 0;

        // assume it is a square ( (avg of width and height) / 2 = radius )
        collisionDetectionDistance = (initSizeX + initSizeY) / 4;

        isCollidable = true;
    }
    
    // move the entity (with speed applied)
    public void move(double deltaX, double deltaY, boolean isSafe) {
        sTranslate(deltaX*speed, deltaY*speed, isSafe);
    }

    // overload: move the entity (auto-safe)
    public void move(double deltaX, double deltaY) {
        move(deltaX*speed, deltaY*speed, true);
    }

    // take damage: check cd and reduction -> real damage taken
    public double takeDamage(double damage) {
        double realDamageTaken = 0;
        
        if (millis() > takeDamageCooldownTimer) {
            takeDamageCooldownTimer = millis() + takeDamageCooldown;

            double hpBefore = health;
            health -= damage * (1-damageReduction);

            realDamageTaken = hpBefore-health;

            if (health <= 0) {
                health = 0;
            }
        }
        return realDamageTaken;
    }

    // preAttack: approve and calc real dmg from multipliers -> real damage
    public double preAttack() {
        double realDamage = 0;
        if (millis() > attackCooldownTimer) {
            attackCooldownTimer = millis() + attackCooldown;
            
            realDamage = damage * damageMultiplier;
        }
        return realDamage;
    }

    // check collision with another entity
    public boolean checkCollision(Entity otherEntity) {
        if (isCollidable && otherEntity.isCollidable()) {
            double distance = dist(
                (float)transform.x, (float)transform.y,
                (float)otherEntity.getTransform().x, (float)otherEntity.getTransform().y
            );
            return distance < (collisionDetectionDistance + otherEntity.getCollisionDetectionDistance());
        }
        return false;
    }

    // update size
    public void eResize(int newSizeX, int newSizeY) {
        transform.w = newSizeX;
        transform.h = newSizeY;
        collisionDetectionDistance = (newSizeX + newSizeY) / 4;
    }

    // is out of bounds
    public boolean isOutOfBounds() {
        return transform.x < 0 || transform.x > width || transform.y < 0 || transform.y > height;
    }

    // if is alive
    public boolean isAlive() {return health > 0;}

    // get collision detection distance
    public double getCollisionDetectionDistance() {return collisionDetectionDistance;}
    
    // get is collidable
    public boolean isCollidable() {return isCollidable;}

    // get / set to be discarded
    public boolean shouldDiscard() {return toBeDiscarded;}
    public void discard() {toBeDiscarded = true;}
}