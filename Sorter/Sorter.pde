PImage selected;
sceneContainer Scene;
int y1 = 0, y2 = 0, x1 = 0, x2 = 0;
ArrayList<PVector> selectedArea;
boolean selector = false;
float newWidth;
controlGUI control;

void settings() {
  fullScreen(P2D);
}

void setup() {
  textSize(32);
  selectedArea = new ArrayList<PVector>();
  handleLoading();
  processMenu();
  frameRate(60);
}

void handleLoading() {
  selectInput("Select a file to process:", "fileSelected");
  while (selected == null) {
    delay(1000); //Wait until the image is selected
    println(frameRate);
  }
  Scene = new sceneContainer(selected, 0, 1, checkMode.AVERAGE);
  newWidth = ((float)Scene.image.width / (float)Scene.image.height) * height;
}

void processMenu() {
    control = new controlGUI(new ControlP5(this));
}

void draw() {
  background(#02182F);
  if (Scene != null) {
    Scene.display();
  }
  line(100, y1, 100, y2);
  if (!selectedArea.isEmpty()) {
    for (int i = 0; i <selectedArea.size()-1; i++) {
      line(calcScreenX((int)selectedArea.get(i).x), calcScreenY((int)selectedArea.get(i).y), calcScreenX((int)selectedArea.get(i+1).x), calcScreenY((int)selectedArea.get(i+1).y));
    }
    line(calcScreenX((int)selectedArea.get(selectedArea.size()-1).x), calcScreenY((int)selectedArea.get(selectedArea.size()-1).y), calcScreenX((int)selectedArea.get(0).x), calcScreenY((int)selectedArea.get(0).y));
  }
  if ( control != null && control.showMenu) {
    fill(#02182F);
    beginShape();
    vertex(0,0);
    vertex(220,0);
    vertex(220,height);
    vertex(0,height);
    endShape();
  }
  fill(0);
  outlineText("FPS: " + frameRate, 150, 32);
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    selected = loadImage(selection.getAbsolutePath());
  }
}

void outlineText(String message, int x, int y) {
  fill(0);
  text(message, x-1, y);
  text(message, x+1, y);
  text(message, x, y-1);
  text(message, x, y+1);
  fill(255);
  text(message, x, y);
}

public void Preview() {
  Scene.setPreview();
}
public void mousePressed()
{
  x1 = (int)((float)mouseX*((float)Scene.image.width/ (float)width));
  if (selector == true) {
    selectedArea.add(new PVector(calcImageX(mouseX), ((float)mouseY*((float)Scene.image.height/ (float)height))));
  }
} 

public void mouseReleased()
{
  x2 = (int)((float)mouseX*((float)Scene.image.width/ (float)width));
} 

int calcImageX(int x) {
  //float newWidth = ((float)Scene.image.width / (float)Scene.image.height) * height;
  float result = (x-(width-newWidth)/2)*((float)Scene.image.width/newWidth);
  return (int)result;
}

int calcScreenX(int x) {
  //float newWidth = ((float)Scene.image.width / (float)Scene.image.height) * height;
  float result = (x* (newWidth / (float)Scene.image.width))+((width-newWidth)/2);
  return (int)result;
}

int calcScreenY(int y) {
  return (int)(y*((float)height/ (float)Scene.image.height));
}

public void keyPressed() {
  if (key == 'h') {
    if (selector) {
      Scene.sortSelectionHorizontal();
    } else {
      Scene.sortHorizontal();
    }
  }
  if (key == 'v') {
    if (selector) {
      Scene.sortSelectionVertical();
    } else {
      Scene.sortVertical();
    }
  }
  
  if (key == 'm') {
     if (control != null) {
        if (control.showMenu == true) {
           control.showMenu = false;
           control.cp5.setVisible(false);
        } else {
           control.showMenu = true;
           control.cp5.setVisible(true);
        }
     }
  }
  /*
  if (key == 'k') {
    Scene.setUpperLimit(Scene.upperLimit-0.05);
    println();
  }
  if (key == 'l') {
    Scene.setUpperLimit(Scene.upperLimit+0.05);
    println();
  }
  if (key == 'r') {
    Scene.resetImage();
  }
  if (key == 'm') {
    checkMode[] modes = checkMode.values();
    for (int i = 0; i<modes.length; i++) {
      if (modes[i] == Scene.pixelCheckMode) {
        if (i == modes.length-1) {
          Scene.setCheckMode(modes[0]);
        } else {
          Scene.setCheckMode(modes[i+1]);
        }
        break;
      }
    }
  }
  if (key == 'n') {
    checkMode[] modes = checkMode.values();
    for (int i = 0; i<modes.length; i++) {
      if (modes[i] == Scene.sortingMode) {
        if (i == modes.length-1) {
          Scene.setSortingMode(modes[0]);
        } else {
          Scene.setSortingMode(modes[i+1]);
        }
        break;
      }
    }
  }*/
  if (key == 's') {
    Scene.image.save("Results/after.jpg");
  }/*
  if (key == 't') {
    Scene.setPreview();
  }*/
  if (keyCode == '1') {
    y1= (int)((float)mouseY*((float)Scene.image.height/ (float)height));
    if (y1 > y2) {
      int temp = y1;
      y1 = y2;
      y2 = temp;
    }
  }
  if (keyCode == '2') {
    y2= (int)((float)mouseY*((float)Scene.image.height/ (float)height));
    if (y1 > y2) {
      int temp = y1;
      y1 = y2;
      y2 = temp;
    }
  }
  if (key == 'x') {
    Scene.offsetX(x2-x1, y1, y2);
    println(y1, " : ", y2);
  }

  if (key == 'u') {
    if (selector) {
      selectedArea.clear();
    }
    selector = !selector;
  }
}