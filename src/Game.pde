// Game

class Game {
	private Player player;
	private Input input;
	private GameUI gameUI;
    private SummaryUI summaryUI;
	private Background gameBackground;
    
    private ArrayList <Bullet> bullets;
    private ArrayList <Entity> enemies;

	private int score;
	private boolean gameOver;
    private int gameState;  // 0: ongoing, 1: pre-summary animation, 2: summary, 3: post-summary (game over)
    
    private int gameStage;  // 0: normal, 1: scroll, 2: boss
    private int timeElapsedStage;
    private int timeElapsed;
    private boolean stageShifting;  // flag to indicate stage is shifting

    private AnimController animController;

	public Game() {
		input = new Input();
		player = new Player(width/2, height/2);
		gameUI = new GameUI(this, player);
        summaryUI = new SummaryUI();
		gameBackground = new Background();
        
        bullets = new ArrayList<Bullet>();
        enemies = new ArrayList<Entity>();

        score = 0;
        gameState = 0;

        gameStage = 0;
        timeElapsedStage = 0;
        timeElapsed = 0;
        stageShifting = false;
	}

    // prep for pre-summary animation
    private void prepPreSummary() {
        // create animation for player (exit animation)
        Transform playerTransform = player.getTransform();
        Keyframe[] keyframes = new Keyframe[5];

        // always one keyframe for start and end
        keyframes[0] = new Keyframe(player, playerTransform.x, playerTransform.y, playerTransform.w, playerTransform.h, playerTransform.rotation, 0);
        keyframes[1] = new Keyframe(player, width/2, height/2, playerTransform.w, playerTransform.h, 0, 1);
        keyframes[2] = new Keyframe(player, width/2, height/2, playerTransform.w, playerTransform.h, 0, 10);
        keyframes[3] = new Keyframe(player, width/2, -50, playerTransform.w, playerTransform.h, 0, 30);
        keyframes[4] = new Keyframe(player, width/2, -50, playerTransform.w, playerTransform.h, 0, 60);
        
        animController = new AnimController();
        animController.addKeyframes(keyframes);

        gameBackground.setStarScrollSpeed(0);    // stop the background scrolling
        gameState = 1;  // set to enter pre-summary animation
    }

    // do pre-summary animation
    public void updatePreSummary() {
        animController.update();
        
        // draw background
		background(0);
		gameBackground.update();

        for (int i=0; i<enemies.size(); i++) {
            enemies.get(i).draw();    // update enemies to show exit animation
        }
        player.draw();    // update player to show exit animation

        if (animController.hasFinished()) {
            gameState = 2;  // set to enter summary
        }
    }

    // do summary
    public void updateSummary() {
        background(0);

        gameBackground.update();
        summaryUI.update(score);

        if (summaryUI.isDone()) {
            gameState = 3;  // set to enter post-summary (game over)
        }
    }

    // prep for stage change
    private void prepStageChange(int targetStage) {
        // modify the game according to the stage
        if (targetStage == 0) {   // normal stage
            gameBackground.setStarScrollSpeed(1);
            player.setRotationLock(false);
            player.setYMovementLock(false);

        } else if (targetStage == 1) {    // scroll stage
            // background scroll faster
            gameBackground.setStarScrollSpeed(2);

            // lock player Y movement & rotation
            Transform playerTransform = player.getTransform();
            playerTransform.y = height * 0.75;
            player.setTransform(playerTransform);
            player.setRotationLock(true);
            player.setYMovementLock(true);

        } else if (targetStage == 2) { // boss stage
            gameBackground.setStarScrollSpeed(0.5);
            player.setRotationLock(false);    // unlock player rotation
        }

        // setup stage change animation
        Transform playerTransform = player.getTransform();
        Keyframe[] keyframes = new Keyframe[4];

        // always one keyframe for start and end
        keyframes[0] = new Keyframe(player, playerTransform.x, playerTransform.y, playerTransform.w, playerTransform.h, playerTransform.rotation, 0);
        keyframes[1] = new Keyframe(player, playerTransform.x, playerTransform.y, playerTransform.w, playerTransform.h, playerTransform.rotation, 10);
        keyframes[2] = new Keyframe(player, width/2, height*0.75, playerTransform.w, playerTransform.h, 0, 40);
        keyframes[3] = new Keyframe(player, width/2, height*0.75, playerTransform.w, playerTransform.h, 0, 60);
        
        animController = new AnimController();
        animController.addKeyframes(keyframes);

        // modify all enemies so they go downwards
        for (int i=0; i<enemies.size(); i++) {
            Entity enemy = enemies.get(i);
            if (enemy instanceof Asteroid) {
                Asteroid asteroid = (Asteroid) enemy;
                asteroid.setDirection(90);
                asteroid.setSpeed(10);
            }
        }

        stageShifting = true;
        gameStage = targetStage;
    }

