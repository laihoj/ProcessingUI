/***********************************************************************************************/
class Configure extends ChangeView {
  Configure() {
    super(CONFIGURE_MENU);
  }
}
/***********************************************************************************************/


/***********************************************************************************************/
class Home extends ChangeView {
  Home() {
    super(MAIN_MENU);
  }
}
/***********************************************************************************************/



/***********************************************************************************************/
class Fly extends ChangeView {
  Fly() {
    super(FLIGHT_MENU);
  }
}
/***********************************************************************************************/




//as can be seen, this didnt get very far
public class NoSuchSelectorException extends Exception {

  public NoSuchSelectorException(String message) {
    super(message);
  }

}

///***********************************************************************************************/
//Button newButton(Command command, String text, color c, Point point, Dimensions dimensions) {
//  Button result = new Button(command,text,c,point,dimensions);
//  system.mouseListener.add(result);
//  return result;
//}

////Button newButton(String css_class, String css_id, String css_name, String text, Point point, Dimensions dimensions) {
////}

////Button newButton(Command command, String text, String css_class, String css_id, String css_name, CSS_File css_file, Point point, Dimensions dimensions) {
////  Button result = new Button(command,text,css_class,point,dimensions);
////  system.mouseListener.add(result);
////  return result;
////}

////preferable notation
//Button newButton(Attributes attributes, String text, Point point, Dimensions dimensions) {
//  Button result = new Button(attributes, text, point, dimensions);
//  system.mouseListener.add(result);
//  return result;
//}
///***********************************************************************************************/
