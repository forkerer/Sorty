public class selection {
  private int minX;
  private int maxX;
  private int minY;
  private int maxY;
  private ArrayList<PVector> polygon;

  selection() {
    this.minX = 10000000; //
    this.maxX = -10000000;       //assign values that will change to correct one as soon as point is added
    this.minY = 10000000; //
    this.maxY = -10000000;       //
    this.polygon = new ArrayList<PVector>();
  }

  public void display() {
    if (!polygon.isEmpty()) {
      for (int i = 0; i <this.polygon.size()-1; i++) {
        line(
          calcScreenX((int)this.polygon.get(i).x), 
          calcScreenY((int)this.polygon.get(i).y), 
          calcScreenX((int)this.polygon.get(i+1).x), 
          calcScreenY((int)this.polygon.get(i+1).y));
      }
      line(
        calcScreenX((int)this.polygon.get(this.polygon.size()-1).x), 
        calcScreenY((int)this.polygon.get(this.polygon.size()-1).y), 
        calcScreenX((int)this.polygon.get(0).x), 
        calcScreenY((int)this.polygon.get(0).y));
    }
  }

  ///////////////////// ADD POINT TO SELECTION /////////////////////
  public void addPoint(int x, int y) {
    this.polygon.add(new PVector(calcImageX(x), calcImageY(y)));
    this.minX = Math.min(this.minX, calcImageX(x));
    this.maxX = Math.max(this.maxX, calcImageX(x));
    this.minY = Math.min(this.minY, calcImageY(y));
    this.maxY = Math.max(this.maxY, calcImageY(y));
    Scene.processPreview();
  }


  ///////////////////// CHECK IF PXIEL IS IN SELECTION /////////////////////
  public boolean pointIsInPoly(int x, int y) {
    if (x < this.minX || x > this.maxX || y < this.minY || y > this.maxY) {
      return false;
    }
    boolean isInside = false;
    int j = polygon.size() - 1;

    for (int i = 0; i<polygon.size(); i++) {
      if ( (polygon.get(i).y > y) != (polygon.get(j).y > y) &&
        x < (polygon.get(j).x - polygon.get(i).x) * (y-polygon.get(i).y)/(polygon.get(j).y - polygon.get(i).y) + polygon.get(i).x ) {
        isInside = !isInside;
      }
      j = i;
    }

    return isInside;
  }

  ///////////////////// CALC IMAGE X FROM MOUSE POS /////////////////////
  public int calcImageX(int x) {
    if (Scene.wideCalc) {
      return (int)((float)x * ((float)Scene.getImageWidth() / (float)width));
    } else {
      return (int)((float)((float)x - (width-Scene.newWidth) / 2) * ((float)Scene.getImageWidth() / (float)Scene.newWidth));
    }
  }

  ///////////////////// CALC SCREEN X FROM IMAGE POS /////////////////////
  public int calcScreenX(int x) {
    if (Scene.wideCalc) {
      return (int)((float)x * ((float) width / (float)Scene.getImageWidth()));
    } else {
      return (int)((x * (Scene.newWidth / (float)Scene.getImageWidth())) + ((width-Scene.newWidth) / 2));
    }
  }

  ///////////////////// CALC IMAGE Y FROM MOUSE POS /////////////////////
  public int calcImageY(int y) {
    if (Scene.wideCalc) {
      return (int)(((float)y - (height-Scene.newHeight) / 2) * ((float)Scene.getImageHeight() / (float)Scene.newHeight));
    } else {
      return (int)((float)y * ((float)Scene.getImageHeight() / (float)height));
    }
  }

  ///////////////////// CALC SCREEN Y FROM IMAGE POS /////////////////////
  public int calcScreenY(int y) {
    if (Scene.wideCalc) {
      return (int)((y * (Scene.newHeight / (float)Scene.getImageHeight())) + ((height-Scene.newHeight) / 2));
    } else {
      return (int)((float)y * ((float)height / (float)Scene.getImageHeight()));
    }
  }
}