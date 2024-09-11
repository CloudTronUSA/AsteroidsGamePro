// Game

class Game {
	public Player player;
	public Input input;
	public ArrayList <Bullet> bullets = new ArrayList<Bullet>();
	public ArrayList <Asteroid> asteroids = new ArrayList<Asteroid>();
	
	public Game() {
		input = new Input();
		player = new Player(500f, 500f, 96, 96, "data/game_player_spaceship.png");
	}

	public void update() {
		background(0);
		player.updatePlayer(input.xAxis, input.yAxis);
		
		if (asteroids.size() < 5) {
			println("SPAWNING ASTEROIDS!!!");
			int generateCount = (int)random(1,5);
			for (int i=0; i<generateCount; i++) {
				asteroids.add(new Asteroid());
			}
		}
		
		for (int i=0; i<bullets.size(); i++) {
			bullets.get(i).updateBullet();
		}
		
		for (int i=0; i<asteroids.size(); i++) {
			asteroids.get(i).updateAsteroid();
		}
		
		// check for collision
		for (int i=0; i<bullets.size(); i++) {
			for (int j=0; j<asteroids.size(); j++) {
				// calc the distance btwn the bullet and asteroid
				double objDistance = dist(bullets.get(i).posX, bullets.get(i).posY, asteroids.get(j).posX, asteroids.get(j).posY);
				if (objDistance <= asteroids.get(j).collisionDetectionDistance) {
					println("Bullet HIT!!");
					asteroids.get(j).takeDamage(player.damage);
					bullets.remove(i);
					i -= 1; // make sure we are not skipping
					break;
				}
			}
		}
		
		// remove dead asteroids
		for (int i=0; i<asteroids.size(); i++) {
			if (asteroids.get(i).isDead) {
					println("Remove AST!!");
					asteroids.remove(i);
			}
		}
	}
	
	public void onKeyPressed() {
		input.onKeyPressed();
		
		if (keyCode == 32) {
			bullets.add(new Bullet(player));
		}
	}
	
	public void onKeyReleased() {
		input.onKeyReleased();
	}
}