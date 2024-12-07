// battle summary UI

class SummaryUI {
    private PFont fontLarge;
    private PFont fontMedium;

    public SummaryUI() {
        fontLarge = createFont("assets/fonts/PixelifySans-Bold.ttf", 64);
        fontMedium = createFont("assets/fonts/PixelifySans-Bold.ttf", 48);
    }

    public void update(int score) {
        // draw window
        int windowWidth = (int) (width * 0.8);
        int windowHeight = (int) (height * 0.8);
        int windowX = (width - windowWidth) >> 1;   // blank space divide by 2
        int windowY = (height - windowHeight) >> 1;

        fill(0, 0, 0, 200);
        stroke(255);
        rect(windowX, windowY, windowWidth, windowHeight);
        noStroke();

        // draw text
        fill(255);

        textFont(fontLarge);
        textAlign(CENTER, CENTER);
        text("Game Over", windowX + (windowWidth / 2), windowY + (windowHeight * 0.25));

        textFont(fontMedium);
        text("Score: " + score, windowX + (windowWidth / 2), windowY + (windowHeight * 0.5));
        text("Click to play again", windowX + (windowWidth / 2), windowY + (windowHeight * 0.75));

        textAlign(LEFT, BASELINE);  // reset text alignment
    }

    public boolean isDone() {
        return mousePressed;
    }

}