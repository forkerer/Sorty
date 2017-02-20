import gifAnimation.*;
import controlP5.*;
import java.util.*;

enum programState {
  LOADING, READYTODISPLAY
}

sceneContainer Scene;
controlGUI Control;
gifControl gifGui;
boolean loadingFinished;
programState state;

PImage[] selectedImages;
String selectedPath = "data\\loadingException.png";
PImage logo;
public float guiScale;

void settings() {
  fullScreen(P2D);
}

void setup() {
  surface.setAlwaysOnTop(false);
  loadingFinished = false;
  guiScale = (float)height/(float)1080;
  textSize(32);
  frameRate(60);
  state = programState.LOADING;

  logo = loadImage("data\\name.png"); //Splash screen image
  Control = new controlGUI(new ControlP5(this));
  Control.showMenu = false;
  Control.cp5.setVisible(false);

  gifGui = new gifControl(new ControlP5(this));
  gifGui.showMenu = false;
  gifGui.cp5.setVisible(false);
  try {
    selectedPath = args[0]; //sent via starter.bat
  } 
  catch (NullPointerException exc) {
    println("coszle");
  }
  thread("handleLoading"); //Load images in separate thread, allowing the splash screen to show up
}

void draw() {
  switch(state) {
  case LOADING:
    background(#02182F);
    beginShape();
    noStroke();
    texture(logo);
    vertex(width/2 - 200, height/2 - 50, 0, 0);
    vertex(width/2 + 200, height/2 - 50, logo.width, 0);
    vertex(width/2 + 200, height/2 + 50, logo.width, logo.height);
    vertex(width/2 - 200, height/2 + 50, 0, logo.height);
    endShape();
    break;
  case READYTODISPLAY:
    background(#02182F);
    Scene.display();
    stroke(#000000);

    if (Control != null && Control.showMenu) {
      fill(#02182F, 210);
      beginShape();
      vertex(0, 0);
      vertex(220*guiScale, 0);
      vertex(220*guiScale, height);
      vertex(0, height);
      endShape();
    }
    if (gifGui != null && gifGui.showMenu) {
      fill(#02182F, 210);
      beginShape();
      vertex(width-(220*guiScale), 0);
      vertex(width, 0);
      vertex(width, height);
      vertex(width - (220*guiScale), height);
      endShape();
    }
    Scene.selectedArea.display();
  }
}

public void mousePressed()
{
  if (Scene != null) {
    if (Scene.isSelectionActive() == true) {
      if (Control.showMenu && mouseX < 220) return;
      Scene.selectedArea.addPoint(mouseX, mouseY);
    }
  }
} 

public void keyPressed() {
  if ((key == 'h' || key =='H' ) && !Control.saveName.isFocus()) {
    Scene.processSortHorizontal();
  }
  if ((key == 'v' || key =='V' ) && !Control.saveName.isFocus()) {
    Scene.processSortVertical();
  }

  if ((key == 'o' || key =='O' ) && !Control.saveName.isFocus()) {
    Scene.undoAction();
  }
  
  if ((key == 'p' || key =='P' ) && !Control.saveName.isFocus()) {
    Scene.redoAction();
  }

  if ((key == 'm' || key =='M' ) && !Control.saveName.isFocus()) {
    if (Control != null) {
      if (Control.showMenu == true) {
        Control.showMenu = false;
        Control.cp5.setVisible(false);
      } else {
        Control.showMenu = true;
        Control.cp5.setVisible(true);
      }
    }
    if (gifGui != null && Scene != null) {
      if (Scene.isGif) {
        if (gifGui.showMenu == true) {
          gifGui.showMenu = false;
          gifGui.cp5.setVisible(false);
        } else {
          gifGui.showMenu = true;
          gifGui.cp5.setVisible(true);
        }
      }
    }
  }

  if ((key == 'r' || key =='R' ) && !Control.saveName.isFocus()) {
    Scene.processReset();
  }
}

void handleLoading() {
  int[] Delays = null;
  int avgDelay = 1;
  if (selectedPath.charAt(selectedPath.length()-3) == 'g' &&
    selectedPath.charAt(selectedPath.length()-2) == 'i' &&
    selectedPath.charAt(selectedPath.length()-1) == 'f') {
    
    Gif selectedGif =  new Gif(this, selectedPath);
    selectedImages = selectedGif.getPImages();
    Delays = selectedGif.getDelaysArray();
    if (gifGui != null) {
      gifGui.cp5.setVisible(true);
      gifGui.showMenu = true;
    }
  } else {
    selectedImages = new PImage[1];
    selectedImages[0] = loadImage(selectedPath);
  }
  Scene = new sceneContainer(selectedImages, 0, 1, checkMode.AVERAGE, this, Delays);
  Control.showMenu = true;
  Control.cp5.setVisible(true);
  state = programState.READYTODISPLAY;
}