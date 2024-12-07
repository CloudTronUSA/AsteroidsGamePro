// dynamic background with stars

class Background {
    private ArrayList stars;
    private int summonAttempts;
    private int summonDistanceLimit;
    private double starScrollSpeed;
    
    public Background() {
        stars = new ArrayList<Star>();
        summonAttempts = 100;
        summonDistanceLimit = 50;
        starScrollSpeed = 1;

        for(int i=0; i<summonAttempts; i++) {
            int randX = (int) random(0, width);
            int randY = (int) random(0, height);
            
            boolean failed = false;
            for(int j=0; j<stars.size(); j++) {
                Star star  = (Star) stars.get(j);
                if( dist(star.getPosX(), star.getPosY(), randX, randY) < summonDistanceLimit ) {
                    failed = true;
                    break;
                }
            }
            
            if (failed) {
                continue;
            }
            
            stars.add(new Star(randX, randY, (int) random(80,100), (int) random(0,5), (int) random(0,1000)));
        }
    }
    
    public void update() {
        for (int i=0; i<stars.size(); i++) {
            Star star = (Star)stars.get(i);
            // move the star
            star.setPosY(star.getPosY() + (int) starScrollSpeed);
            star.update();
        }
        // set the stars that have reached the border to the top
        for (int i=0; i<stars.size(); i++) {
            Star star = (Star)stars.get(i);
            if (star.hasReachedBorder()) {
                star.setPosY(0);
            }
        }
    }

    public void setStarScrollSpeed(double newSpeed) {starScrollSpeed = newSpeed;}
}

// Star class
class Star {
    private int basePosX;
    private int basePosY;
    private int offsetX;
    private int offsetY;

    private int starOpacity;
    private int starSize;
    private int starPixelSize;
    private double starOpaDecayRate;
    private int timeOffset;

    private int updatesSinceExistance;

    // [[x, y, opa], [x, y, opa], ...]
    private ArrayList<ArrayList<Integer>> paintInstructions = new ArrayList<ArrayList<Integer>>();
    
    protected Star(int initX, int initY, int initOpa, int initSize, int timeOffset) {
        basePosX = initX;
        basePosY = initY;
        offsetX = 0;
        offsetY = 0;

        starOpacity = initOpa;
        starSize = initSize;
        starPixelSize = (int) random(3,6);
        starOpaDecayRate = 0.8;
        this.timeOffset = timeOffset;   // assign a random offset to the sin wave so stars blink differently
        updatesSinceExistance = 0;
        
        // generate paint instruction: treat every pixel of the star as a rect of a certain size.
        int halfPixSize = (int) starPixelSize / 2;
        
        // add the first block
        ArrayList<Integer> initStarBlock = new ArrayList<Integer>(); 
        initStarBlock.add(basePosX - halfPixSize);
        initStarBlock.add(basePosY - halfPixSize);
        initStarBlock.add((int)(starOpacity * pow((float)starOpaDecayRate, 0)));
        paintInstructions.add(initStarBlock);
        
        // add the rest (horizontal)
        for (int x=(basePosX-(starSize*starPixelSize)); x<=(basePosX+(starSize*starPixelSize)); x+=starPixelSize) {
            ArrayList<Integer> starBlock = new ArrayList<Integer>(); 
            starBlock.add(x - halfPixSize);
            starBlock.add(basePosY - halfPixSize);
            starBlock.add((int)(starOpacity * pow((float)starOpaDecayRate, abs((basePosX-x)/starPixelSize))));
            paintInstructions.add(starBlock);
        }
        
        // vertical
        for (int y=(basePosY-(starSize*starPixelSize)); y<=(basePosY+(starSize*starPixelSize)); y+=starPixelSize) {
            ArrayList<Integer> starBlock = new ArrayList<Integer>(); 
            starBlock.add(basePosX - halfPixSize);
            starBlock.add(y - halfPixSize);
            starBlock.add((int)(starOpacity * pow((float)starOpaDecayRate, abs((basePosY-y)/starPixelSize))));
            paintInstructions.add(starBlock);
        }
    }
    
    public void update() {
        updatesSinceExistance += 1;
        double globalOpaMultiplier = Math.sin((updatesSinceExistance + timeOffset) * 0.03) * 0.3 + 0.5;

        for (int i=0; i<paintInstructions.size(); i++) {
            ArrayList<Integer> starBlock = paintInstructions.get(i);
            fill(255, (float) (starBlock.get(2) * globalOpaMultiplier));
            noStroke();
            rect(starBlock.get(0)+offsetX, starBlock.get(1)+offsetY, starPixelSize, starPixelSize);
        }

        if (updatesSinceExistance > 10000) {
            updatesSinceExistance = 0;  // reset to avoid overflow
        }
    }

    public int getPosX() {return basePosX+offsetX;}
    public int getPosY() {return basePosY+offsetY;}

    public void setPosY(int newPosY) {
        offsetY = newPosY - basePosY;
    }

    public boolean hasReachedBorder() {
        return basePosY + offsetY < 0 || basePosY + offsetY > height;
    }
}