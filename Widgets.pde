//Point is PVector reinvented. Investigate ramifications if should extend PVector
/***********************************************************************************************/
class Point {
  float x, y;
  Point(Point point) {
    this.x = point.x;
    this.y = point.y;
  }
  Point(float x, float y) {
    this.x = x;
    this.y = y;
  }
  Point(int x, int y) {
    this.x = x;
    this.y = y;
  }
  Point add(Point that) {
    this.x += that.x;
    this.y += that.y;
    return this;
  }
  Point add(PVector that) {
    this.x += that.x;
    this.y += that.y;
    return this;
  }
  void sub(Point that) {
    this.x -= that.x;
    this.y -= that.y;
  }
  void sub(PVector that) {
    this.x -= that.x;
    this.y -= that.y;
  }
  float dist(Point that) {
    return sqrt((float)(Math.pow((that.x - this.x),2) + Math.pow((that.y - this.y),2)));
  }
  float dist(PVector that) {
    return sqrt((float)(Math.pow((that.x - this.x),2) + Math.pow((that.y - this.y),2)));
  }
  float heading(Point that) {
    return new PVector(this.x - that.x,this.y - that.y).heading();
  }
  PVector toPVector() {
    return new PVector(this.x, this.y);
  }
}
/***********************************************************************************************/


/***********************************************************************************************/
class Dimensions {
  int[] dims;
  Dimensions(int... dims) {
    this.dims = dims;
  }
  Dimensions(Dimensions dimensions) {
    this.dims = dimensions.dims;
  }
}
/***********************************************************************************************/


/***********************************************************************************************/
class View {
  String name;
  ArrayList<Button> buttons = new ArrayList<Button>();
  ArrayList<Widget> widgets = new ArrayList<Widget>();
  MouseListener mouseListener;
  KeyboardListener keyboardListener;
  View() {
    this("ANONYMOUS_VIEW");
  }
  View(String name) {
    mouseListener = new MouseListener();
    keyboardListener = new KeyboardListener();
    system.add(this);
    this.name = name;
  }
  String toString() {
    return this.name;
  }
  void add(Button button) {
    this.buttons.add(button);
    this.mouseListener.add(button);
    this.keyboardListener.add(button);
  }
  void add(Widget widget) {
    this.widgets.add(widget);
    this.mouseListener.add(widget);
    this.keyboardListener.add(widget);
  }
  void remove(Button button) {
    this.buttons.remove(button);
  }
  void remove(Widget widget) {
    this.widgets.remove(widget);
  }
  void display() {
    for(Button button: this.buttons) {
      button.display();
    }
    for(Widget widget: this.widgets) {
      if(widget != null) {
        widget.display();
      }
    }
  }
  void listen() {
    this.mouseListener.listen();
    this.keyboardListener.listen();
  }
}
/***********************************************************************************************/



/////////////////////////////////////////////////////////////////////////////////////////////////
interface Displayable {
  void display();
}
/////////////////////////////////////////////////////////////////////////////////////////////////


/*
The way I've thought it out summer 2018 is that every visible UI element should extend the class Widget and implement a display method.
The observer class makes sure that widgets can be given any functionality on human interaction, much similarly to html and javascript.
Feel free to implement the on[Event] methods in extending classes to achieve functionality.
*/
/*
When extending the widget class to new widgets, in case of the constructor, start with the point.
*/
/////////////////////////////////////////////////////////////////////////////////////////////////
abstract class Widget extends Observer implements Displayable {
  Point point;
  Dimensions dimensions;
  Widget(Point point, Dimensions dimensions) {
    this.point = point;
    this.dimensions = dimensions;
  }
  void onHover() {}
  void onHoverOver() {}
  void onPress() {}
  void onDrag(PVector mouse) {}
  void onRelease() {}
  void onKeyDown(char c) {}
  void onKeyHold(char c) {}
  void onKeyUp(char c) {}
  boolean isSelected() {return selected;}

}

/*
To describe a widget, one must describe its location, its dimensions, how it is displayed,
and how it a user's mouse inputs interact with it.
For example, a rectangular item's dimensions might be its width and height, while 
a circular item's dimensions might better be described by its radius.

The Joystick's dimensions are the radius of the outer circle, and the radius of the inner circle
*/
class Widget_Placeholder extends Widget {
  Widget_Placeholder(Point point, Dimensions dimensions) {
    super(point,dimensions);
  }
  void display() {}
  boolean isTarget() {return false;}
}
/***********************************************************************************************/
/////////////////////////////////////////////////////////////////////////////////////////////////


