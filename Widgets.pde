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
  Point() {
    this.x = 0;
    this.y = 0;
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
  Dimensions(int a) {
    this.dims = new int[]{a,0};
  }
  Dimensions(int a, int b) {
    this.dims = new int[]{a,b};
  }
  Dimensions(int... dims) {
    this.dims = dims;
  }
  Dimensions(Dimensions dimensions) {
    this.dims = new int[dimensions.dims.length];
    for(int i = 0; i < dimensions.dims.length; i++) {
      this.dims[i] = dimensions.dims[i];
    }
    //this.dims = dimensions.dims;
  }
}
/***********************************************************************************************/


/***********************************************************************************************/
/////////////////////////////////////////////////////////////////////////////////////////////////
class View {
  String name;
  ArrayList<Container> containers = new ArrayList<Container>();
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
  View add(Button button) {
    this.buttons.add(button);
    this.mouseListener.add(button);
    this.keyboardListener.add(button);
    return this;
  }
  View add(Widget widget) {
    this.widgets.add(widget);
    this.mouseListener.add(widget);
    this.keyboardListener.add(widget);
    return this;
  }
  Container add(Container container) {
    this.containers.add(container);
    return container;
  }
  void remove(Button button) {
    this.buttons.remove(button);
  }
  void remove(Widget widget) {
    this.widgets.remove(widget);
  }
  void display() {
    for(Container container: this.containers) {
      container.display();
    }
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
    for(Container container: this.containers) {
      container.listen();
    }
  }
}
/////////////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////////////////
class Container extends View {
  Point point;
  Dimensions dimensions;
  Container() {
    this(new Point(TOP_LEFT), new Dimensions(FULL_SCREEN), "ANONYMOUS CONTAINER");
  }
  Container(Dimensions dimensions) {
    this(new Point(TOP_LEFT), dimensions, "ANONYMOUS CONTAINER");
  }
  Container(Point point, Dimensions dimensions) {
    this(point, dimensions, "ANONYMOUS CONTAINER");
  }
  Container(Point point, Dimensions dimensions, String name) {
    this.name = name;
    this.point = point;
    this.dimensions = dimensions;
  }
  
  //this is stupid. Have button and widget and container extend a common element class
  Container add(Button button) {
    super.add(button);
    int margin = 4;
    int Height = this.dimensions.dims[1];
    button.setHeight(Height);
    if(button.point.y > this.point.y + Height || button.point.y < this.point.y) {
      button.point.y = this.point.y;
    }
    int Width = this.dimensions.dims[0] / this.buttons.size() - margin * 2;
    for(int i = 0; i < this.buttons.size(); i++) {
      Button b = this.buttons.get(i);
      b.setWidth(Width);
      b.setX(margin + this.point.x + (Width + margin * 2) * i);
    }
    return this;
  }
  Container add(Rotator widget) {
    super.add(widget);
    int margin = 4;
    int diameter = min(this.dimensions.dims[0],this.dimensions.dims[1]);
    widget.setDiameter(diameter);
    widget.setY(this.point.y);
    
    for(int i = 0; i < this.widgets.size(); i++) {
      Widget b = this.widgets.get(i);
      b.setX(margin + this.point.x + (diameter + margin * 2) * i);
    }
    return this;
  }
  //View add(Widget widget) {
  //  super.add(widget);
  //  int margin = 4;
  //  //int Width = min(this.dimensions.dims[0],this.dimensions.dims[1]);
  //  //int Height = min(this.dimensions.dims[0],this.dimensions.dims[1]);
  //  int Width = this.dimensions.dims[0];
  //  int Height = this.dimensions.dims[1];
  //  widget.setHeight(Height);
  //  widget.setWidth(Width);
  //  if(widget.point.y > this.point.y + Height || widget.point.y < this.point.y) {
  //    widget.setY(this.point.y + Height / 2);
  //  }
    
