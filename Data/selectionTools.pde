boolean pointIsInPoly(int x, int y, ArrayList<PVector> polygon) {
  boolean isInside = false;
  float minX = polygon.get(0).x, maxX = polygon.get(0).x;
  float minY = polygon.get(0).y, maxY = polygon.get(0).y;
  for (int n = 1; n < polygon.size(); n++) {
    PVector q = polygon.get(n);
    minX = Math.min(q.x, minX);
    maxX = Math.max(q.x, maxX);
    minY = Math.min(q.y, minY);
    maxY = Math.max(q.y, maxY);
  }

  if (x < minX || x > maxX || y < minY || y > maxY) {
    return false;
  }

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

int calcImageX(int x) {
  return (int)((x - (width-Scene.newWidth) / 2) * ((float)Scene.getImageWidth() / Scene.newWidth));
}

int calcScreenX(int x) {
  return (int)((x * (Scene.newWidth / (float)Scene.getImageWidth())) + ((width-Scene.newWidth) / 2));
}

int calcImageY(int y) {
  return (int)((y - (height-Scene.newHeight) / 2) * ((float)Scene.getImageHeight() / Scene.newHeight));
}

int calcScreenY(int y) {
  return (int)((y * (Scene.newHeight / (float)Scene.getImageHeight())) + ((height-Scene.newHeight) / 2));
}