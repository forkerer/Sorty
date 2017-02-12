enum checkMode {
  LUMA, AVERAGE, HUE, SATURATION
}

/*
boolean checkPixel(color temp, checkMode mode, float lowerLimit, float upperLimit) {
  switch(mode) {
  case LUMA:
    if (getBrightness(temp, mode) >= lowerLimit && getBrightness(temp, mode) <= upperLimit) {
      return true;
    } else {
      return false;
    }
  case AVERAGE:
    if (getBrightness(temp, mode) >= lowerLimit && getBrightness(temp, mode) <= upperLimit) {
      return true;
    } else {
      return false;
    }
  default:
    print("Something bad, fix pls(checkPixel mode not set)");
    return false;
  }
}
*/
boolean checkPixel(color temp, checkMode mode, float lowerLimit, float upperLimit) {
   float check = getBrightness(temp, mode);
   return (check >= lowerLimit && check <= upperLimit);
}

//boolean comparePixels(color col1, color col2, checkMode mode) {
    
//}


float getBrightness(color test, checkMode mode) {
  
  switch(mode) {
     case LUMA: return  0.587*(((float)(green(test))/255)) + 0.299 *(((float)(red(test))/255)) + 0.114*(((float)(blue(test))/255));
     
     case AVERAGE: return (((float)(green(test)+red(test)+blue(test)))/255)/3;
     
     case HUE: return hue(test)/360;
     
     case SATURATION: return saturation(test)/255;
     
     default:
       print("Something wrong in getBrightness, returning 0");
       return 0f;
  }
  //return 0.587*((float)green(test)/255) + 0.299*((float)red(test)/255) + 0.114*((float)blue(test)/255);
}