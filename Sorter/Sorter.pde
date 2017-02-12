import java.io.File;
PImage selected;
sceneContainer Scene;

void setup() {
  size(800, 600);
  frameRate(10);
  surface.setResizable(true);

  //Image selector
  selectInput("Select a file to process:", "fileSelected");
  while (selected == null) {
    delay(500); //Wait until the image is selected
  }
  
  Scene = new sceneContainer(selected, 0, 1, checkMode.AVERAGE);
  surface.setSize(Scene.image.width/2, Scene.image.height/2);
  //surface.setSize(0, constrain(Scene.image.height*2,displayHeight));
}

void draw() {
  
  Scene.display();
  textSize(32);
  fill(0);
  text("lower: "+nf(Scene.lowerLimit,1,2),10,32);
  text("upper: "+nf(Scene.upperLimit,1,2),10,64);
  text("Mode: "+ Scene.brightnessCheckMode.name(),10,96);
  text("Preview: "+Scene.showPreview,10,128);
  //Scene.image.save("after.jpg");
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    selected = loadImage(selection.getAbsolutePath());
  }
}

/*
public void mousePressed()
    {
        loadPixels();
        color temp = color(red(pixels[mouseX + mouseY * width]),green(pixels[mouseX + mouseY * width]),blue(pixels[mouseX + mouseY * width]));
       // println("Red: "+red(pixels[mouseX + mouseY * width]));
       // println("Green: "+green(pixels[mouseX + mouseY * width]));
        println(getBrightness(temp,Scene.brightnessCheckMode));
        println(hue(temp)/360);
        println();
    } */
    
public void keyPressed() {
   if (key == 'h') {
      Scene.sortHorizontal();
   }
   if (key == 'v') {
      Scene.sortVertical(); 
   }
   if (key == 'o') {
      Scene.setLowerLimit(Scene.lowerLimit-0.05);
      println("lowerLimit: ",Scene.lowerLimit);
      println();
   }
   if (key == 'p') {
      Scene.setLowerLimit(Scene.lowerLimit+0.05);
      println("lowerLimit: ",Scene.lowerLimit);
      println();
   }
   if (key == 'k') {
      Scene.setUpperLimit(Scene.upperLimit-0.05);
      println("upperLimit: ",Scene.upperLimit);
      println();
   }
   if (key == 'l') {
      Scene.setUpperLimit(Scene.upperLimit+0.05);
      println("upperLimit: ",Scene.upperLimit);
      println();
   }
   if (key == 'r') {
      Scene.resetImage(); 
   }
   if (key == 'm') {
      checkMode[] modes = checkMode.values();
      for(int i = 0; i<modes.length;i++) {
         if (modes[i] == Scene.brightnessCheckMode) {
            if (i == modes.length-1) {
               Scene.setMode(modes[0]); 
            } else {
               Scene.setMode(modes[i+1]); 
            }
            break;
         }
      }
   }
   if (key == 's') {
      Scene.image.save("Results/after.jpg");
   }
   if (key == 't') {
      Scene.setPreview();
   }
}