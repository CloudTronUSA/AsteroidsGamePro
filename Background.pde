class Background {
  public ArrayList stars = new ArrayList<Star>();
  public int summonAttempts = 100;
  public int summonDistanceLimit = 50;
  public double starScrollSpeed = 0;
  
  public Background() {
    for(int i=0; i<summonAttempts; i++) {
      int randX = (int) random(0, width);
      int randY = (int) random(0, height);
      
      boolean failed = false;
      for(int j=0; j<stars.size(); j++) {
        Star star  = (Star) stars.get(j);
        if( dist(star.posX, star.posY, randX, randY) < summonDistanceLimit ) {
          failed = true;
          break;
        }
      }
      
      if (failed) {
        continue;
      }
      
      stars.add(new Star(randX, randY, (int) random(50,100) , (int) random(0,5)));
    }
  }
  
  public void update() {
    for (int i=0; i<stars.size(); i++) {
      Star star = (Star)stars.get(i);
      star.update();
    }
  }
}