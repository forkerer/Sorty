public class gifControl {
  private ControlP5 cp5;
  public boolean showMenu;

  private Button stepBack;
  private Button stepForward;
  private Button pause;

  gifControl(ControlP5 control) {
    cp5 = control;
    
    this.stepBack = cp5.addButton("stepBack")
      .setPosition(width-210, 10)
      .setSize(90, 50)
      .plugTo(this);
      
   this.stepForward = cp5.addButton("stepForward")
      .setPosition(width-100, 10)
      .setSize(90, 50)
      .plugTo(this);
      
   this.pause = cp5.addButton("pause")
      .setPosition(width-210, 85)
      .setSize(90, 50)
      .setSwitch(true)
      .plugTo(this);
  }
  
  public void pause(boolean theFlag) {
    Scene.syncer.pauseGIF();
  }
  
  public void stepBack() {
     Scene.syncer.decrementCounter(); 
  }
  
  public void stepForward() {
     Scene.syncer.incrementCounter(); 
  }
}