// floater base class

class Floater {
	// transform
	public float posX;	// X of center point
	public float posY;	// Y of center point
	public int sizeX;
	public int sizeY;
	
	public float rotation;
	public float direction;
	
	public boolean enabled = true;
	
	public PImage spriteImage;
	
	public Floater(float posXInp, float posYInp, int sizeXInp, int sizeYInp, float directionInp, float rotationInp, String imagePath) {
		posX = posXInp;
		posY = posYInp;
		sizeX = sizeXInp;
		sizeY = sizeYInp;

		direction = directionInp;
		rotation = rotationInp;
		
		spriteImage = loadImage(imagePath);
	}

	public Floater(float posXInp, float posYInp, int sizeXInp, int sizeYInp, String imagePath)	{	// overload
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
}