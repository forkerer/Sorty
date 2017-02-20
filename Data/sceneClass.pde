enum workSpc {
  ALL, ALLNOSELECTION, SELECTION
}

enum checkMode {
  LUMA, AVERAGE, HUE, SATURATION, RED, GREEN, BLUE
}

enum saveFormat {
  JPG, TIF, PNG, TGA, GIF
}

public class sceneContainer {
  private PApplet parent;
  protected PImage[] image;
  private PImage[] preview;
  private PImage[] backup;
  private float lowerLimit;  //lower limit of sorting
  private float upperLimit;  //upper limit of sorting
  private boolean ascending;  //Decides if sorting should be ascending or descending
  private color[] sortTab;  //Table used for iterative MergeSort
  private color[] verHelper;  //Used as temporary row(so columns can be sorted like rows)  verticalHelper
  private boolean showPreview;
  private boolean selectionActive;
  private boolean isGif;
  private boolean isPaused;
  public int counter;
  public int[] delays;
  public gifSyncer syncer;
  private changeHistory history;

  private checkMode pixelCheckMode;  //used to decide what should be sorted
  private checkMode sortingMode;  //used to decide by what should the image be sorted
  private workSpc workSpace;  //used to decide what part of the image is affected by actions
  private saveFormat format; //Decides what format file will be saved in

  public float newWidth;
  public float newHeight;
  public boolean wideCalc;
  public selection selectedArea;


  ////////////////////////////////////// CONSTRUCTOR //////////////////////////////////////
  sceneContainer(PImage[] sourceImg, float lower, float upper, checkMode mode, PApplet p, int[] Delays) {
    this.delays = Delays;
    this.parent = p;
    this.isGif = sourceImg.length == 1 ? false : true;

    this.history = new changeHistory(this.isGif);

    this.image = new PImage[sourceImg.length];
    this.backup = new PImage[sourceImg.length];
    this.preview = new PImage[sourceImg.length];

    for (int i = 0; i<sourceImg.length; i++) {
      this.image[i] = sourceImg[i].get();
      this.backup[i] = sourceImg[i].get();
      this.preview[i] = sourceImg[i].get();
    }

    this.lowerLimit = lower;
    this.upperLimit = upper;
    this.counter = 0;

    this.pixelCheckMode = mode;
    this.sortingMode = mode;
    this.workSpace = workSpc.ALL;

    sourceImg[0].loadPixels();
    this.verHelper = new color[sourceImg[0].height];
    this.sortTab = new color[sourceImg[0].pixels.length];
    this.selectedArea = new selection();

    this.showPreview = false;
    this.ascending = true;
    this.selectionActive = false;


    this.processPreview();
    this.calculateNewImageSize(sourceImg[0].width, sourceImg[0].height);
    if (isGif) {
      format = saveFormat.GIF;
      this.isPaused = false;
      //thread("gifSyncer");
      syncer = new gifSyncer();
      Thread syncThread = new Thread(syncer);
      syncThread.start();
    } else {
      format = saveFormat.JPG;
    }
  }

