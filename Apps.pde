//HERE IS THE AWESOME BALL GAME WHICH DEMONSTRATES INTERACTION BY BOTH MOUSE AND KEYBOARD
/***********************************************************************************************/
/////////////////////////////////////////////////////////////////////////////////////////////////
PVector LEFTWARDS = new PVector(-0.35,0);
PVector RIGHTWARDS = new PVector(0.35,0);
PVector UPWARDS = new PVector(0,-0.35);
PVector DOWNWARDS = new PVector(0,0.35);
/////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////
class Ball extends Ellipse_Widget {
  PVector vel;
  ArrayList<Ball.Projectile> shots; 
  Ball(Point point, Dimensions dimensions) {
    super(point, dimensions);
    vel = new PVector();
    this.selected = true;
    this.shots = new ArrayList<Ball.Projectile>();
  }
  void display() {
    /*Physics*/
    this.point.add(vel);
    this.vel.mult(0.93);
    /*Rules*/
    if(this.outOfBounds()) {
      this.reset();
    }
    /*Styling*/
    fill(255,0,0);
    noStroke();
    if(this.hovering) {
      fill(255,200,200);
    }
    /*Draw*/
    ellipse(this.point, this.dimensions);
    for(int i = 0; i < this.shots.size(); i++) {
      Ball.Projectile shot = this.shots.get(i);
      if(!shot.outOfBounds()) {
        shot.display();
      } else {
        this.shots.remove(shot);
      }
    }
  }
  
  //override release() to stop ball from being deselected
  void releaseMouse(PVector mouse, PVector dragment) {}
  
  //rules
  ////////////
  boolean outOfBounds() {
    return this.point.x < 0 ||
           this.point.x > width ||
           this.point.y < 0 ||
           this.point.y > height;
  }
  Ball.Projectile fire() {
    return new Ball.Projectile(PVector.sub(new PVector(mouseX,mouseY), this.point.toPVector()).mult(0.02));
  }
  
  //utilitarian
  ////////////
  void reset() {
    this.vel.mult(0);
    this.point.x = width/2;
    this.point.y = height/2;
  }
  void push(PVector force) {
    vel.add(force);
  }
  //case up down left right dont seem to work
  void processKeyHold(char c) {
    switch(c) {
      case 'w': this.push(UPWARDS);
        break;
      case 'a': this.push(LEFTWARDS);
        break;
      case 's': this.push(DOWNWARDS);
        break;
      case 'd': this.push(RIGHTWARDS);
        break;
    }
  }
  void processKeyDown(char c) {
    switch(c) {
      case 't': this.shots.add(fire());
        break;
    }
  }
  //interaction
  ////////////
  void onMousePress() {
    this.shots.add(fire());
  }
  void onMouseHold() {
    this.shots.add(fire());
  }
  void onMouseDrag(PVector drag) {
    this.point.sub(drag);
  }
  void onKeyDown(char c) {
    processKeyDown(c);
  }
  void onKeyHold(char c) {
    processKeyHold(c);
  }
  
  class Projectile extends Ellipse_Widget {
    PVector vel;
    Projectile(PVector vel) {
      super(Ball.this.point, new Dimensions(5));
      this.vel = vel;
    }
    void display() {
      this.point.add(vel);
      fill(0);
      ellipse(this.point, this.dimensions);
    }
    boolean outOfBounds() {
      return this.point.x < 0 ||
             this.point.x > width ||
             this.point.y < 0 ||
             this.point.y > height;
    }
  }
}
/////////////////////////////////////////////////////////////////////////////////////////////////
/***********************************************************************************************/

/***********************************************************************************************/
/////////////////////////////////////////////////////////////////////////////////////////////////
interface Fire {
  void pullTrigger();
  void holdTrigger();
  Shooter.Projectile fire();
}
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
class Shooter extends Ball {
  Shooter.MachineGun machineGun = new MachineGun();
  Shooter.SniperRifle sniperRifle = new SniperRifle();
  Shooter.Pistol pistol = new Pistol();
  Shooter.Shotgun shotgun = new Shotgun();
  
