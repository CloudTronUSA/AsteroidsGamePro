// In Game UI (overlay)

class GameUI {
	private int maxHpBarLength;
	private int maxEnergyBarLength;
	
	private int displayedScore;	// current displayed score
	private int targetScore;	// should reach this damage by a given time
	private PFont fontLarge;
	private PFont fontMedium;
    private PFont fontSmall;
	
	private double reachTScoreInFrame; // displayed score should be target score in this many frames
	
    private Game game;
    private Player player;

	public GameUI(Game game, Player player) {
		fontLarge = createFont("assets/fonts/PixelifySans-Bold.ttf", 64);
		fontMedium = createFont("assets/fonts/PixelifySans-Bold.ttf", 48);
        fontSmall = createFont("assets/fonts/PixelifySans-Regular.ttf", 24);

        this.game = game;
        this.player = player;

        maxEnergyBarLength = 200;
        maxHpBarLength = 200;

        reachTScoreInFrames = 5;
	}

	private String zfill(int number, int targetDigits) {
        String numStr = number.toString();
        String zeros = "";
        if (numStr.length() < targetDigits) {
            for (int i=0; i<(targetDigits-numStr.length()); i++) {
                zeros = zeros + "0";
            }
        }
		return zeros + numStr;
	}

	public void update(int newScore) {
		textFont(fontLarge);
		
		// draw damage
		targetScore = newScore;
		double scoreDifference = targetScore - displayedScore;
		displayedScore += scoreDifference / reachTScoreInFrames;	// determine the required change of score to reach target score in specified frames
		
		fill(246,244,181);
		text(zfill((int)displayedScore, 5), 15, 64);

        // draw game state
        textFont(fontSmall);
        fill(0, 255, 0);
        text("Game Stage: " + game.getGameStage(), 15, 100);
        text("Time Elapsed Total: " + game.getTimeElapsed(), 15, 120);
        text("Time Elapsed Stage: " + game.getTimeElapsedStage(), 15, 140);
		
		// draw HP bar
		fill(217, 51, 15);
		
		textFont(fontMedium);
		text("HP", 15, 650);
		
		noStroke();
		int hpBarLength = maxHpBarLength * (player.getHealth() / player.getMaxHealth());
		rect(85, 625, hpBarLength, 20);	// hp
		
		stroke(217, 51, 15);	// border
		fill(0,0);
		strokeWeight(4); 
		rect(80, 620, maxHpBarLength+10, 30);
		
		// draw energy bar
		fill(2, 185, 243);
		
		textFont(fontMedium);
		text("EN", 15, 700);
		
		noStroke();
		int enBarLength = maxEnergyBarLength * (player.getEnergy() / player.getMaxEnergy());
		rect(85, 675, enBarLength, 20);	// energy
		
		stroke(2, 185, 243);	// border
		fill(0,0);
		strokeWeight(4); 
		rect(80, 670, maxEnergyBarLength+10, 30);
	}
}