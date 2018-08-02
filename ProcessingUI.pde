/*
//Solved(ish): Big problem: how to prevent clickable of overlapping invisible eg buttons
//Listeners moved to Views instead of System.
//It is still the responsibility of developer to not overlay (unless so intended) stuff on views
*/

System system;

void setup() {
  ellipseMode(CORNER);
  rectMode(CORNER);
  system = new System();
  system.add(new CSS_File("style.css"));
  //system.css.put("body","background","green");
  //system.css.save();
  println(system.css.toString());
  fullScreen();
  
  frameRate(system.getInt("frameRate"));
  stroke(system.getInt("stroke"));
  textSize(system.getInt("textSize"));
  baseDeclarations();
  initialiseHackDroneDeclarations();
  system.add(developer());
  system.add(composer());
}

void draw() {
  //background(colorify(system.getProperty("body","background")));
  background(Integer.valueOf(system.getProperty("body","background-red"))
            ,Integer.valueOf(system.getProperty("body","background-green"))
            ,Integer.valueOf(system.getProperty("body","background-blue")));
  system.next();
  //system.keyboardListener.display();
}
