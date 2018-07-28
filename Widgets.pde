/***********************************************************************************************/
class Point {
  int x, y;
  Point(Point point) {
    this.x = point.x;
    this.y = point.y;
  }
  Point(int x, int y) {
    this.x = x;
    this.y = y;
  }
  Point add(Point that) {
    return new Point(this.x + that.x, this.y + that.y);
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
}
/***********************************************************************************************/


/***********************************************************************************************/
class View {
  String name;
  ArrayList<Button> buttons = new ArrayList<Button>();
  ArrayList<Widget> widgets = new ArrayList<Widget>();
  View() {
    system.add(this);
    this.name = "This view is anonymous";
  }
  View(String name) {
    system.add(this);
    this.name = name;
  }
  String toString() {
    return this.name;
  }
  void add(Button button) {
    this.buttons.add(button);
  }
  void add(Widget widget) {
    this.widgets.add(widget);
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
}
/***********************************************************************************************/



/////////////////////////////////////////////////////////////////////////////////////////////////
interface Displayable {
  void display();
}
/////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////
abstract class Widget extends Observer implements Displayable {
  Point point;
  Dimensions dimensions;
  Widget(Point point, Dimensions dimensions) {
    system.mouseListener.add(this);
    system.keyboardListener.add(this);
    this.point = point;
    this.dimensions = dimensions;
  }
  void display() {}
  Boolean isTarget() {return false;}
  void onHover() {}
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
  
  Boolean isTarget() {
    return isTargetRect(this.point, this.dimensions);
  }
  void execute() {
    this.command.execute();
  }
  void queue() {
    system.commands.add(this);
  }
  void onHover() {}
  void onPress() {}
  void onDrag(PVector mouse) {}
  void onRelease() {
    
    if(this.attributes != null) {
      this.attributes.onRelease.queue();
    } else {
      this.queue();
    }
    
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
  int getRadius() {
    return dimensions.dims[0] / 2;
  }
  void display() {
   stroke(0);
   noFill();
   point(point.x,point.y);
   ellipse(point.x,point.y,dimensions.dims[0],dimensions.dims[0]);
   fill(0);
   line(point.x, point.y, point.x + dimensions.dims[0] / 2 * cos(heading), point.y + dimensions.dims[0] / 2 * sin(heading));
  }
  Boolean isTarget() {
    return isTargetEllipse(this.point, this.dimensions);
  }
  void onHover() {}
  void onPress() {
    this.mouseDisplacement = PVector.sub(new PVector(mouseX,mouseY),new PVector(this.point.x,this.point.y));
  }
  void onDrag(PVector drag) {
    this.heading += PVector.sub(new PVector(mouseX,mouseY),this.point.toPVector()).heading() - PVector.sub(new PVector(pmouseX,pmouseY),this.point.toPVector()).heading();
  }
  void onRelease() {}
  //String toString() {
  //  String res = "";
  //  res += (int)OUTPUT_RANGE - floor(-(min(max(point.y - stick.y,-getRadius()),getRadius()) / (float)getRadius() * OUTPUT_RANGE/2.0) + OUTPUT_RANGE/2);
  //  res += ",";
  //  res += floor(-(min(max(point.x - stick.x,-getRadius()),getRadius())  / (float)getRadius() * OUTPUT_RANGE/2.0) + OUTPUT_RANGE/2);
  //  return res;
  //}
  String toString() {
    return ""+heading;
  }
}


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
  int getRadius() {
    return dimensions.dims[1] / 2;
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
   ellipse(point.x,point.y,dimensions.dims[1],dimensions.dims[1]);
   if(this.pressed) fill(125);
   ellipse(stick.x,stick.y,dimensions.dims[0],dimensions.dims[0]);
   if(stick.dist(point) > dimensions.dims[0] / 2) {
     line(point.x, point.y, stick.x + dimensions.dims[0] / 2 * cos(point.heading(stick)), stick.y + dimensions.dims[0] / 2 * sin(point.heading(stick)));
   }
  }
  Boolean isTarget() {
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
  Boolean isTarget() {
    return isTargetRect(this.point, this.dimensions);
  }
  void onHover() {}
  void onPress() {}
  void onDrag(PVector mouse) {}
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
  Boolean isTarget() {
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
  color textColor
  Label(String name, Point point) {
    super(point,null);
    this.name = name;
  }
  
  void display() {
    textSize(font_size);
    textAlign(modifier);
    fill(0);
    text(name, point.x, point.y + font_size);
  }
  Boolean isTarget() {
    return false;
  }
  void onHover() {}
  void onPress() {}
  void onDrag(PVector mouse) {}
  void onRelease() {}
}
/***********************************************************************************************/

//class KeyboardWidget extends Widget {

//}
class Reset_TextBox implements Command {
  TextBox target;
  Reset_TextBox(TextBox target) {
    this.target = target;
  }
  void queue() {
    system.commands.add(this);
  }
  void execute() {
    target.text = "";
  }
}

/*use this for getting typed input*/
class TextBox extends Widget implements  Enter, Backspace {
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
    println(this.text);
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
  Boolean isTarget() {
    return isTargetRect(this.point, this.dimensions);
  }
  void onKeyDown(char c) {
    switch(c) {
      case BACKSPACE: onBackspace();
        break;
      case ENTER: onEnter();
        break;
      case RETURN: onEnter();
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
    //this.text +="delete";
    if(this.text.length() > 0) this.text = this.text.substring(0, this.text.length() - 1);
  }
}
