// floater base class

class Floater {
	// transform
	public double posX;	// X of center point
	public double posY;	// Y of center point
	public int sizeX;
	public int sizeY;
	
	public double rotation;
	public double direction;
	
	public boolean enabled = true;
	
	public PImage spriteImage;
	
	public Floater(double posXInp, double posYInp, int sizeXInp, int sizeYInp, double directionInp, double rotationInp, String imagePath) {
		posX = posXInp;
		posY = posYInp;
		sizeX = sizeXInp;
		sizeY = sizeYInp;

		direction = directionInp;
		rotation = rotationInp;
		
		spriteImage = loadImage(imagePath);
	}

	public Floater(double posXInp, double posYInp, int sizeXInp, int sizeYInp, String imagePath)	{	// overload
		this(posXInp, posYInp, sizeXInp, sizeYInp, 0f,0f, imagePath);
	}
	
	public void update() {				
		if (enabled) {
			pushMatrix();
			translate(posX, posY);	// move whole sketch to target pos
			rotate(radians(rotation));	// rotate at that pos
			image(spriteImage, -1*(sizeX/2), -1*(sizeY/2), sizeX, sizeY);	// apply offset
			popMatrix();
		}
	}

	public void fTranslate(double inpX, double inpY, boolean safeTranslate) {	// safeTransform: if to teleport back when reached border
		posX += inpX;
		posY += inpY;
		
		if (safeTranslate) {
			if (posX > width)	// limit X axis
				posX = 0;
			if (posX < 0)
				posX = width;
			if (posY > height)	// limit Y axis
				posY = 0;
			if (posY < 0)
				posY = height;
		}
	}
}