/***********************************************************************************************/
class Button extends Widget implements Command {
  Command command;
  String text;
  color c;
  color color_pressed;
  color color_base;
  color color_hovering;
  Attributes attributes;
  Button(Command command, String text, color c, Point point, Dimensions dimensions) {
    super(point,dimensions);
    this.command = command;
    this.text = text;
    this.c = c;
    this.point = point;
    this.dimensions = dimensions;
    this.attributes = null;
  }
  Button(Attributes attributes, String text, Point point, Dimensions dimensions) {
    super(point,dimensions);
    this.attributes = attributes;
    //this.color_pressed = colorify(system.getProperty(this.attributes.css_class, "color-pressed"));
    this.color_pressed = COLORS.get(system.getCSS().properties.get(this.attributes.css_class).get("color-pressed"));
    this.color_base = COLORS.get(system.getCSS().properties.get(this.attributes.css_class).get("color-base"));
    this.color_hovering = COLORS.get(system.getCSS().properties.get(this.attributes.css_class).get("color-hovering"));
    this.text = text;
  }
  void display() {
    if(this.attributes != null) {
      if(pressed) {
        fill(this.color_pressed);
        stroke(0);
      } else if(hovering) {
        fill(this.color_hovering);
        noStroke();
      } else {
        fill(this.color_base);
        noStroke();
      }
    } else
    if(pressed) {
      fill(c);
      stroke(0);
    } else if(hovering) {
      fill(0,200,180);
      noStroke();
    } else {
      fill(0,132,180);
      noStroke();
    }
    rectMode(CORNER);
    rect(point.x,point.y,dimensions.dims[0],dimensions.dims[1]);
    fill(0);
    textAlign(CENTER);
    textSize(15);
    text(text,point.x + dimensions.dims[0]/2,point.y+dimensions.dims[1]/2);
  }
  
  boolean isTarget() {
    return isTargetRect(this.point, this.dimensions);
  }
  void execute() {
    this.command.execute();
  }
  //unlike normal commands (which extend AbstractCommand {button extends widget}), queue needs to be implemented
  void queue() {
    system.commands.add(this);
  }
  void onRelease() {  
    if(this.attributes != null) {
      this.attributes.onRelease.queue();
    } else {
      this.queue();
    }
  }
}

class Navigation_Button extends Button {
  Navigation_Button(Point point, View target) {
    super(new ChangeView(target), target.name, color(255), point, BUTTON_DEFAULT_DIMENSIONS);
  }
}
/***********************************************************************************************/




//The dimensions.dim[0] refers to the diameter of the outer circle  
/***********************************************************************************************/
class Rotator extends Widget {
  float heading = 0; 
  PVector mouseDisplacement = new PVector(0,0);
  Rotator(Point point, Dimensions dimensions) {
    super(point,dimensions);
    this.point = point;
    this.dimensions = dimensions;
  }
  int getDiameter() {
    return dimensions.dims[0];
  }
  int getRadius() {
    return getDiameter() / 2;
  }
  void setHeading(float heading) {
    this.heading = heading;
  }
  void display() {
   stroke(0);
   noFill();
   point(point.x,point.y);
   ellipse(this.point, this.dimensions);
   fill(0);
   //line(point.x, point.y, point.x + this.getRadius() * cos(heading), point.y + this.getRadius() * sin(heading));
   pushMatrix();
   translate(point.x, point.y);
   rotate(heading);
   line(0,0, this.getRadius(), 0);
   popMatrix();
   fill(0);
   text(this.toString(), point.x, point.y);
  }
  boolean isTarget() {
    return isTargetEllipse(this.point, this.dimensions);
  }
  void onHover() {}
  void onPress() {
    this.mouseDisplacement = PVector.sub(new PVector(mouseX,mouseY),new PVector(this.point.x,this.point.y));
  }
  void onDrag(PVector drag) {
    this.setHeading((
                    this.heading 
                  + TWO_PI 
                  + PVector.sub(new PVector(mouseX,mouseY),this.point.toPVector()).heading() 
                  - PVector.sub(new PVector(pmouseX,pmouseY),this.point.toPVector()).heading())
                  % TWO_PI);
  }
  String toString() {
    return ""+heading;
  }
}
/***********************************************************************************************/


