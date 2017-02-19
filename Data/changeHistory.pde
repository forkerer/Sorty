public class changeHistory {
  private Deque<PImage> undoHistoryImage;
  private Deque<PImage> redoHistoryImage;
  private Deque<PImage[]> undoHistoryGIF;
  private Deque<PImage[]> redoHistoryGIF;
  private static final int changeHistoryMaxSizeImage = 10;
  private static final int changeHistoryMaxSizeGIF = 1;
  private boolean isGif;

  changeHistory(boolean isThisGif) {
    if (!isThisGif) {
      this.undoHistoryImage = new LinkedList();
      this.redoHistoryImage = new LinkedList();
    } else {
      this.undoHistoryGIF = new LinkedList();
      this.redoHistoryGIF = new LinkedList();
    }
    this.isGif = isThisGif;
  }

  void addToUndoHistory(PImage[] img) {
    if (this.isGif) {
      this.undoHistoryGIF.addLast(new PImage[img.length]);
      for (int i = 0; i<img.length; i++) {
        this.undoHistoryGIF.getLast()[i] = img[i].get();
      }
      if (this.undoHistoryGIF.size() == changeHistoryMaxSizeGIF+1) {
        this.undoHistoryGIF.removeFirst();
      }
    } else {
      this.undoHistoryImage.addLast(img[0].get());
      if (this.undoHistoryImage.size() == changeHistoryMaxSizeImage+1) {
        this.undoHistoryImage.removeFirst();
      }
    }
  }

  void addToRedoHistory(PImage[] img) {
    if (this.isGif) {
      this.redoHistoryGIF.addLast(new PImage[img.length]);
      for (int i = 0; i<img.length; i++) {
        this.redoHistoryGIF.getLast()[i] = img[i].get();
      }
      if (this.redoHistoryGIF.size() == changeHistoryMaxSizeGIF+1) {
        this.redoHistoryGIF.removeFirst();
      }
    } else {
      this.redoHistoryImage.addLast(img[0].get());
      if (this.redoHistoryImage.size() == changeHistoryMaxSizeImage+1) {
        this.redoHistoryImage.removeFirst();
      }
    }
  }

  void undoChange(PImage[] img) {
    if (this.isGif) {
      if (this.undoHistoryGIF.size() > 0) {
        this.addToRedoHistory(img);
        //img = this.undoHistoryGIF.removeLast().clone();
        for (int i = 0; i<img.length; i++) {
          img[i] = this.undoHistoryGIF.getLast()[i].get();
        }
        this.undoHistoryGIF.removeLast();
        Scene.processPreview();
      }
    } else {
      if (this.undoHistoryImage.size() > 0) {
        this.addToRedoHistory(img);
        img[0] = this.undoHistoryImage.removeLast().get();
        Scene.processPreview();
      }
    }
  }

  void redoChange(PImage[] img) {
    if (this.isGif) {
      if (redoHistoryGIF.size() > 0) {
        addToUndoHistory(img);
        //img = redoHistoryGIF.removeLast().clone();
        for (int i = 0; i<img.length; i++) {
          img[i] = this.redoHistoryGIF.getLast()[i].get();
        }
        this.redoHistoryGIF.removeLast();
        Scene.processPreview();
      }
    } else {
      if (redoHistoryImage.size() > 0) {
        addToUndoHistory(img);
        img[0] = redoHistoryImage.removeLast().get();
        Scene.processPreview();
      }
    }
  }

  void clearRedoHistory() {
    if (this.isGif) {
      this.redoHistoryGIF.clear();
    } else {
      this.redoHistoryImage.clear();
    }
  }
}