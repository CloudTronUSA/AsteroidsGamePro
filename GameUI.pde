// In Game UI (overlay)

class GameUI {
	public int maxHpBarLength = 200;
	public int maxEnergyBarLength = 200;
	
	private Player playerInstance;
	private int displayedScore;	// current displayed score
	private int targetScore;	// should reach this damage by a given time
	private PFont fontLarge;
	private PFont fontMedium;
	
	public double reachTScoreInFrames = 5;	// displayed score should be target score in this many frames
	
	public GameUI(int initPlayerHP) {
		fontLarge = createFont("data/PixelifySans-Bold.ttf", 64);
		fontMedium = createFont("data/PixelifySans-Bold.ttf", 48);
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

	public void update(int newScore, Player player) {
		textFont(fontLarge);
		
		// draw damage
		targetScore = newScore;
		double scoreDifference = targetScore - displayedScore;
		displayedScore += scoreDifference / reachTScoreInFrames;	// determine the required change of score to reach target score in specified frames
		
		fill(246,244,181);
		text(zfill((int)displayedScore, 5), 15, 64);
		
		// draw HP bar
		fill(217, 51, 15);
		
		textFont(fontMedium);
		text("HP", 15, 650);
		
		noStroke();
		int hpBarLength = maxHpBarLength * (player.hp / player.maxHp);
		//println(hpBarLength);
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
		int enBarLength = maxEnergyBarLength * (player.energy / player.maxEnergy);
		rect(85, 675, enBarLength, 20);	// energy
		
		stroke(2, 185, 243);	// border
		fill(0,0);
		strokeWeight(4); 
		rect(80, 670, maxEnergyBarLength+10, 30);
		
	}
	
}