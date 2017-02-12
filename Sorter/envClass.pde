class sceneContainer {
  PImage image;
  PImage backup;
  float upperLimit;
  float lowerLimit;
  checkMode brightnessCheckMode;

  color[] sortTab; //Used for iterative MergeSort
  IntList verHelper; //Used for vertical sorting, because i can't just treat it like a row
  boolean showPreview;
  PImage preview;

  sceneContainer(PImage img, float lower, float upper, checkMode mode) {
    image = img.get(); 
    backup = img.get(); //Backup image, in case of fuckup
    preview = img.get();    
    lowerLimit = lower;
    upperLimit = upper;
    brightnessCheckMode = mode;
    verHelper = new IntList(); 
    sortTab = new color[image.pixels.length]; 
    showPreview = false;
    calcPreview();
  }

  void display() {
    fill(0);
    if (showPreview == true) { 
      image(this.preview, 0, 0, width, height);
    } else {
     image(this.image, 0, 0, width, height); 
    }
  }
  // HELPER FUNCTIONS
  void setSize(int x, int y) {
    image.resize(x, y);
    image.loadPixels();
    sortTab = new color[image.pixels.length];
  }

  void setLowerLimit(float x) {
    lowerLimit = constrain(x, 0, upperLimit);
    preview=image.get();
    calcPreview();
  }

  void setUpperLimit(float x) {
    upperLimit = constrain(x, lowerLimit, 1);
    preview=image.get();
    calcPreview();
  }

  void setMode(checkMode mode) {
    brightnessCheckMode = mode;
    preview=image.get();
    calcPreview();
  }

  void resetImage() {
    image = backup.get();
    image.updatePixels();
    preview=image.get();
    calcPreview();
  }
  
  void setPreview() {
    showPreview = !showPreview;
  }


  void calcPreview() {
    for (int i = 0; i<preview.height; i++) {
      for (int j = i*preview.width; j<(i+1)*preview.width; j++) {
        if (checkPixel(preview.pixels[j], brightnessCheckMode, lowerLimit, upperLimit)) {
          preview.pixels[j] = 0xFFFFFF;
        } else {
          preview.pixels[j] = 0x000000;
        }
      }
    }
    preview.updatePixels();
  }
  //Test brightness check
  void Debug() {
    for (int i = 0; i<image.height; i++) {
      for (int j = i*image.width; j<(i+1)*image.width; j++) {
        if (checkPixel(image.pixels[j], brightnessCheckMode, lowerLimit, upperLimit)) {
          image.pixels[j] = 0xFFFFFF;
        } else {
          image.pixels[j] = 0x000000;
        }
      }
    }
  }

  void sortHorizontal() {
    image.loadPixels();
    for (int i = 0; i<image.height; i++) {
      for (int j = i*image.width; j<(i+1)*image.width; j++) {
        if (checkPixel(image.pixels[j], brightnessCheckMode, lowerLimit, upperLimit)) { //Check if pixel should be sorted
          int from = j;
          int to = from;
          while (to<(i+1)*image.width && checkPixel(image.pixels[j], brightnessCheckMode, lowerLimit, upperLimit)) {
            to++;
            j++;
          }
          if (to-from > 0) {
            this.mergesort(image.pixels, from, to);
          }
        }
      }
    }
    image.updatePixels();
  }

  void sortVertical() {
    image.loadPixels();
    for (int i = 0; i<image.width; i++) {
      for (int j = i; j < image.width*image.height; j+=image.width) {
        if (checkPixel(image.pixels[j], brightnessCheckMode, lowerLimit, upperLimit)) { //Check if pixel should be sorted
          verHelper.clear();
          int from = j;
          int to = from;
          while (to<image.width*image.height && checkPixel(image.pixels[j], brightnessCheckMode, lowerLimit, upperLimit)) {
            verHelper.append(image.pixels[j]);
            to+=image.width;
            j+=image.width;
          }
          color[] tempTab;
          if (verHelper.size()>1) {
            tempTab = verHelper.array();
            this.mergesort(tempTab, 0, verHelper.size());
            int index = 0;
            for (int k = from; k<to; k+=image.width) {
              image.pixels[k] = tempTab[index];
              index++;
            }
          }
        }
      }
    }
    image.updatePixels();
  }

  //ITERATIVE MERGESORT, THANKS STACKOVERFLOW
  void mergesort(color[] tab, int start, int end) {
    int i, j, m;
    int rght, rend;

    for (int k = 1; k<end; k*=2) {
      for (int left = start; left+k<end; left+= (k*2)) {
        rght = left+k;
        rend = rght + k;
        if (rend > end) {
          rend = end;
        }
        m = left;
        i = left;
        j = rght;
        while (i < rght && j < rend) {
          if (getBrightness(tab[i], brightnessCheckMode) >= getBrightness(tab[j], brightnessCheckMode)) {
            //  if (saturation(tab[i]) >= saturation(tab[j])) {
            sortTab[m] = tab[i];
            i++;
          } else {
            sortTab[m] = tab[j];
            j++;
          }
          m++;
        }
        while (i < rght) {
          sortTab[m] = tab[i];
          i++;
          m++;
        }
        while (j < rend) {
          sortTab[m] = tab[j];
          j++;
          m++;
        }
        for (m=left; m<rend; m++) {
          tab[m] = sortTab[m];
        }
      }
    }
  }
}



//CALCULATING PIXEL BRIGHTNESS
//float getBrightness(color test) {
//  return 0.587*((float)green(test)/255) + 0.299*((float)red(test)/255) + 0.114*((float)blue(test)/255);
//}