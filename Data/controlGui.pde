checkMode[] modes = checkMode.values();
saveFormat[] formats = saveFormat.values();

public class controlGUI {
  private ControlP5 cp5;
  private boolean showMenu;
  private Slider lowerLimitSlider;
  private Slider upperLimitSlider;
  private Button previewButton;
  private DropdownList checkMode;
  private DropdownList sortMode;
  private Toggle AscDesc;
  private Button sortHorizontal;
  private Button sortVertical;  
  private Button chgSelection;
  //RadioButton chgSelection;
  private Button delSelection;
  private RadioButton workSpace;
  private Button resetButton;
  private Button undoButton;

  private String IMGSavePath;
  private Textfield saveName;
  private Button saveButton;
  private DropdownList saveFormat;

  controlGUI(ControlP5 control) {
    cp5 = control;
    showMenu = true;
    

    lowerLimitSlider = cp5.addSlider("lowerLimit")
      .setPosition(10*guiScale, 50*guiScale)
      .setRange(0, 1)
      .setSize((int)(200*guiScale), (int)(50*guiScale))
      .setTriggerEvent(Slider.RELEASE)
      .plugTo(this);
    lowerLimitSlider.getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);

    upperLimitSlider = cp5.addSlider("upperLimit")
      .setPosition(10*guiScale, 125*guiScale)
      .setRange(0, 1)
      .setSize((int)(200*guiScale), (int)(50*guiScale))
      .setTriggerEvent(Slider.RELEASE)
      .setValue(1)
      .plugTo(this);
    upperLimitSlider.getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);

    previewButton = cp5.addButton("preview")
      .setPosition(10*guiScale, 200*guiScale)
      .setSize((int)(50*guiScale), (int)(50*guiScale))
      .setSwitch(true)
      .plugTo(this);
    previewButton.getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);

    AscDesc = cp5.addToggle("AscendingDescending")
      .setPosition(85*guiScale, 200*guiScale)
      .setSize((int)(125*guiScale), (int)(50*guiScale))
      .setMode(ControlP5.SWITCH)
      .setValue(true)
      .plugTo(this);
    AscDesc.getCaptionLabel().set("Ascending                  Descending");

    checkMode = cp5.addDropdownList("checkMode")
      .setPosition(10*guiScale, 275*guiScale)
      .setSize((int)(90*guiScale), (int)(180*guiScale))
      .setType(DropdownList.LIST)
      .plugTo(this);
    customize(checkMode);

    sortMode = cp5.addDropdownList("sortMode")
      .setPosition(120*guiScale, 275*guiScale)
      .setSize((int)(90*guiScale), (int)(180*guiScale))
      .setType(DropdownList.LIST)
      .plugTo(this);
    customize(sortMode);

    sortHorizontal = cp5.addButton("sortHor")
      .setPosition(10*guiScale, 470*guiScale)
      .setSize((int)(90*guiScale), (int)(50*guiScale))
      .plugTo(this);
    sortHorizontal.getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    sortHorizontal.getCaptionLabel().set("Sort  Horizontally");

    sortVertical = cp5.addButton("sortVer")
      .setPosition(120*guiScale, 470*guiScale)
      .setSize((int)(90*guiScale), (int)(50*guiScale))
      .plugTo(this);
    sortVertical.getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    sortVertical.getCaptionLabel().set("Sort  Vertically");

    chgSelection = cp5.addButton("chgSel")
      .setPosition(10*guiScale, 570*guiScale)
      .setSize((int)(90*guiScale), (int)(50*guiScale))
      .setSwitch(true)
      .plugTo(this);
    chgSelection.getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    chgSelection.getCaptionLabel().set("Add/Change  Selection");

    delSelection = cp5.addButton("delSel")
      .setPosition(120*guiScale, 570*guiScale)
      .setSize((int)(90*guiScale), (int)(50*guiScale))
      .plugTo(this);
    delSelection.getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    delSelection.getCaptionLabel().set("Delete  Selection");

    workSpace = cp5.addRadioButton("workSpc") 
      .setPosition(10*guiScale, 645*guiScale)
      .setSize((int)(50*guiScale), (int)(50*guiScale))
      .setItemsPerRow(3)
      .setSpacingColumn((int)(25*guiScale))
      .setSpacingRow((int)(10*guiScale))
      .setNoneSelectedAllowed(false)
      .addItem("All", 0)
      .addItem("All - Selection", 1)
      .addItem("Selection", 2)
      .plugTo(this);
    for (Toggle t : workSpace.getItems()) {
      t.getCaptionLabel().align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    }

    resetButton = cp5.addButton("reset")
      .setPosition(10*guiScale, 745*guiScale)
      .setSize((int)(90*guiScale), (int)(50*guiScale))
      .plugTo(this);
    resetButton.getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    
    undoButton = cp5.addButton("undo")
      .setPosition(120*guiScale, 745*guiScale)
      .setSize((int)(90*guiScale),(int)(50*guiScale))
      .plugTo(this);
    undoButton.getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);

    saveName = cp5.addTextfield("fileName") 
      .setPosition(10*guiScale, 845*guiScale)
      .setSize((int)(125*guiScale), (int)(30*guiScale))
      .setAutoClear(false)
      .plugTo(this);
    saveName.getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    saveName.getCaptionLabel().set("Filename and format");

    saveButton = cp5.addButton("save")
      .setPosition(160*guiScale, 845*guiScale)
      .setSize((int)(50*guiScale), (int)(30*guiScale))
      .plugTo(this);
    saveButton.getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    
    saveFormat = cp5.addDropdownList("saveFormat")
      .setPosition(10*guiScale, 900*guiScale)
      .setSize((int)(90*guiScale), (int)(140*guiScale))
      .setType(DropdownList.LIST)
      .plugTo(this);
    customizeFormat(saveFormat);
  }



  void customize(DropdownList dd) {
    dd.setItemHeight((int)(40*guiScale));
    dd.setBarHeight((int)(20*guiScale));
    for (int i = 0; i<modes.length; i++) {
      dd.addItem(modes[i].name(), i);
    }
  }
  
  void customizeFormat(DropdownList dd) {
    dd.setItemHeight((int)(40*guiScale));
    dd.setBarHeight((int)(20*guiScale));
    for (int i = 0; i<formats.length; i++) {
      dd.addItem(formats[i].name(), i);
    }
  }

  void updateSliders() {
    //lowerLimitSlider.setMax(Scene.getUpperLimit());
    lowerLimitSlider.getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    //upperLimitSlider.setMin(Scene.getLowerLimit());
    upperLimitSlider.getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  }

  void lowerLimit() {
    Scene.setLowerLimit(lowerLimitSlider.getValue());
    updateSliders();
  }

  void upperLimit() {
    Scene.setUpperLimit(upperLimitSlider.getValue());
    updateSliders();
  }

  void preview(boolean theFlag) {
    Scene.setPreview();
  }

  void AscendingDescending(boolean theFlag) {
    Scene.ascDescChange(theFlag);
  }

  void sortHor() {
    Scene.processSortHorizontal();
  }

  void sortVer() {
    Scene.processSortVertical();
  }

  void chgSel(boolean state) {
    Scene.setSelection();
  }

  void delSel() {
    Scene.selectedArea.polygon.clear();
    Scene.processPreview();
  }

  void workSpc(int num) {
    workSpc[] spaces = workSpc.values();
    Scene.setWorkSpace(spaces[num]);
    Scene.processPreview();
  }

  void reset() {
    Scene.processReset();
  }
  
  void undo() {
     Scene.undoAction(); 
  }

  void save() {
    this.IMGSavePath = saveName.getText();
    Scene.saveImage(this.IMGSavePath);
  }

  void controlEvent(ControlEvent theEvent) {
    if (theEvent.isController()) {
      if (theEvent.getController().getName() == "checkMode") {
        Scene.setCheckMode(modes[(int)theEvent.getController().getValue()]);
        checkMode.setOpen(true);
      }
      if (theEvent.getController().getName() == "sortMode") {
        Scene.setSortingMode(modes[(int)theEvent.getController().getValue()]);
        sortMode.setOpen(true);
      }
      if (theEvent.getController().getName() == "saveFormat") {
        Scene.setSaveFormat(formats[(int)theEvent.getController().getValue()]);
        saveFormat.setOpen(true);
      }
    }
  }
}