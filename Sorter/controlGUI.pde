import controlP5.*;

checkMode[] modes = checkMode.values();

class controlGUI {
  //checkMode[] modes;
  ControlP5 cp5;
  boolean showMenu;
  Slider lowerLimitSlider;
  Slider upperLimitSlider;
  Button previewButton;
  DropdownList checkMode;
  DropdownList sortMode;

  controlGUI(ControlP5 control) {
    cp5 = control;

    showMenu = true;
    lowerLimitSlider = cp5.addSlider("lowerLimit")
      .setPosition(10, 50)
      .setRange(0, 1)
      .setSize(200, 50)
      .setTriggerEvent(Slider.RELEASE)
      .plugTo(this);
    lowerLimitSlider.getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);

    upperLimitSlider = cp5.addSlider("upperLimit")
      .setPosition(10, 125)
      .setRange(0, 1)
      .setSize(200, 50)
      .setTriggerEvent(Slider.RELEASE)
      .plugTo(this);
    upperLimitSlider.getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);

    previewButton = cp5.addButton("preview")
      .setPosition(10, 200)
      .setSize(50, 50)
      .plugTo(this);

    checkMode = cp5.addDropdownList("checkMode")
      .setPosition(10, 275)
      .setSize(90, 180)
      .setType(DropdownList.LIST)
      .plugTo(this);
    customize(checkMode);

    sortMode = cp5.addDropdownList("sortMode")
      .setPosition(120, 275)
      .setSize(90, 180)
      .setType(DropdownList.LIST)
      .plugTo(this);
    customize(sortMode);
  }

  void customize(DropdownList dd) {
    dd.setItemHeight(40);
    dd.setBarHeight(20);
    for (int i = 0; i<modes.length; i++) {
      dd.addItem(modes[i].name(), i);
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

  void preview() {
    Scene.setPreview();
  }
  
  void controlEvent(ControlEvent theEvent) {
    if (theEvent.isController()) {
      //outlineText(theEvent.getController().getName(),300,50);
      if (theEvent.getController().getName() == "checkMode") {
        outlineText(theEvent.getController().getName(),300,50);
        Scene.setCheckMode(modes[(int)theEvent.getController().getValue()]);
        checkMode.setOpen(true);
      }
      if (theEvent.getController().getName() == "sortMode") {
        outlineText(theEvent.getController().getName(),300,50);
        Scene.setSortingMode(modes[(int)theEvent.getController().getValue()]);
        sortMode.setOpen(true);
      }
    }
  }
}