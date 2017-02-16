sceneContainer Scene;
controlGUI Control;

PImage selectedImage;

void settings() {
  fullScreen(P2D);
}

void setup() {
  surface.setAlwaysOnTop(false);
  textSize(32);
  frameRate(60);
  selectedImage = loadImage(args[0]);
  Scene = new sceneContainer(selectedImage, 0, 1, checkMode.AVERAGE);
  Control = new controlGUI(new ControlP5(this));
}

void draw() {
  if (Scene == null) {
    background(0);
    fill(#02182F);
    beginShape();
    vertex(width/2 - 200, height/2 - 50);
    vertex(width/2 + 200, height/2 - 50);
    vertex(width/2 + 200, height/2 + 50);
    vertex(width/2 - 200, height/2 + 50);
    endShape();
    fill(255);
    textAlign(CENTER);
    text("LOADING", width/2, height/2);
  } else {
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
  if (key == 'h' && !Control.saveName.isFocus()) {
    Scene.processSortHorizontal();
  }
  if (key == 'v' && !Control.saveName.isFocus()) {
    Scene.processSortVertical();
  }
  
   if (key == 'm' && !Control.saveName.isFocus()) {
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
  
  if (key == 'r' && !Control.saveName.isFocus()) {
   Scene.processReset();
   }
   
   if (key == 's' && !Control.saveName.isFocus()) {
    Scene.saveImage("Results/after.jpg");
  }
}