// Main Class
HomeUI homeUi;
Game game;
int gameState = 0;	// 0 = ui, 1 = play

public void setup(){
  size(1280, 720);
  
	homeui = new HomeUI();
	game = new Game();
	
	homeui.display();	// display home ui
}

public void draw(){
	if (homeui.shouldStartGame)
		gameState = 1;
	
	switch (gameState) {
		case 0:
			homeui.update();
			break;
		case 1:
			game.update();
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

