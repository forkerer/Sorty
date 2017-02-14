enum checkMode {
  LUMA, AVERAGE, HUE, SATURATION, RED, GREEN, BLUE
}

boolean checkPixel(color temp, checkMode mode, float lowerLimit, float upperLimit) {
   float check = getBrightness(temp, mode);
   return (check >= lowerLimit && check <= upperLimit);
}

boolean comparePixels(color col1, color col2, checkMode mode, boolean ascending) {
  if (ascending) {
    return getBrightness(col1, mode) >= getBrightness(col2, mode);
  } else {
    return getBrightness(col1, mode) <= getBrightness(col2, mode);
  }
}


float getBrightness(color col, checkMode mode) {
  
  switch(mode) {
     case LUMA: return  0.587*(((float)(green(col))/255)) + 0.299 *(((float)(red(col))/255)) + 0.114*(((float)(blue(col))/255));
     
     case AVERAGE: return (((float)(green(col)+red(col)+blue(col)))/255)/3;
     
     case HUE: return hue(col)/360;
     
     case SATURATION: return saturation(col)/255;
     
     case RED: return (float)red(col)/255;
     
     case GREEN: return (float)green(col)/255;
     
     case BLUE: return (float)blue(col)/255;
     
     default:
       print("Something wrong in getBrightness, returning 0");
       return 0f;
  }
}