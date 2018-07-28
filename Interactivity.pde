/////////////////////////////////////////////////////////////////////////////////////////////////
interface Listener {
  void listen();
}
/////////////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////////////////
interface Selectable {
  void select();
  void deselect();
}
/////////////////////////////////////////////////////////////////////////////////////////////////


/*
To add a new listener, 
0. One should describe an interface to remind the implementor which events the observer should be able to handle 
1. one must implement the event handlers (i.e. onKeyDown etc) for the object who's methods will be called by the observer
2. one must define the set of cases in which the observer calls the object to handle events (i.e. keyDown, mousePress etc)
3. The newly dubbed listener should be connected to system.listen()
4. Profit
*/

/////////////////////////////////////////////////////////////////////////////////////////////////
interface MouseActivities {
  boolean isTarget();
  void onHover();
  void onHoverOver();
  void onPress();
  void onDrag(PVector mouse);
  void onRelease();
}
/////////////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////////////////
interface KeyboardActivities {
  void onKeyDown(char c);
  void onKeyHold(char c);
  void onKeyUp(char c);
  boolean isSelected();
}

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
class MouseListener implements Listener {
  boolean wasMousePressed = false;
  PVector mousePos = new PVector(0,0);
  PVector prevMousePos = new PVector(0,0);
  PVector dragment = new PVector(0,0);
  ArrayList<Observer> observers = new ArrayList<Observer>();
  MouseListener() {
  }
  void add(Observer observer) {
    this.observers.add(observer);
  }
  void listen() {
    for(Observer observer: this.observers) {
      observer.hover(this.mousePos);
    }
    if(mousePressed) {
      this.mousePos = new PVector(mouseX,mouseY);
      
      if(!wasMousePressed) {
        this.dragment.setMag(0);
        this.prevMousePos = new PVector(mouseX,mouseY);
        for(Observer observer: this.observers) {
          observer.press(this.mousePos);
        }
      }
      if(this.mousePos != this.prevMousePos) {
        this.dragment = PVector.sub(this.prevMousePos,this.mousePos);
        for(Observer observer: this.observers) {
          observer.drag(this.dragment);
        }
      }
    }
    if(wasMousePressed && !mousePressed) {
      for(Observer observer: this.observers) {
        observer.release(mousePos, dragment);
      }
    }
    
    this.prevMousePos = new PVector(mousePos.x, mousePos.y);
    this.wasMousePressed = mousePressed;
  }
}
/***********************************************************************************************/

/***********************************************************************************************/

class KeyboardListener implements Listener {
  boolean wasKeyPressed = false;
  ArrayList<Observer> observers = new ArrayList<Observer>();
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
  void add(Observer observer) {
    this.observers.add(observer);
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
    if(keyPressed) {
      for(char c: alphabet.toCharArray()) {
        if(key==c) {
          if(!keys.get(c)) {
            this.keysPressed.add(c);
          }
          this.keys.put(c, true);
          //if a key is not pressed but it was pressed earlier, then it is released
        } else if(keys.get(c)) {
          this.keysReleased.add(c);
          this.keys.put(c, false);
        }
      }
    } else {
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
        observer.press(c);
      }
    }
    this.keysPressed.clear();
    for(char c: this.keysReleased) {
      for(Observer observer: this.observers) {
        observer.release(c);
      }
    }
    this.keysReleased.clear();
  }
}
/***********************************************************************************************/


/***********************************************************************************************/
abstract class Observer implements MouseActivities, KeyboardActivities, Selectable {
  boolean pressed, hovering, selected;
  PVector pos = new PVector(0,0);
  String key;

  /*Mouse stuff*/
  void hover(PVector mouse) {
    if(this.isTarget()) {
      this.hovering = true;
      this.onHover();
    } else {
      if(this.hovering) {
        this.onHoverOver();
      }
      this.hovering = false;
    }
  }
  void press(PVector mouse) {
    if(this.isTarget()) {
      this.pressed = true;
      this.onPress();
    }
  }
  void drag(PVector mouse) {
    if(this.pressed && PVector.dist(new PVector(pmouseX, pmouseY), new PVector(mouseX, mouseY)) > 0) {
      this.onDrag(mouse);
    }
  }
  void release(PVector mouse, PVector dragment) {
    if(this.pressed && this.isTarget()) {
      this.onRelease();
    }
    if(!this.isTarget() && this.selected) {
      this.deselect();
    }
    this.pressed = false;    
  }

  /*Keyboard stuff*/
  void press(char c) {
    if(this.isSelected()) {
      this.onKeyDown(c);
    }
  }
  void hold(char c) {
    if(this.isSelected()) {
      this.onKeyHold(c);
    }
  }
  void release(char c) {
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
/***********************************************************************************************/
