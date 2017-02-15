enum workSpc {
  ALL, ALLNOSELECTION, SELECTION
}

enum checkMode {
  LUMA, AVERAGE, HUE, SATURATION, RED, GREEN, BLUE
}

public class sceneContainer {
  private PImage image;
  private PImage preview;
  private PImage backup;
  private float lowerLimit;  //lower limit of sorting
  private float upperLimit;  //upper limit of sorting
  private boolean ascending;  //Decides if sorting should be ascending or descending
  private color[] sortTab;  //Table used for iterative MergeSort
  private color[] verHelper;  //Used as temporary row(so columns can be sorted like rows)  verticalHelper
  private boolean showPreview;
  private boolean selectionActive;

  private checkMode pixelCheckMode;  //used to decide what should be sorted
  private checkMode sortingMode;  //used to decide by what should the image be sorted
  private workSpc workSpace;  //used to decide what part of the image is affected by actions

  public float newWidth;
  public float newHeight;
  public boolean wideCalc;
  public ArrayList<PVector> selectedArea;

  ////////////////////////////////////// CONSTRUCTOR //////////////////////////////////////
  sceneContainer(PImage sourceImg, float lower, float upper, checkMode mode) {
    this.image = sourceImg.get();
    this.backup = sourceImg.get();
    this.preview = sourceImg.get();

    this.lowerLimit = lower;
    this.upperLimit = upper;

    this.pixelCheckMode = mode;
    this.sortingMode = mode;
    this.workSpace = workSpc.ALL;

    sourceImg.loadPixels();
    this.verHelper = new color[sourceImg.height];
    this.sortTab = new color[sourceImg.pixels.length];
    this.selectedArea = new ArrayList<PVector>();

    this.showPreview = false;
    this.ascending = true;
    this.selectionActive = false;


    this.processPreview();
    this.calculateNewImageSize(sourceImg.width, sourceImg.height);
  }

