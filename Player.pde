// player class extending from floater

class Player extends Floater {
	public double speed = 8;
	public double damage = 80;
	public double maxHp = 400;
	public double maxEnergy = 100;

	public double hp = maxHp;
	public double energy = maxEnergy;
	public boolean isDead = false;

	public double dmgCooldown = 200;	// how long the cooldown will be 
	private double dmgCooldownUntil = 0;

	public double atkCooldown = 100;	// how long the cooldown will be
	public double atkCooldownUntil = 0;

	public double energyRechargeRate = 0.1; // how much ER per frame
	public double ultAttackCost = 24; // how much energy the ult atk cost
	public double ultAtkCooldown = 500;	// how long the cooldown will be
	public double ultAtkCooldownUntil = 0;

	public double collisionDetectionDistance;
	
	public Player(double posXInp, double posYInp, int sizeXInp, int sizeYInp, String imagePath) {
		super(posXInp, posYInp, sizeXInp, sizeYInp, imagePath);
		
		collisionDetectionDistance = (super.sizeX+super.sizeY) / 4	// half of the size (Radius)
	}
	
	public double getRelativeAngleToMouse() {
  	double deltaX = mouseX - super.posX;
  	double deltaY = mouseY - super.posY;
  
  	// using atan2 function and convert to degrees
  	double angle = atan2(deltaY, deltaX) * (180 / PI);
		angle += 90;
		
		return angle;
	}

	public void takeDamage(double damage) {
		if (millis() > dmgCooldownUntil) {
			dmgCooldownUntil = millis() + dmgCooldown;
			
			hp -= damage;
			//println("PLAYER DAMAGE Taken!");
			if (hp <= 0) {
				hp = 0;
				isDead = true;
			}
		}
	}

	public void approveAttack() {
		if (millis() > atkCooldownUntil) {
			atkCooldownUntil = millis() + atkCooldown;
			return true;
		}
		return false;
	}

	public void approveUltAttack() {
		if (millis() > ultAtkCooldownUntil && energy - ultAttackCost >= 0) {
			ultAtkCooldownUntil = millis() + ultAtkCooldown;
			energy -= ultAttackCost;
			return true;
		}
		return false;
	}
	
	public void updatePlayer(double inputXAxis, double inputYAxis) {
		// direction control: Mode1: always face mouse
		super.rotation = this.getRelativeAngleToMouse();
		super.direction = this.getRelativeAngleToMouse();
		
		// direction control: Mode2: from control
		//if (inputXAxis != 0 || inputYAxis != 0) {
		//	double angleTheta = atan2(inputXAxis, inputYAxis) * (180 / PI);
		//	super.rotation = (angleTheta) % 360;
		//	super.direction = (angleTheta) % 360;
		//}
		
		// move towards mouse
		// double vectorDirX = mouseX - posX;
		// double vectorDirY = mouseY - posY;
		// double vectorDirM = sqrt(vectorDirX*vectorDirX + vectorDirY*vectorDirY);	// normalize
		// vectorDirX = vectorDirX / vectorDirM;
		// vectorDirY = vectorDirY / vectorDirM;
		//super.fTranslate(vectorDirX*speed*inputYAxis, vectorDirY*speed*inputYAxis, true);
		
		// move by key
		super.fTranslate(speed*inputXAxis, speed*inputYAxis*-1, true);
		
		if (energy + energyRechargeRate <= maxEnergy)
			energy += energyRechargeRate;
		
		if (millis() < dmgCooldownUntil) {
			tint(255, (int)(150));
			//println("Player TINT!");
		}
		super.update();
		noTint();
	}
} 