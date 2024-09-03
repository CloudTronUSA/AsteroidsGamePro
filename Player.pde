// player class extending from floater

class Player extends Floater {
	public Player(float posXInp, float posYInp, int sizeXInp, int sizeYInp, String imagePath) {
		super(posXInp, posYInp, sizeXInp, sizeYInp, imagePath);
	}
	
	public float getRelativeAngleToMouse() {
  	float deltaX = mouseX - super.posX;
  	float deltaY = mouseY - super.posY;
  
  	// using atan2 function and convert to degrees
  	float angle = atan2(deltaY, deltaX) * (180 / PI);
		angle += 90;
		
		return angle;
	}
	
	public void accelerate() {
	}
	
	public void updatePlayer() {
		// always face mouse
		super.rotation = this.getRelativeAngleToMouse();
		super.update();
		println(this.getRelativeAngleToMouse());
	}
} 