    // do stage change
    private void updateStageChange() {
        stageShifting = true;
        gameBackground.setStarScrollSpeed(0);    // stop the background scrolling
        gameState = 1;  // set to enter pre-summary animation
    }

    // normal game update
	public void update() {
        // check if player is dead
        if(!player.isAlive() && gameState == 0) {
			prepPreSummary();   // run once
		}

        if (gameState == 1) {   // executing pre-summary animation
            updatePreSummary();
            return;
        }

        if (gameState == 2) {   // executing summary
            updateSummary();
            return;
        }

        if (gameState == 3) {   // post-summary (game over)
            return;
        }

        // control game stage
        // every tick after 1800 ticks have 0.01% chance to change stage between 0 and 1
        // the chance will increase by 5% every 60 ticks(30 seconds)
        double stageChangeProbability = 0;
        if (timeElapsedStage > 1800) {
            stageChangeProbability = 0.01;
            stageChangeProbability *= pow(1.05, int((timeElapsedStage - 1800) / 60));
        }
        if (Math.random()*100 < stageChangeProbability) {
            gameStage = (gameStage + 1) % 2;
            timeElapsedStage = 0;
        }

		input.updateInput();

        // spawn asteroids
		if (enemies.size() < 10) {
			int generateCount = (int)random(1,5);
			for (int i=0; i<generateCount; i++) {
                if (gameStage == 0) {
                    enemies.add(new Asteroid());
                } else if (gameStage == 1) {
                    enemies.add(new SpecialAsteroid());
                }
			}
		}
		
        // inform player to attack (launch bullets)
		if (input.fire) {
			player.attack(bullets); // pass this in so that player can add bullet to the list
		}

        // handle collision //

        // check for enemy collision with player
		for (int i=0; i<enemies.size(); i++) {
			Entity enemy = enemies.get(i);
            if (player.checkCollision(enemy)) {
				double dmg = enemy.preAttack();
                player.takeDamage(dmg);
			}
		}

        // check for bullet collision with asteroid
		for (int i=0; i<bullets.size(); i++) {
            Bullet bullet = bullets.get(i);
			for (int j=0; j<enemies.size(); j++) {
				Entity enemy = enemies.get(j);
				if (bullet.checkCollision(enemy)) {
					double dmg = bullet.preAttack();
                    bullets.remove(i);
                    i -= 1; // make sure we are not skipping any bullet
                    double realDmg = enemy.takeDamage(dmg);
                    score += realDmg;
                    break;
				}
			}
		}

        // clean ups //

        // remove dead enemies
		for (int i=0; i<enemies.size(); i++) {
			if (!enemies.get(i).isAlive()) {
				enemies.remove(i);
                i -= 1; // make sure we are not skipping any asteroid
			}
		}

        // remove out of bound bullets
        for (int i=0; i<bullets.size(); i++) {
            if (bullets.get(i).isOutOfBounds()) {
                bullets.remove(i);
                i -= 1; // make sure we are not skipping any bullet
            }
        }

        // draw background
		background(0);
		gameBackground.update();
		
        // draw elements: enemies
		for (int i=0; i<enemies.size(); i++) {
			enemies.get(i).update();
		}

        // draw elements: bullets
		for (int i=0; i<bullets.size(); i++) {
			bullets.get(i).update();
		}
		
		// draw user
        player.update(input.xAxis, input.yAxis);

		// draw ui overlay
		gameUI.update(score, player);
		
		// draw border for debug purpose
		fill(0, 0);
		stroke(255);
		rect(0, 0, width-1, height-1);

        timeElapsed += 1;
        timeElapsedStage += 1;
	}

	private void executePlayerUltAtk() {
		double totalDamageDealt = player.ultAttack(enemies);
        score += totalDamageDealt;
	}
	
	public void onKeyPressed() {
		input.onKeyPressed();
		
		if (key == 'q') {
			executePlayerUltAtk();
		}

        if (key == 't') {
            player.hyperspaceAbility();
        }
	}
	
	public void onKeyReleased() {
		input.onKeyReleased();
	}

    public int getGameState() {
        return gameState;
    }

    public int getGameStage() {
        return gameStage;
    }

    public int getTimeElapsed() {
        return timeElapsed;
    }

    public int getTimeElapsedStage() {
        return timeElapsedStage;
    }
}