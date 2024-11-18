// preload ALL assets that are necessary to boot (must be in one line)
/* @pjs preload="assets/images/homeui_background_image.png"; font="assets/fonts/PixelifySans-Regular.ttf, assets/fonts/PixelifySans-Bold.ttf" */

// Main Class

HomeUI homeUi;
Game game;

int gameState = 0;	// 0 = ui, 1 = play
int targetFPS = 60;	// target fps

public void setup(){
  size(1280, 720);
	frameRate(targetFPS);
  
	homeui = new HomeUI();
	game = new Game();
	
	homeui.display();	// display home ui
}

public void draw(){
	if (homeui.shouldStartGame){
		gameState = 1;
		homeui.shouldStartGame = false;
	}
	
	if (game.isGameOver) {
		game = new Game();
		gameState = 0;
	}

	switch (gameState) {
		case 0:
			homeui.update();
			break;
		case 1:
			game.update();
			break;
		case 2:
			break;
	}
}

void mouseClicked() {
	switch (gameState) {
		case 0:
			homeui.onMouseClick();
			break;
		case 1:
			// in game, fire bullets
			break;
	}
}

void keyPressed() {
	switch (gameState) {
		case 0:
			// do nothing
			break;
		case 1:
			game.onKeyPressed();
			break;
	}
}

void keyReleased() {
	switch (gameState) {
		case 0:
			// do nothing
			break;
		case 1:
			game.onKeyReleased();
			break;
	}
}
