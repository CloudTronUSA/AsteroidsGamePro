/* @pjs preload="data/homeui_background_image.png"; */
/* @pjs preload="data/homeui_character_button.png"; */
/* @pjs preload="data/homeui_character_button_hover.png"; */
/* @pjs preload="data/homeui_character_default_idle.png"; */
/* @pjs preload="data/homeui_forge_button.png"; */
/* @pjs preload="data/homeui_forge_button_hover.png"; */
/* @pjs preload="data/homeui_settings_button.png"; */
/* @pjs preload="data/homeui_settings_button_hover.png"; */
/* @pjs preload="data/homeui_start_button.png"; */
/* @pjs preload="data/homeui_start_button_hover.png"; */

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

