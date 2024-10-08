class Star {
  public int posX;
  public int posY;

  public int starOpacity;
  public int starSize;
  public int starPixelSize = (int) random(3,6);
  public double starOpaDecayRate = 0.7;

  // [[x, y, opa], [x, y, opa], ...]
  private ArrayList<ArrayList<Integer>> paintInstructions = new ArrayList<ArrayList<Integer>>();
  
  public Star(int initX, int initY, int initOpa, int initSize) {
    posX = initX;
    posY = initY;
    starOpacity = initOpa;
    starSize = initSize;
    
    // generate paint instruction: treat every pixel of the star as a rect of a certain size.
    int halfPixSize = (int) starPixelSize / 2;
    
    // add the first block
    ArrayList<Integer> initStarBlock = new ArrayList<Integer>(); 
    initStarBlock.add(posX - halfPixSize);
    initStarBlock.add(posY - halfPixSize);
    initStarBlock.add((int)(starOpacity * pow((float)starOpaDecayRate, 0)));
    paintInstructions.add(initStarBlock);
    
    // add the rest (horizontal)
    for (int x=(posX-(starSize*starPixelSize)); x<=(posX+(starSize*starPixelSize)); x+=starPixelSize) {
      ArrayList<Integer> starBlock = new ArrayList<Integer>(); 
      starBlock.add(x - halfPixSize);
      starBlock.add(posY - halfPixSize);
      starBlock.add((int)(starOpacity * pow((float)starOpaDecayRate, abs((posX-x)/starPixelSize))));
      paintInstructions.add(starBlock);
    }
    
    // vertical
    for (int y=(posY-(starSize*starPixelSize)); y<=(posY+(starSize*starPixelSize)); y+=starPixelSize) {
      ArrayList<Integer> starBlock = new ArrayList<Integer>(); 
      starBlock.add(posX - halfPixSize);
      starBlock.add(y - halfPixSize);
      starBlock.add((int)(starOpacity * pow((float)starOpaDecayRate, abs((posY-y)/starPixelSize))));
      paintInstructions.add(starBlock);
    }
  }
  
  public void update() {
    for (int i=0; i<paintInstructions.size(); i++) {
      ArrayList<Integer> starBlock = paintInstructions.get(i);
      fill(255, starBlock.get(2));
      noStroke();
      rect(starBlock.get(0), starBlock.get(1), starPixelSize, starPixelSize);
    }
  }
}