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

    for(int i = 0; i<polygon.size();i++) {
      if ( (polygon.get(i).y > y) != (polygon.get(j).y > y) &&
        x < (polygon.get(j).x - polygon.get(i).x) * (y-polygon.get(i).y)/(polygon.get(j).y - polygon.get(i).y) + polygon.get(i).x ) {
           isInside = !isInside; 
        }
      j = i;
    }

    return isInside;
}