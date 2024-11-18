// HomeUI

class HomeUI {
	private PImage bg_img;
	
	public Button startButton;
	public Button forgeButton;
	public Button characterButton;
	public Button settingsButton;
	
	public UiImage characterImage;
	public UiImage featureUnavailableText;
	
	private double hideUnavailableTextAfter = 0;

	public boolean shouldStartGame = false;
	
	public HomeUI() {
		// initiate the ui
		bg_img = loadImage("assets/images/homeui_background_image.png");
		
		// load the buttons
		startButton = new Button(30, 30, 600, 200, "assets/images/homeui_start_button.png", "assets/images/homeui_start_button_hover.png");
		forgeButton = new Button(30, 260, 260, 430, "assets/images/homeui_forge_button.png", "assets/images/homeui_forge_button_hover.png");
		characterButton = new Button(320, 260, 310, 200, "assets/images/homeui_character_button.png", "assets/images/homeui_character_button_hover.png");
		settingsButton = new Button(320, 490, 310, 200, "assets/images/homeui_settings_button.png", "assets/images/homeui_settings_button_hover.png");
		
		characterImage = new UiImage(640, 30, 629, 716, "assets/images/homeui_character_default_idle.png");
		featureUnavailableText = new UiImage(990, 20, 216, 93, "assets/images/homeui_feature_unavailable.png");
	}
	
	public void display() {
		this.update();
	}
	
	public void update() {
		background(bg_img);
		// update elements
		startButton.update();
		forgeButton.update();
		characterButton.update();
		settingsButton.update();
		
		characterImage.update();
		
		if (millis() < hideUnavailableTextAfter) {	// show text for a period of time
			featureUnavailableText.update();
		}
	}
	
	public void onMouseClick() {
		if (startButton.isHovering()) {	// clicking start
			println("Should Start Game!");
			shouldStartGame = true;
		} else if (forgeButton.isHovering()) {	// clicking forge
			hideUnavailableTextAfter = millis() + 3000f;	// show text for 5 sec
			println("[HomeUI] Unimplemented option clicked");
		} else if (characterButton.isHovering()) {	// clicking characters
			hideUnavailableTextAfter = millis() + 3000f;	// show text for 5 sec
			println("[HomeUI] Unimplemented option clicked");
		} else if (settingsButton.isHovering()) {	// clicking settings
			hideUnavailableTextAfter = millis() + 3000f;	// show text for 5 sec
			println("[HomeUI] Unimplemented option clicked");
		}
	}
}

// button element
class Button {
	private PImage regImage;
	private PImage hoverImage;
	
	private int posX;
	private int posY;
	private int sizeX;
	private int sizeY;
	
	private int[2] clickableRangeX = new int[2];	// clickable range x1 x2
	private int[2] clickableRangeY = new int[2];	// clickable range y1 y2
	
	//private boolean isMouseHovering = false;
	
	public Button(int posXInp, int posYInp, int sizeXInp, int sizeYInp, String regularImagePath, String hoverImagePath) {
		posX = posXInp;
		posY = posYInp;
		sizeX = sizeXInp;
		sizeY = sizeYInp;
		
		// load images
		regImage = loadImage(regularImagePath);
		hoverImage = loadImage(hoverImagePath);
		
		// find clickable area
		clickableRangeX[0] = posX;
		clickableRangeY[0] = posY;
		clickableRangeX[1] = posX + sizeX;
		clickableRangeY[1] = posY + sizeY;
	}
	
	public void update() {
		if (isHovering()) {
			image(hoverImage, posX, posY, sizeX, sizeY);
		} else {
			image(regImage, posX, posY, sizeX, sizeY);
		}
	}

	// check if mouse is hovering this button
	public boolean isHovering() {
		if ((mouseX >= clickableRangeX[0] && mouseX <= clickableRangeX[1]) && (mouseY >= clickableRangeY[0] && mouseY <= clickableRangeY[1])) {
			return true;
		}
		return false;
	}
}

// UI image element
class UiImage {
	private PImage uiImage;
	
	private int posX;
	private int posY;
	private int sizeX;
	private int sizeY;
	
	public UiImage(int posXInp, int posYInp, int sizeXInp, int sizeYInp, String imagePath) {
		posX = posXInp;
		posY = posYInp;
		sizeX = sizeXInp;
		sizeY = sizeYInp;
		
		// load images
		uiImage = loadImage(imagePath);
	}
	
	public void update() {
		image(uiImage, posX, posY, sizeX, sizeY);
	}
}