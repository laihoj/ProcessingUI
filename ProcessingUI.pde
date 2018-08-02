/*
//Solved(ish): Big problem: how to prevent clickable of overlapping invisible eg buttons
//Listeners moved to Views instead of System.
//It is still the responsibility of developer to not overlay (unless so intended) stuff on views
*/

void setup() {
  ellipseMode(CORNER);
  rectMode(CORNER);
  System.add(new CSS_File("style.css"));
  println(System.css.toString());
  fullScreen();
  
  frameRate(System.getInt("frameRate"));
  stroke(System.getInt("stroke"));
  textSize(System.getInt("textSize"));
  baseDeclarations();
  initialiseHackDroneDeclarations();
  System.add(developer());
  System.add(composer());
}

void draw() {
  //background(colorify(system.getProperty("body","background")));
  background(Integer.valueOf(System.getProperty("body","background-red"))
            ,Integer.valueOf(System.getProperty("body","background-green"))
            ,Integer.valueOf(System.getProperty("body","background-blue")));
  System.next();
  //system.keyboardListener.display();
}
