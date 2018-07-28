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
