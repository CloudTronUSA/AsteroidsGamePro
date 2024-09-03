// Game

// preload image assets
/* @pjs preload="/data/game_player_spaceship.png"; */

class Game {
	public Player player;
	
	public Game() {
		player = new Player(500f, 500f, 96, 96, "/data/game_player_spaceship.png");
	}

	public void update() {
		background(255);
		player.updatePlayer();
	}
}