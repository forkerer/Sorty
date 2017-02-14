sceneContainer Scene;
controlGUI control;

void handleLoading() {
  selectInput("Select a iamge file to process:", "fileSelected");
  while (selected == null) {
    delay(1000); //Wait until the image is selected
    println(frameRate);
  }
  Scene = new sceneContainer(selected, 0, 1, checkMode.AVERAGE);
  calculateImageSize(Scene.image.width,Scene.image.height);
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    selected = loadImage(selection.getAbsolutePath());
  }
}

void processMenu() {
    control = new controlGUI(new ControlP5(this));
    startScreen.cp5.setVisible(false);
    startScreen = null;
}

void calculateImageSize(int imageWidth, int imageHeight) {
   float screenRatio = (float)width/(float)height;
   float imageRatio = (float)imageWidth/(float)imageHeight;
   if (imageRatio<=screenRatio) {
     newWidth = ((float)imageWidth/ (float)imageHeight) * height;
     wideCalc = false;
   } else {
     newHeight = ((float)imageHeight / (float)imageWidth) * width;
     wideCalc = true;
   }
}