//The dimensions.dim[1] refers to the diameter of the outer circle, [0] is the inner circle  
/***********************************************************************************************/
class Joystick extends Widget {
  boolean springy;
  float spring = 0.95;
  Point stick;
  //float radius, innerRadius;
  PVector mouseDisplacement = new PVector(0,0);
  Point resting;
  Joystick(Point point, Dimensions dimensions) {
    super(point,dimensions);
    this.point = point;
    this.dimensions = dimensions;
    this.stick = new Point(this.point.x, this.point.y + (int)this.getRadius());
    this.resting = new Point(point);
  }
  int getDiameter() {
    return dimensions.dims[1];
  }
  int getRadius() {
    return getDiameter() / 2;
  }
  void rest() {
    this.stick = new Point(resting);
  }
  void restVertical() {
    this.stick = new Point(this.stick.x, this.resting.y);
  }
  void restHorizontal() {
    this.stick = new Point(this.resting.x, this.stick.y);
  }
  Joystick setResting(Point point) {
    this.resting = point;
    return this;
  }
  void display() {
   stroke(0);
   noFill();
   point(point.x,point.y);
   ellipse(point.x,point.y,getDiameter(),getDiameter());
   if(this.pressed) fill(125);
   ellipse(stick.x,stick.y,dimensions.dims[0],dimensions.dims[0]);
   if(stick.dist(point) > dimensions.dims[0] / 2) {
     line(point.x, point.y, stick.x + dimensions.dims[0] / 2 * cos(point.heading(stick)), stick.y + dimensions.dims[0] / 2 * sin(point.heading(stick)));
   }
  }
  boolean isTarget() {
    return isTargetEllipse(this.stick, this.dimensions);
  }
  void onHover() {}
  void onPress() {
    this.mouseDisplacement = PVector.sub(new PVector(mouseX,mouseY),new PVector(this.stick.x,this.stick.y));
  }
  void onDrag(PVector drag) {
    this.stick.sub(drag);
    //output_state();
  }
  void onRelease() {
    this.rest();
    //output_state();
  }
  String toString() {
    String res = "";
    res += (int)OUTPUT_RANGE - floor(-(min(max(point.y - stick.y,-getRadius()),getRadius()) / (float)getRadius() * OUTPUT_RANGE/2.0) + OUTPUT_RANGE/2);
    res += ",";
    res += floor(-(min(max(point.x - stick.x,-getRadius()),getRadius())  / (float)getRadius() * OUTPUT_RANGE/2.0) + OUTPUT_RANGE/2);
    return res;
  }
}

class Joystick_Left extends Joystick {
  Joystick_Left(Joystick joystick) {
    super(joystick.point,joystick.dimensions);
  }
  Joystick_Left(Point point, Dimensions dimensions) {
    super(point,dimensions);
  }
  void rest() {
    restHorizontal();
  }
}

class Joystick_Right extends Joystick {
  Joystick_Right(Joystick joystick) {
    super(joystick.point,joystick.dimensions);
  }
  Joystick_Right(Point point, Dimensions dimensions) {
    super(point,dimensions);
  }
  void rest() {
    restHorizontal();
    restVertical();
  }
}
/***********************************************************************************************/



/***********************************************************************************************/
class CheckBox extends Widget {
  boolean checked = false;
  CheckBox(Point point, Dimensions dimensions) {
    super(point,dimensions);
  }
  void check() {
    this.checked = !this.checked;
  }
  void display() {
    if(checked) {
      fill(0);
      noStroke();
    } else if(isTarget()) {
      fill(125);
      stroke(0);
    } else {
      fill(255);
      stroke(0);
    }
    rectMode(CORNER);
    rect(point.x,point.y,dimensions.dims[0],dimensions.dims[1]);
  }
  boolean isTarget() {
    return isTargetRect(this.point, this.dimensions);
  }
  void onRelease() {
    this.check();
  }
}
/***********************************************************************************************/



//Default slider is vertical. Dimensions: 0: x; 1: y; 2: value
/***********************************************************************************************/
abstract class Slider extends Widget {
  Slider(Point point, Dimensions dimensions) {
    super(point,dimensions);
  }
  String toString() {
    return str(floor(this.getValue() * OUTPUT_RANGE));
  }
  
  float getValue() {return -1;}
  
  void setHeight(float Height) {setHeight(Height);}
  void setWidth(float Width) {setWidth(Width);}
  
  void setHeight(int Height) {
    this.dimensions.dims[2] = (int)limit(Height,0,dimensions.dims[1]);
  }
  void setWidth(int Width) {
    this.dimensions.dims[2] = (int)limit(Width,0,dimensions.dims[0]);
  }
  void display() {
    text(getValue(),this.point.x, this.point.y - 15);
    fill(255);
    stroke(0);
    rect(point.x, point.y, dimensions.dims[0],dimensions.dims[1]);
  }
  boolean isTarget() {
    return isTargetRect(this.point, this.dimensions);
  }
  void onPress() {
    setHeight(-mouseY + point.y + dimensions.dims[1]);
  }
  void onDrag(PVector mouse) {
    setHeight(-mouseY + point.y + dimensions.dims[1]);
  }
}

