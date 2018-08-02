/*
Hereby 
firstly an example as to how to create new event listener classes
secondly the mouse listener class
thirdly the keyboard listener class
lastly the observer class
*/



//Example listener class, observer and widget implementations 
/***********************************************************************************************/

//The abstract event listener class is to be extended by our new example listener class
/////////////////////////////////////////////////////////////////////////////////////////////////
abstract class ExampleEventListener implements Listener {
  ArrayList<ExampleObserver> observers = new ArrayList<ExampleObserver>();
  void add(ExampleObserver observer) {
    this.observers.add(observer);
  }
}
/////////////////////////////////////////////////////////////////////////////////////////////////

//The widget class that extends our abstract observer class is to implement the method onExampleEvent, which is to be called upon when the newly to be created listener registers an event
/////////////////////////////////////////////////////////////////////////////////////////////////
interface ExampleActivities {
  void onExampleEvent();
}
/////////////////////////////////////////////////////////////////////////////////////////////////

//The newly created example listener class extends the abstract example event listener class to get repetivite code, 
//and implements the method listen, which upon hearing some specific event it listens to urges its observers to act accordingly
/////////////////////////////////////////////////////////////////////////////////////////////////
class ExampleListener extends ExampleEventListener {
  boolean evented = false;
  ExampleListener() {}
  void listen() {
    if(evented) {
      for(ExampleObserver observer: this.observers) {
        observer.actAccordingly();
      }
    }
  }
}
/////////////////////////////////////////////////////////////////////////////////////////////////
/***********************************************************************************************/

//The abstract observer responds as urged to by the listener, and is to be extended by our awesome example widget.
//Of special note, currently one observer class is used for enacting all the urges described by listeners
//***********************************************************************************************/
/////////////////////////////////////////////////////////////////////////////////////////////////
abstract class ExampleObserver implements ExampleActivities {
  void actAccordingly() {
    this.onExampleEvent();
  }
}
/////////////////////////////////////////////////////////////////////////////////////////////////

//Now the awesome widget needs to implement the method onExampleEvent to create awesome behaviour
/////////////////////////////////////////////////////////////////////////////////////////////////
class Example_Awesome_Widget extends ExampleObserver {
  void onExampleEvent() {
    //An example: on clicking a navigation button, the current view might change
    println("After the specific event happened, the widget did something particularly awesome");
  }
}
/////////////////////////////////////////////////////////////////////////////////////////////////
/***********************************************************************************************/














/***********************************************************************************************/
/////////////////////////////////////////////////////////////////////////////////////////////////
interface Listener {
  void listen();
}
/////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////
abstract class EventListener implements Listener {
  ArrayList<Observer> observers = new ArrayList<Observer>();
  void add(Observer observer) {
    this.observers.add(observer);
  }
}
/////////////////////////////////////////////////////////////////////////////////////////////////
/***********************************************************************************************/



/***********************************************************************************************/
/////////////////////////////////////////////////////////////////////////////////////////////////
interface MouseActivities {
  boolean isTarget();
  void onMouseHover();
  void onMouseHoverOver();
  void onMousePress();
  void onMouseHold();
  void onMouseDrag(PVector mouse);
  void onMouseRelease();
}
/////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////
class MouseListener extends EventListener {
  boolean wasMousePressed = false;
  PVector mousePos = new PVector(0,0);
  PVector prevMousePos = new PVector(0,0);
  PVector dragment = new PVector(0,0);
  MouseListener() {}
  void listen() {
    for(Observer observer: this.observers) {
      observer.hoverMouse(this.mousePos);
    }
    if(mousePressed) {
      this.mousePos = new PVector(mouseX,mouseY);
      
      if(!wasMousePressed) {
        this.dragment.setMag(0);
        this.prevMousePos = new PVector(mouseX,mouseY);
        for(Observer observer: this.observers) {
          observer.pressMouse(this.mousePos);
        }
      } else {
        for(Observer observer: this.observers) {
          observer.holdMouse();
        }
      }
      if(this.mousePos != this.prevMousePos) {
        this.dragment = PVector.sub(this.prevMousePos,this.mousePos);
        for(Observer observer: this.observers) {
          observer.dragMouse(this.dragment);
        }
      }
    }
    if(wasMousePressed && !mousePressed) {
      for(Observer observer: this.observers) {
        observer.releaseMouse(mousePos, dragment);
      }
    }
    
    this.prevMousePos = new PVector(mousePos.x, mousePos.y);
    this.wasMousePressed = mousePressed;
  }
}
/////////////////////////////////////////////////////////////////////////////////////////////////
/***********************************************************************************************/



