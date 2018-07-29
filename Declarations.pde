/***********************************************
Imports
************************************************/

////////////////////////////////////////////////////////////////////////////////
//Base declarations
////////////////////////////////////////////////////////////////////////////////

void baseDeclarations() {
  COLORS.put("blue", color(0,200,180));
  COLORS.put("lightblue", color(0,132,180));
  COLORS.put("white", color(255,255,255));
  COLORS.put("green", color(0,255,0));
  DEFAULT_TEXT_SIZE = 15;
  BUTTON_DEFAULT_DIMENSIONS = new Dimensions(width/6-1, 100);
  FULL_SCREEN = new Dimensions(width,height);
}

/*
////////////////////////////////////////////////////////////////////////////////
//TextBox declarations
////////////////////////////////////////////////////////////////////////////////



void initialiseTextBoxDeclarations() {
  Point WORD_INPUT_TEXTBOX_POINT = new Point(width/2, height/2);
  Point A_BIT_TO_THE_LEFT = new Point(-100, 0);
  Point A_BIT_UPWARDS  = new Point(0, -100);
  MAIN_MENU = new View("Main menu view");
  MAIN_MENU.add(new Label("Enter word", WORD_INPUT_TEXTBOX_POINT.add(A_BIT_TO_THE_LEFT)));
  INPUT = new TextBox(WORD_INPUT_TEXTBOX_POINT, new Dimensions(100,20));
  MAIN_MENU.add(INPUT);
  MAIN_MENU.add(newButton(new Attributes(".button", "", "", "", new DoNothing(), new Reset_TextBox(INPUT)), "Reset", WORD_INPUT_TEXTBOX_POINT.add(A_BIT_UPWARDS), BUTTON_DEFAULT_DIMENSIONS));
  //MAIN_MENU.add(newButton());
  
  system.active_view = MAIN_MENU;
  //ACTION_BAR = new View();
  //system.action_bar = ACTION_BAR;
  //ACTION_BAR.add(newButton(new ChangeView(CONFIGURE_MENU),"Configure menu",color(255,255,255),TOP_LEFT,BUTTON_DEFAULT_DIMENSIONS));
  //ACTION_BAR.add(newButton(new ChangeView(MAIN_MENU),"Main menu",color(255),TOP_ONE_THIRDS,BUTTON_DEFAULT_DIMENSIONS));
  //ACTION_BAR.add(newButton(new ChangeView(FLIGHT_MENU),"Flight menu",color(255),TOP_TWO_THIRDS,BUTTON_DEFAULT_DIMENSIONS));
}
*/






////////////////////////////////////////////////////////////////////////////////
//HackDroneX
////////////////////////////////////////////////////////////////////////////////
import processing.serial.*;

/***********************
Android-specific imports
************************/
//import android.content.Intent;
//import android.os.Bundle;

//Processing android mode bluetooth library
import ketai.net.bluetooth.*;
import ketai.ui.*;
import ketai.net.*;
//import oscP5.*;

////Accelerometer necessities
//import android.content.Context;
//import android.hardware.Sensor;
//import android.hardware.SensorManager;
//import android.hardware.SensorEvent;
//import android.hardware.SensorEventListener;



/***********************************************
Global constants
************************************************/

//what is the point, you might ask? Havent landed upon a nice floating container solution yet.
Point       TOP_LEFT;

Point[]     TOP_THIRDS;
Point[]     TOP_FOURTHS;
Point[]     TOP_FIFTHS;
Point[]     TOP_SIXTHS;


//Point       TOP_ONE_THIRDS,
//            TOP_TWO_THIRDS;

//Point       TOP_ONE_FOURTHS,
//            TOP_TWO_FOURTHS,
//            TOP_THREE_FOURTHS;

Container   ACTION_BAR;

View        MAIN_MENU,
            CONFIGURE_MENU,
            FLIGHT_MENU,
            DEVELOPER_MENU,
            BALL_GAME,
            WORD_TRAINER;
            
Dimensions  BUTTON_DEFAULT_DIMENSIONS,
            SLIDER_DEFAULT_DIMENSIONS,
            FULL_SCREEN;
            
Dimensions  JOYSTICK_DEFAULT_DIMS;
int         JOYSTICK_DEFAULT_RADIUS;

float       OUTPUT_RANGE;
int         DEFAULT_TEXT_SIZE;

static HashMap<String, Integer> COLORS = new HashMap<String, Integer>();
static int colorify(String colorword) {
  return COLORS.get(colorword);
}

Serial myPort = null;