class Vertical_Slider extends Slider {
  Vertical_Slider(Point point, Dimensions dimensions) {
    super(point, dimensions);
  }
  void display() {
    super.display();
    fill(0);
    rect(point.x, point.y + dimensions.dims[1], dimensions.dims[0], -dimensions.dims[2]);
  }  
  float getValue() {
    return this.dimensions.dims[2] / (float)this.dimensions.dims[1];
  }
  void onPress() {
    setHeight(-mouseY + point.y + dimensions.dims[1]);
  }
  void onDrag(PVector mouse) {
    setHeight(-mouseY + point.y + dimensions.dims[1]);
  }
}

class Horizontal_Slider extends Slider {
  Horizontal_Slider(Point point, Dimensions dimensions) {
    super(point, dimensions);
  }
  void display() {
    super.display();
    fill(0);
    rect(point.x, point.y, dimensions.dims[2], dimensions.dims[1]);
  }
  float getValue() {
    return this.dimensions.dims[2] / (float)this.dimensions.dims[0];
  }
  void onPress() {
    setWidth(mouseX - point.x);
  }
  void onDrag(PVector mouse) {
    setWidth(mouseX - point.x);
  }
}
/***********************************************************************************************/


/***********************************************************************************************/
class Label extends Widget {
  String name;
  int font_size = DEFAULT_TEXT_SIZE;
  int modifier = LEFT;
  //color textColor
  Label(Point point, String name) {
    super(point,null);
    this.name = name;
  }
  void display() {
    textSize(font_size);
    textAlign(modifier);
    fill(0);
    text(name, point.x, point.y + font_size);
  }
  boolean isTarget() {
    return false;
  }
}
/***********************************************************************************************/



/***********************************************************************************************/
class Reset_TextBox extends AbstractCommand {
  TextBox target;
  Reset_TextBox(TextBox target) {
    this.target = target;
  }
  void execute() {
    target.reset();
  }
}

/*use this for getting typed input*/
class TextBox extends Widget implements Enter, Backspace {
  String text;
  int font_size = DEFAULT_TEXT_SIZE;
  int modifier = LEFT;
  TextBox(Point point, Dimensions dimensions) {
    super(point, dimensions);
    this.text = "";
  }
  private void setText(String str) {
    this.text = str;
  }
  void reset() {
    this.setText("");
  }
  void publish() {
    //do something
    println("User: " + this.text);
  }
  void display() {
    if(this.selected) {
      fill(color(0,200,180));
      rect(this.point.x - 2, this.point.y - 2, this.dimensions.dims[0] + 4,this.dimensions.dims[1] + 4);
    }
    fill(255);
    stroke(0);
    rect(this.point.x, this.point.y, this.dimensions.dims[0],this.dimensions.dims[1]);
    fill(0);
    text(text, point.x, point.y + font_size);
  }
  boolean isTarget() {
    return isTargetRect(this.point, this.dimensions);
  }
  void onKeyDown(char c) {
    switch(c) {
      case BACKSPACE: 
      case DELETE: onBackspace();
        break;
      case ENTER:
      case RETURN: onEnter();
        break;
      default: this.text += c;
    }
  }
  void onRelease() {
    this.select();
  }
  void onEnter() {
    this.publish();
    this.reset();
    //this.text += '\n';
  }
  void onBackspace() {
    if(this.text.length() > 0) this.text = this.text.substring(0, this.text.length() - 1);
  }
}
/***********************************************************************************************/



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
  Ball(Point point, Dimensions dimensions) {
    super(point, dimensions);
    vel = new PVector();
    this.selected = true;
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
  }
  
  //override release() to stop ball from being deselected
  void release(PVector mouse, PVector dragment) {}
  
  //rules
  ////////////
  boolean outOfBounds() {
    return this.point.x < 0 ||
           this.point.x > width ||
           this.point.y < 0 ||
           this.point.y > height;
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
  void processKey(char c) {
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
  
  //interaction
  ////////////
  void onDrag(PVector drag) {
    this.point.sub(drag);
  }
  void onKeyHold(char c) {
    processKey(c);
  }
}
/////////////////////////////////////////////////////////////////////////////////////////////////
/***********************************************************************************************/
