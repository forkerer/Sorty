class startMenu {
  ControlP5 cp5;
  Button loadImage;
  Button exit;
  
  startMenu(ControlP5 control) {
    cp5 = control;
    
    loadImage = cp5.addButton("imageLoad")
      .setPosition(width/2 - 180, height/2 - 30)
      .setSize(170,60)
      .plugTo(this);
      loadImage.getCaptionLabel().set("Select Image");
      
    exit = cp5.addButton("exitProgram")
      .setPosition(width/2+10,height/2 - 30)
      .setSize(170,60)
      .plugTo(this);
      exit.getCaptionLabel().set("Exit");
  }
  
  void exitProgram() {
    exit();
  }
  
  void imageLoad() {
    handleLoading();
    processMenu();
  }
}