//think about where these should go
Joystick_Left leftStick;
Joystick_Right rightStick;

Point WORD_INPUT_TEXTBOX_POINT;// = new Point(width/2, height/2);
Dimensions WORD_INPUT_TEXTBOX_DIMENSIONS;
Point A_BIT_TO_THE_LEFT;// = new Point(-100, 0);
Point A_BIT_TO_THE_RIGHT;
Point A_BIT_UPWARDS;//  = new Point(0, -100);

TextBox INPUT;

/***********************************************
Initialization function - cleaner here than in setup()
************************************************/

void initialiseHackDroneDeclarations() {
  
  OUTPUT_RANGE = 255;
  //DEFAULT_TEXT_SIZE = 15;
  TOP_LEFT = new Point(0,0);
  
  //TOP_ONE_THIRDS = new Point(width/3,0);
  //TOP_TWO_THIRDS = new Point(width*2/3,0);
  
  //TOP_ONE_FOURTHS = new Point(width/4,0);
  //TOP_TWO_FOURTHS = new Point(width*2/4,0);
  //TOP_THREE_FOURTHS = new Point(width*3/4,0);
  
  TOP_THIRDS  = new Point[] {new Point(TOP_LEFT),new Point(width/3,0),new Point(width*2/3,0)};
  TOP_FOURTHS = new Point[] {new Point(TOP_LEFT),new Point(width/4,0),new Point(width*2/4,0),new Point(width*3/4,0)};
  TOP_FIFTHS  = new Point[] {new Point(TOP_LEFT),new Point(width/5,0),new Point(width*2/5,0),new Point(width*3/5,0),new Point(width*4/5,0)};
  TOP_SIXTHS  = new Point[] {new Point(TOP_LEFT),new Point(width/6,0),new Point(width*2/6,0),new Point(width*3/6,0),new Point(width*4/6,0),new Point(width*5/6,0)};
  
  A_BIT_TO_THE_LEFT = new Point(-100, 0);
  A_BIT_TO_THE_RIGHT  = new Point(100, 0);
  A_BIT_UPWARDS  = new Point(0, -100);
  WORD_INPUT_TEXTBOX_POINT = new Point(width/2, height/2);
  //BUTTON_DEFAULT_DIMENSIONS = new Dimensions(width/3-1, 100);
  SLIDER_DEFAULT_DIMENSIONS = new Dimensions(width / 10, height * 4 / 5);
  JOYSTICK_DEFAULT_RADIUS = min(width,height)*2/3;
  JOYSTICK_DEFAULT_DIMS = new Dimensions((int)(JOYSTICK_DEFAULT_RADIUS * 0.15),JOYSTICK_DEFAULT_RADIUS,0);
  WORD_INPUT_TEXTBOX_DIMENSIONS = new Dimensions(100,20);
  
  
  MAIN_MENU = new View("Main menu view");
  MAIN_MENU.add(new Label(new Point(width/2, height/2), "Home"));
  //MAIN_MENU.add(newButton(new Attributes(".button", "", "", "", new DoNothing(), new ChangeView(CONFIGURE_MENU)), "testing", new Point(width/2, height/2), BUTTON_DEFAULT_DIMENSIONS));
  
  //MAIN_MENU.add(mainSlider);
  CONFIGURE_MENU = new View("Configuration view");
  CONFIGURE_MENU.add(new Label(new Point(width/2, BUTTON_DEFAULT_DIMENSIONS.dims[1] + 10), "Configuration"));
  CSS_Slider redSlider =   new CSS_Slider(new Point(width/3, height/2),      new Dimensions(100,20,0), 255, "body", "background-red");
  CSS_Slider greenSlider = new CSS_Slider(new Point(width/3, height/2 + 22), new Dimensions(100,20,0), 255, "body", "background-green");
  CSS_Slider blueSlider  = new CSS_Slider(new Point(width/3, height/2 + 44), new Dimensions(100,20,0), 255, "body", "background-blue");
  CONFIGURE_MENU.add(redSlider);
  CONFIGURE_MENU.add(greenSlider);
  CONFIGURE_MENU.add(blueSlider);
  CONFIGURE_MENU.add(new Button(new Save_Configurations(redSlider, greenSlider, blueSlider), "save", color(255), new Point(width/3, height/2 - 22), new Dimensions(100,20,0)));
  //CONFIGURE_MENU.add(newButton(new Discover(),"Discover",color(255,255,255),new Point(0,height/4),BUTTON_DEFAULT_DIMENSIONS));
  //CONFIGURE_MENU.add(newButton(new MakeDiscoverable(),"Make Discoverable",color(255,255,255),new Point(0,height*1/2),BUTTON_DEFAULT_DIMENSIONS));
  //CONFIGURE_MENU.add(newButton(new Connect(),"Connect",color(255,255,255),new Point(0,height*3/4),BUTTON_DEFAULT_DIMENSIONS));
  FLIGHT_MENU = new View("Flight menu view");
  
  leftStick  = new Joystick_Left( new Point(width*1/4,height/2), JOYSTICK_DEFAULT_DIMS);
  rightStick = new Joystick_Right(new Point(width*3/4,height/2), JOYSTICK_DEFAULT_DIMS);
  leftStick.setResting(new Point(leftStick.point.x,leftStick.point.y + (int)leftStick.getRadius())).rest();
  rightStick.setResting(new Point(rightStick.point)).rest();
  FLIGHT_MENU.add(leftStick);
  FLIGHT_MENU.add(rightStick);
  DEVELOPER_MENU = new View("Developer menu view")
              .add(new Vertical_Slider  (new Point(width/3, height/2),           new Dimensions(100,400,0)))
              .add(new Horizontal_Slider(new Point(width*2/3, height*2/3),       new Dimensions(400,100,0)))
              .add(new Rotator          (new Point(width*3/4,height/4),          new Dimensions(300)))
              .add(new CheckBox         (new Point(width/2 - 100, height - 100), new Dimensions(50,50)))
              .add(new CheckBox         (new Point(width/2, height - 100),       new Dimensions(50,50)))
              .add(new Label            (new Point(WORD_INPUT_TEXTBOX_POINT.add(A_BIT_TO_THE_LEFT)), new String("Enter word")));
  
  INPUT = new TextBox(new Point(WORD_INPUT_TEXTBOX_POINT), new Dimensions(WORD_INPUT_TEXTBOX_DIMENSIONS));
  DEVELOPER_MENU.add(INPUT);
  DEVELOPER_MENU.add(new Button(new Attributes(".button", "", "", "", new DoNothing(), new Reset_TextBox(INPUT)), "Reset", WORD_INPUT_TEXTBOX_POINT.add(A_BIT_TO_THE_RIGHT), WORD_INPUT_TEXTBOX_DIMENSIONS));
  
  BALL_GAME = new View("Ball game");
  Shooter shooter = new Shooter(new Point(width/2, height/2), new Dimensions(30));
  BALL_GAME.add(shooter);
  Container weapons_toolbar = new Container(new Point(0, height - 100), new Dimensions(width, 100));
  weapons_toolbar.add(new Button(new Switch_Weapon(shooter, shooter.machineGun),  "Machine gun",color(255),  new Point(width/2, height/2), BUTTON_DEFAULT_DIMENSIONS))
                 .add(new Button(new Switch_Weapon(shooter, shooter.sniperRifle), "Sniper rifle",color(255), new Point(width/2, height/2), BUTTON_DEFAULT_DIMENSIONS))
                 .add(new Button(new Switch_Weapon(shooter, shooter.pistol),      "Pistol",color(255),       new Point(width/2, height/2), BUTTON_DEFAULT_DIMENSIONS))
                 .add(new Button(new Switch_Weapon(shooter, shooter.shotgun),     "Shotgun",color(255),      new Point(width/2, height/2), BUTTON_DEFAULT_DIMENSIONS));
  BALL_GAME.add(weapons_toolbar);
  
  WORD_TRAINER = new View("Word trainer");
  WORD_TRAINER.add(new Rotator(new Point(width/3, height/2), new Dimensions(300)));
  //WORD_TRAINER.add(new Button(new Point(width*2/3, height/2), new Dimensions(100,25)));
  WORD_TRAINER.add(new TextBox(new Point(width*2/3, height/2).add(A_BIT_TO_THE_RIGHT), new Dimensions(100,25)));
  
  ACTION_BAR = new Container(new Dimensions(width, 50));
  //ACTION_BAR = new Container();
  system.action_bar = ACTION_BAR;
  system.active_view = MAIN_MENU;
  
  ACTION_BAR.add(new Navigation_Button(CONFIGURE_MENU))
            .add(new Navigation_Button(MAIN_MENU))
            .add(new Navigation_Button(FLIGHT_MENU))
            .add(new Navigation_Button(DEVELOPER_MENU))
            .add(new Navigation_Button(BALL_GAME))
            .add(new Navigation_Button(WORD_TRAINER));
}