  ////////////////////////////////////// DISPLAY THIS WHOLE THING //////////////////////////////////////
  public void display() {
    fill(0);
    noStroke();
    beginShape();

    if (showPreview == true) { 
      texture(this.preview[counter]);
    } else {
      texture(this.image[counter]);
    }

    if (wideCalc == false) {
      vertex((width-newWidth)/2, 0, 0, 0);
      vertex((width-newWidth)/2+newWidth, 0, image[0].width, 0);
      vertex((width-newWidth)/2+newWidth, height, image[0].width, image[0].height);
      vertex((width-newWidth)/2, height, 0, image[0].height);
    } else {
      vertex(0, (height-newHeight)/2, 0, 0);
      vertex(width, (height-newHeight)/2, image[0].width, 0);
      vertex(width, (height-newHeight)/2 + newHeight, image[0].width, image[0].height);
      vertex(0, (height-newHeight)/2 + newHeight, 0, image[0].height);
    }

    endShape();
    //if (!isPaused) {
    //if (counterDelay >= counterDelayLimit) {
    // counter = (counter+1)%this.image.length;
    // counterDelay=0;
    //} else {
    //  counterDelay++;
    //}
    //}
  }
  ////////////////////////////////////// PREVIEW FUNCTIONS //////////////////////////////////////
  public void processPreview() {
    for (int i = 0; i<image.length; i++) {
      this.image[i].loadPixels();
      this.preview[i].loadPixels();

      switch(this.workSpace) {
      case ALL: 
        this.calcPreview(i);
        break;
      case SELECTION:
        if (this.selectedArea.polygon.size() > 2) {
          this.calcSelectionPreview(i);
        } else {
          this.calcPreview(i);
        }
        break;
      case ALLNOSELECTION:
        if (this.selectedArea.polygon.size() > 2) {
          this.calcNoSelectionPreview(i);
        } else {
          this.calcPreview(i);
        }
        break;
      }
      this.preview[i].updatePixels();
    }
  }

  private void calcPreview(int index) {
    for (int row = 0; row < this.preview[index].height; row++) {
      for (int pixel = row * this.preview[index].width; pixel < (row+1) * this.preview[index].width; pixel++) {
        if (checkPixel(this.image[index].pixels[pixel])) {
          this.preview[index].pixels[pixel] = 0xFFFFFFFF;
        } else {
          this.preview[index].pixels[pixel] = 0xFF000000;
        }
      }
    }
  }

  private void calcNoSelectionPreview(int index) {
    for (int row = 0; row < this.preview[index].height; row++) {
      for (int pixel = row * this.preview[index].width; pixel < (row+1) * this.preview[index].width; pixel++) {
        if (checkPixel(this.image[index].pixels[pixel]) && !this.selectedArea.pointIsInPoly(pixel - row * this.preview[index].width, row)) {
          this.preview[index].pixels[pixel] = 0xFFFFFFFF;
        } else {
          this.preview[index].pixels[pixel] = 0xFF000000;
        }
      }
    }
  }

  private void calcSelectionPreview(int index) {
    for (int row = 0; row < this.preview[index].height; row++) {
      for (int pixel = row * this.preview[index].width; pixel < (row+1) * this.preview[index].width; pixel++) {
        if (checkPixel(this.image[index].pixels[pixel]) && this.selectedArea.pointIsInPoly(pixel - row * this.preview[index].width, row)) {
          this.preview[index].pixels[pixel] = 0xFFFFFFFF;
        } else {
          this.preview[index].pixels[pixel] = 0xFF000000;
        }
      }
    }
  }

  ////////////////////////////////////// RESET FUNCTIONS //////////////////////////////////////
  public void processReset() {
    this.history.addToUndoHistory(image); //add current image to undo history
    this.history.clearRedoHistory();

    for (int i = 0; i<image.length; i++) {
      this.image[i].loadPixels();
      this.preview[i].loadPixels();
      this.backup[i].loadPixels();

      switch(this.workSpace) {
      case ALL: 
        this.resetImage(i);
        break;
      case SELECTION:
        if (this.selectedArea.polygon.size() > 2) {
          this.resetImageWithSelection(i);
        } else {
          this.resetImage(i);
        }
        break;
      case ALLNOSELECTION:
        if (this.selectedArea.polygon.size() > 2) {
          this.resetImageWithSelection(i);
        } else {
          this.resetImage(i);
        }
        break;
      }
      this.image[i].updatePixels();
    }
    this.processPreview();
  }

  private void resetImage(int index) {
    this.image[index] = this.backup[index].get();
  }

  private void resetImageWithSelection(int index) {
    for (int row = 0; row < this.preview[index].height; row++) {
      for (int pixel = row * this.preview[index].width; pixel < (row+1) * this.preview[index].width; pixel++) {
        if (red(this.preview[index].pixels[pixel]) == 255) {
          this.image[index].pixels[pixel] = this.backup[index].pixels[pixel];
        }
      }
    }
  }