  //  for(int i = 0; i < this.widgets.size(); i++) {
  //    Widget b = this.widgets.get(i);
  //    b.setX(this.point.x + Width+ Width * i);
  //  }
  //  return this;
  //}
  void display() {
    super.display();
    noFill();
    stroke(0);
    rect(this.point, this.dimensions);
  }
}
/////////////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////////////////
class Grid extends Container {
  Container[][] cells;
  //indices
  int x, y;
  Grid(Point point, Dimensions dimensions, int x, int y) {
    this.point = point;
    this.dimensions = dimensions;
    this.x = x;
    this.y = y;
    this.cells = new Container[x][y];
    //Have all cells use this dimensions object, that way changing one changes all
    Dimensions cellDims = new Dimensions(this.dimensions.dims[0] / x, this.dimensions.dims[1] / y);
    for(int j = 0; j < this.y; j++) {
      for(int i = 0; i < this.x; i++) {
        cells[i][j] = new Container(new Point(this.point.x + cellDims.dims[0] * i, this.point.y + cellDims.dims[1] * j), cellDims);
      }
    }
  }
  Grid(int x, int y) {
    this(TOP_LEFT, FULL_SCREEN, x, y);
  }
  void display() {
    for(Container[] row: this.cells) {
      for(Container container: row) {
        container.display();
        noFill();
        stroke(0);
        rect(container.point, container.dimensions);
      }
    }
    
  }
  void listen() {
    super.listen();
    for(Container[] row: this.cells) {
      for(Container container: row) {
        container.listen();
      }
    }
  }
}
/////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////
class CheckBox_Grid extends Grid {
  CheckBox_Grid(Point point, Dimensions dimensions, int x, int y) {
    super(point, dimensions, x, y);
    for(Container[] row: this.cells) {
      for(Container container: row) {
        container.add(new CheckBox(new Point(container.point), new Dimensions(container.dimensions)));
      }
    }
  }
}
/////////////////////////////////////////////////////////////////////////////////////////////////
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
  void onMouseHover() {}
  void onMouseHoverOver() {}
  void onMousePress() {}
  void onMouseDrag(PVector mouse) {}
  void onMouseHold() {}
  void onMouseRelease() {}
  
  void onKeyDown(char c) {}
  void onKeyHold(char c) {}
  void onKeyUp(char c) {}
  boolean isSelected() {return selected;}
  void setWidth(int Width) {
    this.dimensions.dims[0] = Width;
  }
  void setHeight(int Height) {
    this.dimensions.dims[1] = Height;
  }
  void setDiameter(int diameter) {
    this.dimensions.dims[0] = diameter;
  }
  void setX(float x) {
    this.point = new Point(x, this.point.y);
  }
  void setY(float y) {
    this.point = new Point(this.point.x, y);
  }
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
  void onMouseRelease() {  
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
  Navigation_Button(View target) {
    super(new ChangeView(target), target.name, color(255), TOP_LEFT, BUTTON_DEFAULT_DIMENSIONS);
  }
}
/***********************************************************************************************/




