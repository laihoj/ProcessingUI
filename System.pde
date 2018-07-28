class System {
  CSS_File css = null;
  ArrayList<View> views;
  ArrayList<Command> commands;
  View active_view;
  View action_bar;
  System() {
    views = new ArrayList<View>();
    commands = new ArrayList<Command>();
    active_view = null;
    action_bar = null;
  }
  
  /*
  Utilitarian:
  Gets parsed to int system value from css style file of a certain name
  */
  int getInt(String name) {
    try {
      return Integer.parseInt(this.getProperty("system", name));
    } catch (NumberFormatException e) {
      println("Problem with Selector:Property system:" + name + ",  " + e);
      exit();
      return -1;
    }
  }
  
  /*gets css value corresponding to a parametrised selector and property*/
  String getProperty(String selector, String property) {
    try {
      return getSelector(selector).get(property);
    } catch (NullPointerException e) {
      println("Selector:Property " + selector + ":" + property + " was not found: " + e);
      exit();
      return "Error, please read console for more details";
    }
  }
  
  /*gets css block corresponding to a parametrised selector*/
  HashMap<String, String> getSelector(String string) {
    return getProperties().get(string);
  }
  
  
  /*Returns the datastructure of the css file read earlier*/
  HashMap<String, HashMap<String, String>> getProperties() {
    return css.properties;
  }
  
  //String getProperty(String... selectors) throws NoSuchPropertyDefinedException {
  //  return "";
  //}
  
  CSS_File getCSS() {
    return this.css;
  }
  void add(CSS_File css) {
    this.css = css;
  }
  void add(View view) {
    this.views.add(view);
  }
  void remove(View view) {
    this.views.remove(view);
  }
  void removeTopWidget() {
    int active_view_widgets_latest = active_view.widgets.size() - 1;
    if(active_view_widgets_latest > 0) {
      Widget top_widget = active_view.widgets.get(active_view_widgets_latest);
      this.active_view.remove(top_widget);
    }
  }
  void activate(View view) {
    this.active_view = view;
  }
  void display() {
    if(this.action_bar != null) {
      this.action_bar.display();
    }
    if(this.active_view != null) {
      this.active_view.display();
    }
  }
  void listen() {
    if(this.action_bar != null) {
      this.action_bar.listen();
    }
    if(this.active_view != null) {
      this.active_view.listen();
    }
  }
  void execute() {
    for(Command command: this.commands) {
      command.execute();
    }
    this.commands = new ArrayList<Command>();
  }
  void next() {
    this.listen();
    this.display();
    this.execute();
  }
}

/***********************************************************************************************/
//Activates another view
class ChangeView extends AbstractCommand {
  View target;
  ChangeView(View target) {
    this.target = target;
  }
  void execute() {
    println("View changing from " + system.active_view.toString() + " to " + this.target);
    system.activate(target);
  }
}
/***********************************************************************************************/



/////////////////////////////////////////////////////////////////////////////////////////////////
interface Command {
  boolean executed = false;
  void execute();
  void queue();
}

abstract class AbstractCommand implements Command {
  void queue() {
    system.commands.add(this);
  }
}

class DoNothing extends AbstractCommand {
  DoNothing() {}
  void execute() {}
}
/////////////////////////////////////////////////////////////////////////////////////////////////