  ////////////////////////////////////// DISPLAY THIS WHOLE THING //////////////////////////////////////
  public void display() {
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
  ////////////////////////////////////// PREVIEW FUNCTIONS //////////////////////////////////////
  public void processPreview() {
    this.image.loadPixels();
    this.preview.loadPixels();

    switch(this.workSpace) {
    case ALL: 
      this.calcPreview();
      break;
    case SELECTION:
      if (this.selectedArea.size() > 2) {
        this.calcSelectionPreview(selectedArea);
      } else {
        this.calcPreview();
      }
      break;
    case ALLNOSELECTION:
      if (this.selectedArea.size() > 2) {
        this.calcNoSelectionPreview(selectedArea);
      } else {
        this.calcPreview();
      }
      break;
    }

    this.preview.updatePixels();
  }

  private void calcPreview() {
    for (int row = 0; row < this.preview.height; row++) {
      for (int pixel = row * this.preview.width; pixel < (row+1) * this.preview.width; pixel++) {
        if (checkPixel(this.image.pixels[pixel])) {
          this.preview.pixels[pixel] = 0xFFFFFF;
        } else {
          this.preview.pixels[pixel] = 0x000000;
        }
      }
    }
  }

  private void calcNoSelectionPreview(ArrayList<PVector> polygon) {
    for (int row = 0; row < this.preview.height; row++) {
      for (int pixel = row * this.preview.width; pixel < (row+1) * this.preview.width; pixel++) {
        if (checkPixel(this.image.pixels[pixel]) && !pointIsInPoly(pixel - row * this.preview.width, row, polygon)) {
          this.preview.pixels[pixel] = 0xFFFFFF;
        } else {
          this.preview.pixels[pixel] = 0x000000;
        }
      }
    }
  }

  private void calcSelectionPreview(ArrayList<PVector> polygon) {
    for (int row = 0; row < this.preview.height; row++) {
      for (int pixel = row * this.preview.width; pixel < (row+1) * this.preview.width; pixel++) {
        if (checkPixel(this.image.pixels[pixel]) && pointIsInPoly(pixel - row * this.preview.width, row, polygon)) {
          this.preview.pixels[pixel] = 0xFFFFFF;
        } else {
          this.preview.pixels[pixel] = 0x000000;
        }
      }
    }
  }

  ////////////////////////////////////// RESET FUNCTIONS //////////////////////////////////////
  public void processReset() {
    this.image.loadPixels();
    this.preview.loadPixels();
    this.backup.loadPixels();

    switch(this.workSpace) {
    case ALL: 
      this.resetImage();
      break;
    case SELECTION:
      if (this.selectedArea.size() > 2) {
        this.resetImageWithSelection();
      } else {
        this.resetImage();
      }
      break;
    case ALLNOSELECTION:
      if (this.selectedArea.size() > 2) {
        this.resetImageWithSelection();
      } else {
        this.resetImage();
      }
      break;
    }

    this.image.updatePixels();
    this.processPreview();
  }

  private void resetImage() {
    this.image = this.backup.get();
  }

  private void resetImageWithSelection() {
    for (int row = 0; row < this.preview.height; row++) {
      for (int pixel = row * this.preview.width; pixel < (row+1) * this.preview.width; pixel++) {
        if (red(this.preview.pixels[pixel]) == 255) {
          this.image.pixels[pixel] = this.backup.pixels[pixel];
        }
      }
    }
  }

  ////////////////////////////////////// SORTING FUNCTIONS //////////////////////////////////////
  public void processSortHorizontal() {
    this.image.loadPixels();
    this.preview.loadPixels();

    this.sortHorizontal();

    this.image.updatePixels();
    this.processPreview();
  }

  private void sortHorizontal() {
    for (int row = 0; row < image.height; row++) {
      for (int pixel = row * this.preview.width; pixel < (row+1) * this.preview.width; pixel++) {
        if (red(this.preview.pixels[pixel]) == 255) {
          int from = pixel;
          int to = from;
          while (to < (row+1) * this.preview.width && (red(this.preview.pixels[pixel]) == 255)) {
            to++;
            pixel++;
          }
          if (to - from > 1) {
            this.mergeSort(this.image.pixels, from, to);
          }
        }
      }
    }
  }

  public void processSortVertical() {
    this.image.loadPixels();
    this.preview.loadPixels();

    this.sortVertical();

    this.image.updatePixels();
    this.processPreview();
  }

  private void sortVertical() {
    for (int column = 0; column < this.preview.width; column++) {
      for (int pixel = column; pixel < this.preview.height * this.preview.width; pixel += this.preview.width) {
        if (red(this.preview.pixels[pixel]) == 255) {
          int from = pixel;
          int counter = 0;
          while (pixel < this.preview.height * this.preview.width && red(this.preview.pixels[pixel]) == 255) {
            verHelper[counter] = this.image.pixels[pixel];
            counter++;
            pixel += this.preview.width;
          }
          if (counter > 1) {
            this.mergeSort(this.verHelper, 0, counter);
            for (int i = 0; i< counter; i++) {
              this.image.pixels[from+(i*this.preview.width)] = verHelper[i];
            }
          }
        }
      }
    }
  }

  private void mergeSort(color[] tab, int start, int end) {
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
          if (comparePixels(tab[i], tab[j])) {
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


  ////////////////////////////////////// HELPER FUNCTIONS //////////////////////////////////////
  private boolean checkPixel(color col) {
    float check = this.getBrightness(col);
    return (check >= this.lowerLimit && check <= this.upperLimit);
  }

  private float getBrightness(color col) {
    switch(this.pixelCheckMode) {
    case LUMA: 
      return  0.587*(((float)(green(col))/255)) + 0.299 *(((float)(red(col))/255)) + 0.114*(((float)(blue(col))/255));

    case AVERAGE: 
      return (((float)(green(col)+red(col)+blue(col)))/255)/3;

    case HUE: 
      return (float)hue(col)/360;

    case SATURATION: 
      return (float)saturation(col)/255;

    case RED: 
      return (float)red(col)/255;

    case GREEN: 
      return (float)green(col)/255;

    case BLUE: 
      return (float)blue(col)/255;

    default:
      print("Something wrong in getBrightness, returning 0");
      return 0f;
    }
  }

  private float getBrightnessSort(color col) {
    switch(this.sortingMode) {
    case LUMA: 
      return  0.587*(((float)(green(col))/255)) + 0.299 *(((float)(red(col))/255)) + 0.114*(((float)(blue(col))/255));

    case AVERAGE: 
      return (((float)(green(col)+red(col)+blue(col)))/255)/3;

    case HUE: 
      return (float)hue(col)/360;

    case SATURATION: 
      return (float)saturation(col)/255;

    case RED: 
      return (float)red(col)/255;

    case GREEN: 
      return (float)green(col)/255;

    case BLUE: 
      return (float)blue(col)/255;

    default:
      print("Something wrong in getBrightness, returning 0");
      return 0f;
    }
  }

  private boolean comparePixels(color col1, color col2) {
    if (this.ascending) {
      return getBrightnessSort(col1) >= getBrightnessSort(col2);
    } else {
      return getBrightnessSort(col1) <= getBrightnessSort(col2);
    }
  }

  private void calculateNewImageSize(int imageWidth, int imageHeight) {
    float screenRatio = (float)width/(float)height;
    float imageRatio = (float)imageWidth/(float)imageHeight;
    if (imageRatio<=screenRatio) {
      this.newWidth = ((float)imageWidth/ (float)imageHeight) * height;
      this.wideCalc = false;
    } else {
      this.newHeight = ((float)imageHeight / (float)imageWidth) * width;
      this.wideCalc = true;
    }
  }

  public void ascDescChange(boolean value) {
    ascending = value;
  }

  public void setWorkSpace(workSpc space) {
    this.workSpace = space;
  }

  public float getLowerLimit() {
    return lowerLimit;
  }

  public float getUpperLimit() {
    return upperLimit;
  }

  public void setLowerLimit(float x) {
    lowerLimit = constrain(x, 0, upperLimit);
    processPreview();
  }

  public void setUpperLimit(float x) {
    upperLimit = constrain(x, lowerLimit, 1);
    processPreview();
  }

  public void setCheckMode(checkMode mode) {
    pixelCheckMode = mode;
    processPreview();
  }

  public void setSortingMode(checkMode mode) {
    sortingMode = mode;
    processPreview();
  }

  public int getImageWidth() {
    return this.image.width;
  }

  public int getImageHeight() {
    return this.image.height;
  }

  public boolean isSelectionActive() {
    return this.selectionActive;
  }

  public void showPreview() {
    this.showPreview = !this.showPreview;
  }

  public void saveImage(String path) {
    this.image.save(path);
  }
  
  public void setPreview() {
    this.showPreview = !this.showPreview;
  }
  
  public void setSelection() {
    this.selectionActive = !this.selectionActive;
  }
  
}