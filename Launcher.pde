import controlP5.*;
startMenu startScreen;
String path;
File f;
File selectionF;

void setup() {
  size(400, 100, P2D); 
  surface.setTitle("Sorty");   
  startScreen = new startMenu(new ControlP5(this));
}

void draw() {
  background(#02182F);
  //fill(#02182F);
  fill(255);
  //text("Created by Kamil Marcniak",10,90);
  if (path != null) { 
    if (f.exists() && selectionF.exists()) {
      exec(dataPath("")+"\\starter.bat");
      exit();
    } else {
      text("Something went wrong, very wrong", 10, 10);
    }
  }
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    path = selection.getAbsolutePath();
    selectionF = selection;
    PrintWriter output=null;
    output = createWriter(dataPath("")+"\\starter.bat");
    output.println(dataPath("").charAt(0)+":");
    output.println("cd "+dataPath(""));
    output.println("Main.exe \""+ path+"\"");
    output.flush();
    output.close();  
    output=null;
    f = new File(dataPath("")+"\\starter.bat");
  }
}