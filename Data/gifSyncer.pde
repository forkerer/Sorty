public class gifSyncer implements Runnable {
  private int stepCounter = 0;
  private boolean isPaused = false;

  public void run() {
    while (true) {
      Scene.counter = stepCounter;
      delay(Scene.delays[stepCounter]);
      if (!this.isPaused) {
        stepCounter = (stepCounter+1)%Scene.image.length;
      }
    }
  }
  
  public void incrementCounter() {
    this.stepCounter = (stepCounter+1)%Scene.image.length;
  }
  
  public void decrementCounter() {
     if (this.stepCounter > 0) {
      this.stepCounter = (stepCounter-1)%Scene.image.length;
    } else {
      this.stepCounter = Scene.image.length-1;
    } 
  }
  
  public void pauseGIF() {
     this.isPaused = !this.isPaused; 
  }
}