startMenu startScreen;

ArrayList<PVector> selectedArea;
PImage selected;
boolean selector = false;

int y1 = 0, y2 = 0, x1 = 0, x2 = 0;
float newWidth;
float newHeight;
boolean wideCalc;


void settings() {
  fullScreen(P2D);
}

void setup() {
  textSize(32);
  selectedArea = new ArrayList<PVector>();
  frame.setAlwaysOnTop(false);
  startScreen = new startMenu(new ControlP5(this));
  frameRate(60);
}




/*
void draw() {
 background(#02182F);
 if (Scene != null) {
 Scene.display();
 }
 line(100, y1, 100, y2);/*
 if (!selectedArea.isEmpty()) {
 for (int i = 0; i <selectedArea.size()-1; i++) {
 line(calcScreenX((int)selectedArea.get(i).x), calcScreenY((int)selectedArea.get(i).y), calcScreenX((int)selectedArea.get(i+1).x), calcScreenY((int)selectedArea.get(i+1).y));
 }
 line(calcScreenX((int)selectedArea.get(selectedArea.size()-1).x), calcScreenY((int)selectedArea.get(selectedArea.size()-1).y), calcScreenX((int)selectedArea.get(0).x), calcScreenY((int)selectedArea.get(0).y));
 }*//*
  if ( control != null && control.showMenu) {
 fill(#02182F);
 beginShape();
 vertex(0, 0);
 vertex(220, 0);
 vertex(220, height);
 vertex(0, height);
 endShape();
 }
 fill(0);
 //outlineText("FPS: " + frameRate, 150, 32);
 }*/

void draw() {
  if (Scene == null) {
    if (startScreen != null) {
      background(0);
      fill(#02182F);
      beginShape();
      vertex(width/2 - 200, height/2 - 50);
      vertex(width/2 + 200, height/2 - 50);
      vertex(width/2 + 200, height/2 + 50);
      vertex(width/2 - 200, height/2 + 50);
      endShape();
    }
  } else {
    background(#02182F);
    Scene.display();

    if ( control != null && control.showMenu) {
      fill(#02182F);
      beginShape();
      vertex(0, 0);
      vertex(220, 0);
      vertex(220, height);
      vertex(0, height);
      endShape();
    }

    if (!selectedArea.isEmpty()) {
      if (wideCalc == false) {
        for (int i = 0; i <selectedArea.size()-1; i++) {
          line(
            calcScreenX((int)selectedArea.get(i).x), 
            selectedArea.get(i).y * height/Scene.image.height, 
            calcScreenX((int)selectedArea.get(i+1).x), 
            selectedArea.get(i+1).y * height/Scene.image.height);
        }
        line(
          calcScreenX((int)selectedArea.get(selectedArea.size()-1).x), 
          selectedArea.get(selectedArea.size()-1).y * height/Scene.image.height, 
          calcScreenX((int)selectedArea.get(0).x), 
          selectedArea.get(0).y * height/Scene.image.height);
      } else {
        for (int i = 0; i <selectedArea.size()-1; i++) {
          line(
            selectedArea.get(i).x * width / Scene.image.width, 
            calcScreenY((int)selectedArea.get(i).y), 
            selectedArea.get(i+1).x * width / Scene.image.width, 
            calcScreenY((int)selectedArea.get(i+1).y));
        }
        line(
          selectedArea.get(selectedArea.size()-1).x * width / Scene.image.width, 
          calcScreenY((int)selectedArea.get(selectedArea.size()-1).y), 
          selectedArea.get(0).x * width/ Scene.image.width, 
          calcScreenY((int)selectedArea.get(0).y));
      }
    }
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


public void mousePressed()
{
  if (Scene != null) {
    x1 = (int)((float)mouseX*((float)Scene.image.width/ (float)width));
    if (selector == true) {
      if (control.showMenu && mouseX < 220) return;
      if (wideCalc == false) {
        selectedArea.add(new PVector(calcImageX(mouseX), ((float)mouseY*((float)Scene.image.height/ (float)height))));
      } else {
        selectedArea.add(new PVector(((float)mouseX * ((float)Scene.image.width / (float)width)), calcImageY(mouseY)));
      }
      Scene.calcSelectionPreview(selectedArea);
    }
  }
} 

public void mouseReleased()
{
  // x2 = (int)((float)mouseX*((float)Scene.image.width/ (float)width));
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
  

   if (key == 'r') {
   Scene.resetImage();
   }


   
  if (key == 's') {
    Scene.image.save("Results/after.jpg");
  }/*
  if (key == 't') {
   Scene.setPreview();
   }*//*
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
  }*/

  if (key == 'u') {
    if (selector) {
      selectedArea.clear();
    }
    selector = !selector;
  }
}