//The dimensions.dim[0] refers to the diameter of the outer circle  
/***********************************************************************************************/
class Rotator extends Ellipse_Widget {
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
   translate(point.x + this.getRadius(), point.y + this.getRadius());
   rotate(heading);
   line(0,0, this.getRadius(), 0);
   popMatrix();
   fill(0);
   text(this.toString(), point.x + this.getRadius(), point.y);
   noFill();
   rect(this.point.x,this.point.y, this.getDiameter(),this.getDiameter());
  }
  void onMousePress() {
    this.mouseDisplacement = PVector.sub(new PVector(mouseX,mouseY),new PVector(this.point.x,this.point.y));
  }
  void onMouseDrag(PVector drag) {
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
class Joystick extends Ellipse_Widget {
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
   ellipse(point.x - getDiameter() / 2, point.y - getDiameter() / 2, getDiameter(), getDiameter());
   if(this.pressed) fill(125);
   ellipse(stick.x - dimensions.dims[0] / 2, stick.y - dimensions.dims[0] / 2, dimensions.dims[0], dimensions.dims[0]);
   if(stick.dist(point) > dimensions.dims[0] / 2) {
     line(point.x, point.y, stick.x + dimensions.dims[0] / 2 * cos(point.heading(stick)), stick.y + dimensions.dims[0] / 2 * sin(point.heading(stick)));
   }
  }
  boolean isTarget() {
    return isTargetEllipse(this.stick, this.dimensions);
  }
  void onMousePress() {
    this.mouseDisplacement = PVector.sub(new PVector(mouseX,mouseY),new PVector(this.stick.x,this.stick.y));
  }
  void onMouseDrag(PVector drag) {
    this.stick.sub(drag);
    //output_state();
  }
  void onMouseRelease() {
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
  String text;
  boolean checked = false;
  CheckBox(Point point, Dimensions dimensions) {
    super(point,dimensions);
    this.text = "";
  }
  CheckBox(Point point, Dimensions dimensions, String text) {
    super(point, dimensions);
    this.text = text;
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
    text(text,point.x,point.y);
  }
  boolean isTarget() {
    return isTargetRect(this.point, this.dimensions);
  }
  void onMouseRelease() {
    this.check();
  }
}
/***********************************************************************************************/



//Default slider is vertical. Dimensions: 0: x; 1: y; 2: value
/***********************************************************************************************/
/////////////////////////////////////////////////////////////////////////////////////////////////
abstract class Slider extends Widget {
  int output_range;
  Slider(Point point, Dimensions dimensions) {
    super(point,dimensions);
    this.output_range = 1;
  }
  Slider(Point point, Dimensions dimensions, int output_range) {
    this(point,dimensions);
    this.output_range = output_range;
  }
  String toString() {
    return str(floor(this.getValue() * OUTPUT_RANGE));
  }
  
  float getValue() {return -1;}
  
  void setHeight(float Height) {
    this.dimensions.dims[2] = (int)limit(Height,0,dimensions.dims[1]);
  }
  void setWidth(float Width) {
    this.dimensions.dims[2] = (int)limit(Width,0,dimensions.dims[0]);
  }
  void display() {
    //text(getValue(),this.point.x, this.point.y - 15);
    fill(255);
    stroke(0);
    rect(point.x, point.y, dimensions.dims[0],dimensions.dims[1]);
  }
  boolean isTarget() {
    return isTargetRect(this.point, this.dimensions);
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////////
class Vertical_Slider extends Slider {
  Vertical_Slider(Point point, Dimensions dimensions) {
    super(point, dimensions);
  }
  Vertical_Slider(Point point, Dimensions dimensions, int output_range) {
    super(point, dimensions, output_range);
  }
  void display() {
    super.display();
    fill(0);
    rect(point.x, point.y + dimensions.dims[1], dimensions.dims[0], -dimensions.dims[2]);
  }  
  float getValue() {
    return this.dimensions.dims[2] / (float)this.dimensions.dims[1] * this.output_range;
  }
  void onMouseDrag(PVector mouse) {
    setHeight(-mouseY + point.y + dimensions.dims[1]);
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////////
class Horizontal_Slider extends Slider {
  Horizontal_Slider(Point point, Dimensions dimensions) {
    super(point, dimensions);
  }
  Horizontal_Slider(Point point, Dimensions dimensions, int output_range) {
    super(point, dimensions, output_range);
  }
  void display() {
    super.display();
    fill(0);
    rect(point.x, point.y, dimensions.dims[2], dimensions.dims[1]);
  }
  float getValue() {
    return this.dimensions.dims[2] / (float)this.dimensions.dims[0] * this.output_range;
  }
  void onMouseDrag(PVector mouse) {
    setWidth(mouseX - point.x);
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////////
class CSS_Slider extends Horizontal_Slider {
  String selector, property;
  CSS_Slider(Point point, Dimensions dimensions, int output_range, String selector, String property) {
    super(point, dimensions, output_range);
    this.selector = selector;
    this.property = property;
  }
  void display() {
    super.display();
    fill(0);
    text(getValue(),this.point.x + this.dimensions.dims[0], this.point.y + 15);
  }
  String getSelector() {
    return this.selector;
  }
  String getProperty() {
    return this.property;
  }
  float getValue() {
    return super.getValue();
  }
}
/////////////////////////////////////////////////////////////////////////////////////////////////
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
  void onMouseRelease() {
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