  Shooter.Gun gun;
  Shooter(Point point, Dimensions dimensions) {
    super(point, dimensions);
    this.gun = null;
  }
  void processKeyDown(char c) {
    switch(c) {
      case '1': this.gun = machineGun;
        break;
      case '2': this.gun = sniperRifle;
        break;
      case '3': this.gun = pistol;
        break;
      case '4': this.gun = shotgun;
        break;
      case 't': this.pullTrigger();
      break;
    }
  }
  void processKeyHold(char c) {
    super.processKeyHold(c);
    switch(c) {
      case 't': this.holdTrigger();
        break;
    }
  }
  void pullTrigger() {
    if(this.gun != null) {
      this.gun.pullTrigger();
    }
  }
  void holdTrigger() {
    if(this.gun != null) {
      this.gun.holdTrigger();
    }
  }
  void onMousePress() {
    this.pullTrigger();
  }
  void onMouseHold() {
    this.holdTrigger();
  }
  void onKeyDown(char c) {
    processKeyDown(c);
  }
  void onKeyHold(char c) {
    processKeyHold(c);
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////
  
  /////////////////////////////////////////////////////////////////////////////////////////////////
  abstract class Gun implements Fire {
    float bulletVelocity;
    //Combine velocities of both the shooter and bullet to get total velocity vector
    Shooter.Projectile fire() {
      PVector shootervel = Shooter.this.vel;
      PVector shotvel = new PVector(bulletVelocity,0).rotate(PVector.sub(new PVector(mouseX,mouseY), Shooter.this.point.toPVector()).heading());
      shotvel.add(shootervel);
      Shooter.Projectile shot = new Shooter.Projectile(shotvel);
      //For display purposes, the shooter is responsible for displaying the shots. Consider moving responsibility to View or Container
      Shooter.this.shots.add(shot);
      return shot;
    }
    void pullTrigger() {}
    void holdTrigger() {}
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////
  class MachineGun extends Gun {
    MachineGun() {
      this.bulletVelocity = 10;
    }
    void pullTrigger() {
      fire();
    }
    void holdTrigger() {
      fire();
    }
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////
  class SniperRifle extends Gun {
    SniperRifle() {
      this.bulletVelocity = 30;
    }
    void pullTrigger() {
      fire();
    }
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////
  class Pistol extends Gun {
    Pistol() {
      this.bulletVelocity = 8;
    }
    void pullTrigger() {
      fire();
    }
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////
  class Shotgun extends Gun {
    Shotgun() {
      this.bulletVelocity = 8;
    }
    void pullTrigger() {
      for(int i = 0; i < 8; i++) {
        fire().vel.rotate(random(-0.3,0.3));
      }
    }
  }
}
/////////////////////////////////////////////////////////////////////////////////////////////////
/***********************************************************************************************/









//Composer - make music
View composer() {
  View app = new Composer();
  system.navigation_bar.add(new Navigation_Button(app));
  return new Composer();
}
/***********************************************************************************************/
/////////////////////////////////////////////////////////////////////////////////////////////////
class Composer extends View {
  Container toolbar;
  CheckBox_Grid noteGrid;
  Composer() {
    super("Composer");
    this.toolbar = new Container(new Point(0,height-100), new Dimensions(width,100));
    this.toolbar.add(new Rotator(new Point(), new Dimensions(100)))
                .add(new Rotator(new Point(), new Dimensions(150)))
                .add(new Rotator(new Point(), new Dimensions(300)))
                .add(new Rotator(new Point(), new Dimensions(50)));
    this.noteGrid = new CheckBox_Grid(new Point(100, 100),new Dimensions(width-200,height/4),150,12);
    
    this.add(noteGrid);
  }
  void display() {
    super.display();
    this.toolbar.display();
  }
  void listen() {
    super.listen();
    this.toolbar.listen();
  }
}
/////////////////////////////////////////////////////////////////////////////////////////////////
/***********************************************************************************************/

/***********************************************************************************************/
View developer() {
  View app = new Developer();
  system.navigation_bar.add(new Navigation_Button(app));
  return new Developer();
}
/////////////////////////////////////////////////////////////////////////////////////////////////
class Developer extends View {
  Developer() {
    super("Developer");
          this.add(new Vertical_Slider  (new Point(width/3, height/2),           new Dimensions(100,400,0)))
              .add(new Horizontal_Slider(new Point(width*2/3, height*2/3),       new Dimensions(400,100,0)))
              .add(new Rotator          (new Point(width*3/4,height/4),          new Dimensions(300)))
              .add(new CheckBox         (new Point(width/2 - 100, height - 100), new Dimensions(50,50)))
              .add(new CheckBox         (new Point(width/2, height - 100),       new Dimensions(50,50)))
              .add(new Label            (new Point(WORD_INPUT_TEXTBOX_POINT.add(A_BIT_TO_THE_LEFT)), new String("Enter word")));
  
  TextBox INPUT = new TextBox(new Point(WORD_INPUT_TEXTBOX_POINT), new Dimensions(WORD_INPUT_TEXTBOX_DIMENSIONS));
  this.add(INPUT);
  this.add(new Button(new Attributes(".button", "", "", "", new DoNothing(), new Reset_TextBox(INPUT)), "Reset", WORD_INPUT_TEXTBOX_POINT.add(A_BIT_TO_THE_RIGHT), WORD_INPUT_TEXTBOX_DIMENSIONS));
  }
}
/////////////////////////////////////////////////////////////////////////////////////////////////
/***********************************************************************************************/
