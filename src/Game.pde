// Game

class Game {
	public Player player;
	public Input input;
	public GameUI gameUI;
	public Background gameBackground;
	public ArrayList <Bullet> bullets = new ArrayList<Bullet>();
	public ArrayList <Asteroid> asteroids = new ArrayList<Asteroid>();

	public int score = 0;
	public boolean isGameOver = false;
	
	public Game() {
		input = new Input();
		player = new Player(500f, 500f, 96, 96, "assets/images/game_player_spaceship.png");
		gameUI = new GameUI(player.hp);
		gameBackground = new Background();
	}

	public void update() {
		background(0);
		
		input.updateInput();
		
		gameBackground.update();
		
		if (input.fire) {
			if (player.approveAttack())
				bullets.add(new Bullet(player));
		}
			
		// draw elements
		for (int i=0; i<bullets.size(); i++) {
			bullets.get(i).updateBullet();
		}
		
		for (int i=0; i<asteroids.size(); i++) {
			asteroids.get(i).updateAsteroid();
		}
		
		// draw user
		player.updatePlayer(input.xAxis, input.yAxis);
		
		// draw ui overlay
		gameUI.update(score, player);
		
		if(player.isDead) {	// check if game is over
			isGameOver = true;
			//println(player.hp);
		}
		
		// spawn asteroids
		if (asteroids.size() < 10) {
			//println("SPAWNING ASTEROIDS!!!");
			int generateCount = (int)random(1,5);
			for (int i=0; i<generateCount; i++) {
				asteroids.add(new Asteroid());
			}
		}
		
		// check for collision
		for (int i=0; i<bullets.size(); i++) {
			for (int j=0; j<asteroids.size(); j++) {
				// calc the distance btwn the bullet and asteroid
				double objDistance = dist(bullets.get(i).posX, bullets.get(i).posY, asteroids.get(j).posX, asteroids.get(j).posY);
				if (objDistance <= asteroids.get(j).collisionDetectionDistance) {
					//println("Bullet HIT!!");
					asteroids.get(j).takeDamage(player.damage);	// dealt dmg to asteroid
					bullets.remove(i);
					i -= 1; // make sure we are not skipping
					break;
				}
			}
		}
		
		// remove dead asteroids
		for (int i=0; i<asteroids.size(); i++) {
			if (asteroids.get(i).isDead) {
				//println("Remove AST!!");
				score += asteroids.get(i).hpMax;	// add score
				asteroids.remove(i);
			}
		}
		
		// check for collision with player
		for (int i=0; i<asteroids.size(); i++) {
			// calc the distance btwn the player and asteroid
			double objDistance = dist(player.posX, player.posY, asteroids.get(i).posX, asteroids.get(i).posY);
			if (objDistance <= (asteroids.get(i).collisionDetectionDistance+player.collisionDetectionDistance)) {
				println("Player HIT!!");
				player.takeDamage(asteroids.get(i).damage);	// dealt dmg to player
				
				if(player.isDead)
					break;
			}
		}
		
		// draw border for debug purpose
		fill(0, 0);
		stroke(255);
		rect(0, 0, width-1, height-1);
	}

	public void executeUltAtk() {
		for (int j=0; j<asteroids.size(); j++) {
			asteroids.get(j).takeDamage(player.damage*1);	// dealt dmg to asteroid
		}
	}
	
	public void onKeyPressed() {
		input.onKeyPressed();
		
		if (key == 'q') {
			if (player.approveUltAttack())
				executeUltAtk();
		}
	}
	
	public void onKeyReleased() {
		input.onKeyReleased();
	}
}