class Asteroid extends Floater {
	public double speed = 2;
	public double collisionDetectionDistance;
	public double hp = 16;

	private double movementPerTickX;
	private double movementPerTickY;

	private int spinDirection;

	public double dmgCooldown = 100;	// how long the cooldown will be 
	private double dmgCooldownUntil = 0;

	public bool isDead = false;
	private double hpMax = hp;

	public Asteroid() {
		super(0, 0, 100, 76, 0, 0, "data/game_asteroid_a.png");
		
		switch ((int)random(3)) {
			case 0:
				println("AST Spawn at top");
				super.posX = random(1,width);
				super.posY = 1;
			case 1:
				println("AST Spawn at bottom");
				super.posX = random(1,width);
				super.posY = height - 1;
			case 2:
				println("AST Spawn at left");
				super.posY = random(1,height);
				super.posX = 1;
			case 3:
				println("AST Spawn at right");
				super.posY = random(1,height);
				super.posX = width - 1;
		}
				
		spinDirection = random(-3,3);
		super.direction = random(0,360);
		
		// randomly size the sprite
		double scale = random(0.7, 2);
		super.sizeX = super.sizeX * scale;
		super.sizeY = super.sizeY * scale;
				
		hp = hp * scale;
				
		collisionDetectionDistance = (super.sizeX+super.sizeY) / 4	// half of the size (Radius)
	}
		
	private void assignNewDirection() {
		super.direction = (super.direction + random(-5,5) ) % 360;
		super.rotation = (super.rotation + spinDirection ) % 360;
				
		movementPerTickX = speed * sin(radians(super.direction));
		movementPerTickY = -speed * cos(radians(super.direction));
	}
		
	public void takeDamage(double damage) {
		if (millis() > dmgCooldownUntil) {
			dmgCooldownUntil = millis() + dmgCooldown;
			hp -= damage;
			println("DAMAGE Taken!");
			if (hp <= 0)
				isDead = true;
		}
	}
	
	public void updateAsteroid() {
		this.assignNewDirection();
		super.fTranslate(movementPerTickX, movementPerTickY, true);
		
		double transparency = (155 * (hp/hpMax)) + 100;
		tint(255, (int)transparency);	// set transparency based on hp
		
		if (millis() < dmgCooldownUntil) {
			tint(255, (int)(transparency/2));
			println("TINT!");
		}
		super.update();
		noTint();
	}
}