/***********************************************************************************************/
/////////////////////////////////////////////////////////////////////////////////////////////////
interface KeyboardActivities {
  void onKeyDown(char c);
  void onKeyHold(char c);
  void onKeyUp(char c);
  boolean isSelected();
}
/////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////
class KeyboardListener extends EventListener {
  boolean wasKeyPressed = false;
  HashMap<Character, Boolean> keys = new HashMap<Character, Boolean>();
  ArrayList<Character> keysPressed;
  ArrayList<Character> keysReleased;
  String alphabet;
  KeyboardListener() {
    this.alphabet = "";
    for(int i = 32; i < 127; i++) {
      this.alphabet += (char)i;
    }
    //this.alphabet = "1234567890 abcdefghijklmnopqrstuvwxyz";
    this.alphabet += BACKSPACE;
    this.alphabet += DELETE;
    this.alphabet += ENTER;
    this.alphabet += RETURN;
    this.alphabet += TAB;
    this.alphabet += ESC;
    this.alphabet += DOWN;
    this.alphabet += UP;
    this.alphabet += RIGHT;
    this.alphabet += LEFT;
    keysPressed = new ArrayList<Character>();
    keysReleased = new ArrayList<Character>();
  }
  void display() {
    String res = "\nkeys";
    for(char c: keys.keySet()) {
      res += "\n" + c + ": " + keys.get(c) ;
    }
    stroke(0);
    fill(0);
    
    String res2 = "\nkeysPressed";
    for(char c: keysPressed) {
      res2 += "\n" + c;
    }
    
    String res3 = "\nkeysReleased";
    for(char c: keysReleased) {
      res3 += "\n" + c;
    }
    
    text(res,0,0);
    text(res2,100,0);
    text(res3,200,0);
    
  }
  String toString() {
    String res = "\nkeys";
    for(char c: keys.keySet()) {
      res += "\n" + c + ": " + keys.get(c) ;
    }
    stroke(0);
    fill(0);
    
    String res2 = "\nkeysPressed";
    for(char c: keysPressed) {
      res2 += "\n" + c;
    }
    
    String res3 = "\nkeysReleased";
    for(char c: keysReleased) {
      res3 += "\n" + c;
    }
    return res + "\n" + res2 + "\n" + res3;
  }
  
  void add(char[] cs) {
    for(char c: cs) {
      this.keys.put(c,false);
    }
  }
  
  void add(char c) {
    this.keys.put(c,false);
  }
  
  void updateKeyMap() {
    if(!keyPressed) {
      for(char c: alphabet.toCharArray()) {
        this.keys.put(c, false);
      }
    }
  }
  void listen() {
    //Figure out which keys are (newly) pressed or released
    updateKeyMap();
    for(char c: this.keysPressed) {
      for(Observer observer: this.observers) {
        observer.pressKey(c);
      }
    }
    this.keysPressed.clear();
    for(char c: this.keysReleased) {
      for(Observer observer: this.observers) {
        observer.releaseKey(c);
      }
    }
    this.keysReleased.clear();
    for(char c: this.keys.keySet()) {
      for(Observer observer: this.observers) {
        if(keys.get(c)) {
          observer.holdKey(c);
        }
      }
    }
  }
}
/*Because there is no boolean keyReleased like there is keyPressed, in order to keep things consistent, lets utilise these functions*/
void keyPressed() {
  KeyboardListener listener = System.active_view.keyboardListener;
  for(char c: listener.keys.keySet()) {
    if(key==c) {
      if(!listener.keys.get(c)) {listener.keysPressed.add(c);}
      listener.keys.put(c,true);
    }
  }
}
void keyReleased() {
  KeyboardListener listener = System.active_view.keyboardListener;
  for(char c: listener.keys.keySet()) {
    if(key==c) {
      listener.keys.put(c,false);
      listener.keysReleased.add(c);
    }
  }
}
/////////////////////////////////////////////////////////////////////////////////////////////////

//some handy keyboard related methods
/////////////////////////////////////////////////////////////////////////////////////////////////
interface Spacebar {
  void onSpacebar();
}

interface Enter {
  void onEnter();
}

interface Backspace {
  void onBackspace();
}
/////////////////////////////////////////////////////////////////////////////////////////////////
/***********************************************************************************************/



/***********************************************************************************************/
/////////////////////////////////////////////////////////////////////////////////////////////////
abstract class Observer implements MouseActivities, KeyboardActivities, Selectable {
  boolean pressed, hovering, selected;
  PVector pos = new PVector(0,0);
  String key;

  /*Mouse stuff*/
  void hoverMouse(PVector mouse) {
    if(this.isTarget()) {
      this.hovering = true;
      this.onMouseHover();
    } else {
      if(this.hovering) {
        this.onMouseHoverOver();
      }
      this.hovering = false;
    }
  }
  void pressMouse(PVector mouse) {
    if(this.isTarget()) {
      this.pressed = true;
      
    }
    if(this.isSelected()) {
      this.onMousePress();
    }
  }
  void dragMouse(PVector mouse) {
    if(this.pressed && PVector.dist(new PVector(pmouseX, pmouseY), new PVector(mouseX, mouseY)) > 0) {
      this.onMouseDrag(mouse);
    }
  }
  void holdMouse() {
    if(this.isSelected()) {
      this.onMouseHold();
    }
  }
  void releaseMouse(PVector mouse, PVector dragment) {
    if(!this.isTarget() && this.selected) {
      this.deselect();
    }
    if(this.pressed && this.isTarget()) {
      this.onMouseRelease();
      this.select();
    }
    this.pressed = false;    
  }

  /*Keyboard stuff*/
  void pressKey(char c) {
    if(this.isSelected()) {
      this.onKeyDown(c);
    }
  }
  void holdKey(char c) {
    if(this.isSelected()) {
      this.onKeyHold(c);
    }
  }
  void releaseKey(char c) {
    if(this.isSelected()) {
      this.onKeyUp(c);
    }
  }
  
  /*Selectable implementations*/
  void select() {
    this.selected = true;
  }
  void deselect() {
    this.selected = false;
  }
}
/////////////////////////////////////////////////////////////////////////////////////////////////
/***********************************************************************************************/
