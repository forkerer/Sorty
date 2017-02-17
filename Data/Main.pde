import gifAnimation.*;
import controlP5.*;

enum programState {
  LOADING, READYTODISPLAY
}

sceneContainer Scene;
controlGUI Control;
boolean loadingFinished;
programState state;

PImage[] selectedImages;
String selectedPath;// = "D:\\Development\\gifsexamples\\avo5CE2.gif";
PImage logo;

void settings() {
  fullScreen(P2D);
}

void setup() {
  surface.setAlwaysOnTop(false);
  loadingFinished = false;
  textSize(32);
  frameRate(60);
  state = programState.LOADING;

  logo = loadImage("data\\name.png"); //Splash screen image
  Control = new controlGUI(new ControlP5(this));
  Control.showMenu = false;
  Control.cp5.setVisible(false);


  selectedPath = args[0]; //sent via starter.bat
  thread("handleLoading"); //Load images in separate thread, allowing the splash screen to show up
  //handleLoading();
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
    
    if (Control != null && Control.showMenu) {
      fill(#02182F);
      beginShape();
      vertex(0, 0);
      vertex(220, 0);
      vertex(220, height);
      vertex(0, height);
      endShape();
    }

    if (!Scene.selectedArea.isEmpty()) {
      stroke(#000000);
      if (Scene.wideCalc == false) {
        for (int i = 0; i <Scene.selectedArea.size()-1; i++) {
          line(
            calcScreenX((int)Scene.selectedArea.get(i).x), 
            Scene.selectedArea.get(i).y * height/Scene.getImageHeight(), 
            calcScreenX((int)Scene.selectedArea.get(i+1).x), 
            Scene.selectedArea.get(i+1).y * height/Scene.getImageHeight());
        }
        line(
          calcScreenX((int)Scene.selectedArea.get(Scene.selectedArea.size()-1).x), 
          Scene.selectedArea.get(Scene.selectedArea.size()-1).y * height/Scene.getImageHeight(), 
          calcScreenX((int)Scene.selectedArea.get(0).x), 
          Scene.selectedArea.get(0).y * height/Scene.getImageHeight());
      } else {
        for (int i = 0; i <Scene.selectedArea.size()-1; i++) {
          line(
            Scene.selectedArea.get(i).x * width / Scene.getImageWidth(), 
            calcScreenY((int)Scene.selectedArea.get(i).y), 
            Scene.selectedArea.get(i+1).x * width / Scene.getImageWidth(), 
            calcScreenY((int)Scene.selectedArea.get(i+1).y));
        }
        line(
          Scene.selectedArea.get(Scene.selectedArea.size()-1).x * width / Scene.getImageWidth(), 
          calcScreenY((int)Scene.selectedArea.get(Scene.selectedArea.size()-1).y), 
          Scene.selectedArea.get(0).x * width/ Scene.getImageWidth(), 
          calcScreenY((int)Scene.selectedArea.get(0).y));
      }
    }
    break;
  }
}
/*
void draw() {
 if ( Scene == null) {
 } else {
 background(#02182F);
 Scene.display();
 fill(255);
 text(Scene.isGif+"", 300, 300);
 
 if (Control != null && Control.showMenu) {
 fill(#02182F);
 beginShape();
 vertex(0, 0);
 vertex(220, 0);
 vertex(220, height);
 vertex(0, height);
 endShape();
 }
 
 if (!Scene.selectedArea.isEmpty()) {
 if (Scene.wideCalc == false) {
 for (int i = 0; i <Scene.selectedArea.size()-1; i++) {
 line(
 calcScreenX((int)Scene.selectedArea.get(i).x), 
 Scene.selectedArea.get(i).y * height/Scene.getImageHeight(), 
 calcScreenX((int)Scene.selectedArea.get(i+1).x), 
 Scene.selectedArea.get(i+1).y * height/Scene.getImageHeight());
 }
 line(
 calcScreenX((int)Scene.selectedArea.get(Scene.selectedArea.size()-1).x), 
 Scene.selectedArea.get(Scene.selectedArea.size()-1).y * height/Scene.getImageHeight(), 
 calcScreenX((int)Scene.selectedArea.get(0).x), 
 Scene.selectedArea.get(0).y * height/Scene.getImageHeight());
 } else {
 for (int i = 0; i <Scene.selectedArea.size()-1; i++) {
 line(
 Scene.selectedArea.get(i).x * width / Scene.getImageWidth(), 
 calcScreenY((int)Scene.selectedArea.get(i).y), 
 Scene.selectedArea.get(i+1).x * width / Scene.getImageWidth(), 
 calcScreenY((int)Scene.selectedArea.get(i+1).y));
 }
 line(
 Scene.selectedArea.get(Scene.selectedArea.size()-1).x * width / Scene.getImageWidth(), 
 calcScreenY((int)Scene.selectedArea.get(Scene.selectedArea.size()-1).y), 
 Scene.selectedArea.get(0).x * width/ Scene.getImageWidth(), 
 calcScreenY((int)Scene.selectedArea.get(0).y));
 }
 }
 }
 }
 */
public void mousePressed()
{
  if (Scene != null) {
    if (Scene.isSelectionActive() == true) {
      if (Control.showMenu && mouseX < 220) return;
      if (Scene.wideCalc == false) {
        Scene.selectedArea.add(new PVector(calcImageX(mouseX), ((float)mouseY*((float)Scene.getImageHeight()/ (float)height))));
      } else {
        Scene.selectedArea.add(new PVector(((float)mouseX * ((float)Scene.getImageWidth() / (float)width)), calcImageY(mouseY)));
      }
      Scene.processPreview();
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
  }

  if ((key == 'r' || key =='R' ) && !Control.saveName.isFocus()) {
    Scene.processReset();
  }

  if ((key == 's' || key =='S' ) && !Control.saveName.isFocus()) {
    Scene.saveImage("Results/after.jpg");
  }
}

void handleLoading() {
  if (selectedPath.charAt(selectedPath.length()-3) == 'g' &&
    selectedPath.charAt(selectedPath.length()-2) == 'i' &&
    selectedPath.charAt(selectedPath.length()-1) == 'f') {
    selectedImages = Gif.getPImages(this, selectedPath);
  } else {
    selectedImages = new PImage[1];
    selectedImages[0] = loadImage(selectedPath);
  }
  Scene = new sceneContainer(selectedImages, 0, 1, checkMode.AVERAGE,this);
  Control.showMenu = true;
  Control.cp5.setVisible(true);
  state = programState.READYTODISPLAY;
}