  ////////////////////////////////////// SORTING FUNCTIONS //////////////////////////////////////
  public void processSortHorizontal() {
    this.history.addToUndoHistory(image); //add current image to undo history
    this.history.clearRedoHistory();

    for (int i = 0; i < image.length; i++) {
      this.image[i].loadPixels();
      this.preview[i].loadPixels();

      this.sortHorizontal(i);
      this.image[i].updatePixels();
    }
    this.processPreview();
  }

  private void sortHorizontal(int index) {
    for (int row = 0; row < image[index].height; row++) {
      for (int pixel = row * this.preview[index].width; pixel < (row+1) * this.preview[index].width; pixel++) {
        if (red(this.preview[index].pixels[pixel]) == 255) {
          int from = pixel;
          int to = from;
          while (to < (row+1) * this.preview[index].width && (red(this.preview[index].pixels[pixel]) == 255)) {
            to++;
            pixel++;
          }
          if (to - from > 1) {
            this.mergeSort(this.image[index].pixels, from, to);
          }
        }
      }
    }
  }

  public void processSortVertical() {
    this.history.addToUndoHistory(image); //add current image to undo history
    this.history.clearRedoHistory();

    for (int i = 0; i< image.length; i++) {
      this.image[i].loadPixels();
      this.preview[i].loadPixels();
      this.sortVertical(i);
      this.image[i].updatePixels();
    }
    this.processPreview();
  }

  private void sortVertical(int index) {
    for (int column = 0; column < this.preview[index].width; column++) {
      for (int pixel = column; pixel < this.preview[index].height * this.preview[index].width; pixel += this.preview[index].width) {
        if (red(this.preview[index].pixels[pixel]) == 255) {
          int from = pixel;
          int counter = 0;
          while (pixel < this.preview[index].height * this.preview[index].width && red(this.preview[index].pixels[pixel]) == 255) {
            verHelper[counter] = this.image[index].pixels[pixel];
            counter++;
            pixel += this.preview[index].width;
          }
          if (counter > 1) {
            this.mergeSort(this.verHelper, 0, counter);
            for (int i = 0; i< counter; i++) {
              this.image[index].pixels[from+(i*this.preview[index].width)] = verHelper[i];
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
          if (comparePixels(tab[i], tab[j])) {
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
    return this.image[0].width;
  }

  public int getImageHeight() {
    return this.image[0].height;
  }

  public boolean isSelectionActive() {
    return this.selectionActive;
  }

  public void showPreview() {
    this.showPreview = !this.showPreview;
  }

  public void setPreview() {
    this.showPreview = !this.showPreview;
  }

  public void setSelection() {
    this.selectionActive = !this.selectionActive;
  }

  public void undoAction() {
    this.history.undoChange(this.image);
  }

  public void redoAction() {
    this.history.redoChange(this.image);
  }

  public void setSaveFormat(saveFormat mode) {
    this.format = mode;
  }

  public void pauseGIF() {
    this.isPaused = !isPaused;
  }

  public void saveImage(String path) {
    //this.image[0].save("Results/"+path);
    if (this.isGif) {
      if (this.format == saveFormat.GIF) {
        GifMaker gifExport = new GifMaker(this.parent, "Results/"+path+"."+format.name().toLowerCase());
        gifExport.setRepeat(0);
        //gifExport.setTransparent(0, 0, 0);
        for (int i = 0; i<image.length; i++) {
          gifExport.setDelay(delays[i]);
          gifExport.addFrame(this.image[i]);
        }
        gifExport.finish();
      } else {
        for (int i = 0; i<image.length; i++) {
          this.image[i].save("Results/"+path+"_"+i+"."+format.name().toLowerCase());
        }
      }
    } else {
      this.image[0].save("Results/"+path+"."+format.name().toLowerCase());
    }
  }
}