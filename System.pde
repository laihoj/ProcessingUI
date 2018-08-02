static class System {
  static CSS_File css = null;
  static ArrayList<View> views = new ArrayList<View>();
  static ArrayList<Command> commands = new ArrayList<Command>();
  static View active_view = null;
  static Container navigation_bar = null;
  //System() {
  //  views = new ArrayList<View>();
  //  commands = new ArrayList<Command>();
  //  active_view = null;
  //  navigation_bar = null;
  //}
  
  
  static void add(View view) {
    views.add(view);
  }
  static void remove(View view) {
    views.remove(view);
  }
  static void activate(View view) {
    active_view = view;
  }
  static void display() {
    if(navigation_bar != null) {
      navigation_bar.display();
    }
    if(active_view != null) {
      active_view.display();
    }
  }
  static void listen() {
    if(navigation_bar != null) {
      navigation_bar.listen();
    }
    if(active_view != null) {
      active_view.listen();
    }
  }
  static void execute() {
    for(Command command: commands) {
      command.execute();
    }
    commands = new ArrayList<Command>();
  }
  static void next() {
    listen();
    display();
    execute();
  }
  
  
  /*
  Utilitarian:
  Gets parsed to int system value from css style file of a certain name
  */
  static int getInt(String name) {
    try {
      return Integer.parseInt(getProperty("system", name));
    } catch (NumberFormatException e) {
      println("Problem with Selector:Property system:" + name + ",  " + e);
      //exit();
      return -1;
    }
  }
  
  
  ////////////css stuff
  /*gets css value corresponding to a parametrised selector and property*/
  static String getProperty(String selector, String property) {
    try {
      return getSelector(selector).get(property);
    } catch (NullPointerException e) {
      println("Selector:Property " + selector + ":" + property + " was not found: " + e);
      //exit();
      return "Error, please read console for more details";
    }
  }
  
  /*gets css block corresponding to a parametrised selector*/
  static HashMap<String, String> getSelector(String string) {
    return getProperties().get(string);
  }
  
  
  /*Returns the datastructure of the css file read earlier*/
  static HashMap<String, HashMap<String, String>> getProperties() {
    return css.properties;
  }
  
  static CSS_File getCSS() {
    return css;
  }
  static void add(CSS_File file) {
    css = file;
  }
  ///////////no more css stuff
}

/***********************************************************************************************/
//Activates another view
class ChangeView extends AbstractCommand {
  View target;
  ChangeView(View target) {
    this.target = target;
  }
  void execute() {
    println("View changing from " + System.active_view.toString() + " to " + this.target);
    System.activate(target);
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
    System.commands.add(this);
  }
}

class DoNothing extends AbstractCommand {
  DoNothing() {}
  void execute() {}
}
/////////////////////////////////////////////////////////////////////////////////////////////////
