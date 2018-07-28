//Big problem: how to prevent clickable of overlapping invisible eg buttons

System system;

void setup() {
  system = new System();
  system.add(new CSS_File("style.css"));

  
  fullScreen();
  frameRate(system.getInt("frameRate"));
  stroke(system.getInt("stroke"));
  textSize(system.getInt("textSize"));
  baseDeclarations();
  //initialiseTextBoxDeclarations();
  initialiseHackDroneDeclarations();
}

void draw() {
  background(colorify(system.getProperty("body","background")));
  system.next();
  //system.keyboardListener.display();
}
