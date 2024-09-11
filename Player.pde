// player class extending from floater

class Player extends Floater {
	public double speed = 8;
	public double damage = 8;
	
	public Player(double posXInp, double posYInp, int sizeXInp, int sizeYInp, String imagePath) {
		super(posXInp, posYInp, sizeXInp, sizeYInp, imagePath);
	}
	
	public double getRelativeAngleToMouse() {
  	double deltaX = mouseX - super.posX;
  	double deltaY = mouseY - super.posY;
  
  	// using atan2 function and convert to degrees
  	double angle = atan2(deltaY, deltaX) * (180 / PI);
		angle += 90;
		
		return angle;
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
		
		super.update();
	}
} 