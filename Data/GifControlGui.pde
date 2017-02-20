public class gifControl {
  private ControlP5 cp5;
  public boolean showMenu;

  private Button stepBack;
  private Button stepForward;
  private Button pause;

  gifControl(ControlP5 control) {
    cp5 = control;
    
    this.stepBack = cp5.addButton("stepBack")
      .setPosition(width-(210*guiScale), 10*guiScale)
      .setSize((int)(90*guiScale), (int)(50*guiScale))
      .plugTo(this);
      
   this.stepForward = cp5.addButton("stepForward")
      .setPosition(width-(100*guiScale), 10*guiScale)
      .setSize((int)(90*guiScale), (int)(50*guiScale))
      .plugTo(this);
      
   this.pause = cp5.addButton("pause")
      .setPosition(width-(210*guiScale), 85*guiScale)
      .setSize((int)(90*guiScale), (int)(50*guiScale))
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