class sceneContainer {
  PImage image;
  PImage backup;
  float upperLimit;
  float lowerLimit;
  checkMode pixelCheckMode;
  checkMode sortingMode;
  boolean ascending;
  workSpc workSpace;

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
    pixelCheckMode = mode;
    verHelper = new IntList(); 
    sortTab = new color[image.pixels.length]; 
    showPreview = false;
    calcPreview();
    ascending = true;
    sortingMode = mode;
    workSpace = workSpc.ALL;
  }
  /*
  void display() {
   fill(0);
   
   //float newWidth = ((float)image.width / (float)image.height) * height;
   if (showPreview == true) { 
   image(this.preview, (width-newWidth)/2, 0, newWidth, height);
   } else {
   image(this.image, (width-newWidth)/2, 0, newWidth, height); 
   }*/

  void display() {
    fill(0);

    beginShape();
    if (showPreview == true) { 
      texture(this.preview);
    } else {
      texture(this.image);
    }
    if (wideCalc == false) {
      vertex((width-newWidth)/2, 0, 0, 0);
      vertex((width-newWidth)/2+newWidth, 0, image.width, 0);
      vertex((width-newWidth)/2+newWidth, height, image.width, image.height);
      vertex((width-newWidth)/2, height, 0, image.height);
    } else {
      vertex(0, (height-newHeight)/2, 0, 0);
      vertex(width, (height-newHeight)/2, image.width, 0);
      vertex(width, (height-newHeight)/2 + newHeight, image.width, image.height);
      vertex(0, (height-newHeight)/2 + newHeight, 0, image.height);
    }
    endShape();
  }
  // HELPER FUNCTIONS
  void setSize(int x, int y) {
    image.resize(x, y);
    image.loadPixels();
    sortTab = new color[image.pixels.length];
  }

  void ascDescChange(boolean value) {
    ascending = value;
  }
  
  void setWorkSpace(workSpc space) {
     this.workSpace = space;
  }

  float getLowerLimit() {
    return lowerLimit;
  }

  float getUpperLimit() {
    return upperLimit;
  }

  void setLowerLimit(float x) {
    lowerLimit = constrain(x, 0, upperLimit);
    preview=image.get();
    processPreview();
  }

  void setUpperLimit(float x) {
    upperLimit = constrain(x, lowerLimit, 1);
    preview=image.get();
    processPreview();
  }

  void setCheckMode(checkMode mode) {
    pixelCheckMode = mode;
    preview=image.get();
    processPreview();
  }

  void setSortingMode(checkMode mode) {
    sortingMode = mode;
    preview=image.get();
    processPreview();
  }

  void resetImage() {
    image = backup.get();
    image.updatePixels();
    preview=image.get();
    processPreview();
  }
  
  void resetImageSelection(ArrayList<PVector> polygon) {
    for (int i = 0; i<preview.height; i++) {
      for (int j = i*preview.width; j<(i+1)*preview.width; j++) {
        if (pointIsInPoly(j-i*preview.width, i, polygon) && checkPixel(image.pixels[j], pixelCheckMode, lowerLimit, upperLimit)) {
          image.pixels[j] = backup.pixels[j];
        }
      }
    }
    image.updatePixels();
    preview=image.get();
    processPreview();
  }
  
  void resetImageNoSelection(ArrayList<PVector> polygon) {
    for (int i = 0; i<preview.height; i++) {
      for (int j = i*preview.width; j<(i+1)*preview.width; j++) {
        if (!pointIsInPoly(j-i*preview.width, i, polygon) && checkPixel(image.pixels[j], pixelCheckMode, lowerLimit, upperLimit)) {
          image.pixels[j] = backup.pixels[j];
        }
      }
    }
    image.updatePixels();
    preview=image.get();
    processPreview();
  }

  void setPreview() {
    showPreview = !showPreview;
  }
  
  void processPreview() {
    switch(workSpace) {
       case ALL: 
         this.calcPreview();
         break;
       case SELECTION:
         if(!selectedArea.isEmpty()) {
         this.calcSelectionPreview(selectedArea);
         } else {
         this.calcPreview();
         }
         break;
       case ALLNOSELECTION:
         if(!selectedArea.isEmpty()) {
         this.calcNoSelectionPreview(selectedArea);
         } else {
         this.calcPreview();
         }
         break;
    }
  }
  
  void processReset() {
    switch(workSpace) {
      case ALL: 
        resetImage();
        break;
      case SELECTION:
         if(!selectedArea.isEmpty()) {
         this.resetImageSelection(selectedArea);
         } else {
         this.resetImage();
         }
         break;
       case ALLNOSELECTION:
         if(!selectedArea.isEmpty()) {
         this.resetImageNoSelection(selectedArea);
         } else {
         this.resetImage();
         }
         break;
    }
  }

  void offsetX(int offset, int start, int end) {
    image.loadPixels();
    color[] tempTab = new color[image.pixels.length];
    for (int i = start; i<end; i++) {
      for (int j = 0; j<image.width; j++) {
        int index = (j+offset)%image.width;
        tempTab[index+i*image.width] = image.pixels[j+i*image.width];
      }
    }
    for (int i = start; i < end; i++) {
      for (int j = 0; j<image.width; j++) {
        image.pixels[j+i*image.width] = tempTab[j+i*image.width];
      }
    }
    image.updatePixels();
    preview=image.get();
    calcPreview();
  }

  void calcNoSelectionPreview(ArrayList<PVector> polygon) {
    for (int i = 0; i<preview.height; i++) {
      for (int j = i*preview.width; j<(i+1)*preview.width; j++) {
        if (!pointIsInPoly(j-i*preview.width, i, polygon) && checkPixel(image.pixels[j], pixelCheckMode, lowerLimit, upperLimit)) {
          preview.pixels[j] = 0xFFFFFF;
        } else {
          preview.pixels[j] = 0x000000;
        }
      }
    }
    preview.updatePixels();
  }

  void calcSelectionPreview(ArrayList<PVector> polygon) {
    for (int i = 0; i<preview.height; i++) {
      for (int j = i*preview.width; j<(i+1)*preview.width; j++) {
        if (pointIsInPoly(j-i*preview.width, i, polygon) && checkPixel(image.pixels[j], pixelCheckMode, lowerLimit, upperLimit)) {
          preview.pixels[j] = 0xFFFFFF;
        } else {
          preview.pixels[j] = 0x000000;
        }
      }
    }
    preview.updatePixels();
  }

  void sortSelectionHorizontal() {
    image.loadPixels();
    for (int i = 0; i<image.height; i++) {
      for (int j = i*image.width; j<(i+1)*image.width; j++) {
        if (red(preview.pixels[j]) == 255 && checkPixel(image.pixels[j], pixelCheckMode, lowerLimit, upperLimit)) { //Check if pixel should be sorted
          int from = j;
          int to = from;
          while (to<(i+1)*image.width && red(preview.pixels[j]) == 255 && checkPixel(image.pixels[j], pixelCheckMode, lowerLimit, upperLimit)) {
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

  void sortSelectionVertical() {
    image.loadPixels();
    for (int i = 0; i<image.width; i++) {
      for (int j = i; j < image.width*image.height; j+=image.width) {
        if (red(preview.pixels[j]) == 255 && checkPixel(image.pixels[j], pixelCheckMode, lowerLimit, upperLimit)) { //Check if pixel should be sorted
          verHelper.clear();
          int from = j;
          int to = from;
          while (to<image.width*image.height && red(preview.pixels[j]) == 255 && checkPixel(image.pixels[j], pixelCheckMode, lowerLimit, upperLimit)) {
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

  void calcPreview() {
    for (int i = 0; i<preview.height; i++) {
      for (int j = i*preview.width; j<(i+1)*preview.width; j++) {
        if (checkPixel(image.pixels[j], pixelCheckMode, lowerLimit, upperLimit)) {
          preview.pixels[j] = 0xFFFFFF;
        } else {
          preview.pixels[j] = 0x000000;
        }
      }
    }
    preview.updatePixels();
  }

  void sortHorizontal() {
    image.loadPixels();
    for (int i = 0; i<image.height; i++) {
      for (int j = i*image.width; j<(i+1)*image.width; j++) {
        if (checkPixel(image.pixels[j], pixelCheckMode, lowerLimit, upperLimit)) { //Check if pixel should be sorted
          int from = j;
          int to = from;
          while (to<(i+1)*image.width && checkPixel(image.pixels[j], pixelCheckMode, lowerLimit, upperLimit)) {
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
        if (checkPixel(image.pixels[j], pixelCheckMode, lowerLimit, upperLimit)) { //Check if pixel should be sorted
          verHelper.clear();
          int from = j;
          int to = from;
          while (to<image.width*image.height && checkPixel(image.pixels[j], pixelCheckMode, lowerLimit, upperLimit)) {
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
          //if (getBrightness(tab[i], pixelCheckMode) >= getBrightness(tab[j], pixelCheckMode)) {
          if (comparePixels(tab[i], tab[j], sortingMode, ascending)) {
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