// Sprite base class
// any object that needs to be drawn on screen should inherit from this class

class Sprite {
	// transform
	protected Transform transform;
	
	protected boolean enabled = true;
	
	private PImage spriteImage;
	
	public Sprite(double initPosX, double initPosY, int initSizeX, int initSizeY, double initRotation, String imagePath) {
		transform = new Transform();
        transform.x = initPosX;
        transform.y = initPosY;
        transform.w = initSizeX;
        transform.h = initSizeY;
        transform.rotation = initRotation;
		
		spriteImage = loadImage(imagePath);
	}
	
	protected void draw() {				
		if (enabled) {
			pushMatrix();
			translate((float)transform.x, (float)transform.y);	// move whole sketch to target pos
			rotate(radians((float)transform.rotation));	// rotate at that pos
			image(spriteImage, -1*(transform.w/2), -1*(transform.h/2), transform.w, transform.h);	// apply offset
			popMatrix();
		}
	}

    public void update() {
        draw();
    }

    // rotate the sprite
    public void sRotate(double newRotation) {
        transform.rotation += newRotation;
    }

    // translate the sprite
	public void sTranslate(double newX, double newY, boolean safeTranslate) {	// safeTransform: if to teleport back when reached border
		transform.x += newX;
		transform.y += newY;
		
		if (safeTranslate) {
			if (transform.x > width)	// limit X axis
				transform.x = 0;
			if (transform.x < 0)
				transform.x = width;
			if (transform.y > height)	// limit Y axis
				transform.y = 0;
			if (transform.y < 0)
				transform.y = height;
		}
	}

    public Transform getTransform() {
        return transform;
    }

    public void setTransform(Transform newTransform) {
        transform = newTransform;
    }
}

class Transform {
    public double x;
    public double y;
    public int w;
    public int h;
    public double rotation;
}