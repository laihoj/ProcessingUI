float limit(float value, float min, float max) {
  return min(max,max(min,value));
}


boolean isTargetRect(Point point, Dimensions dimensions) {
  return mouseX > point.x
        && mouseX < point.x + dimensions.dims[0] 
        && mouseY > point.y 
        && mouseY < point.y + dimensions.dims[1];
}

//untested
boolean isTargetEllipse(Point point, Dimensions dimensions) {
  return dimensions.dims[0] / 2 > sqrt((float)(Math.pow(point.x - mouseX,2) + Math.pow(point.y - mouseY,2)));
}



/***********************************************************************************************/
Button newButton(Command command, String text, color c, Point point, Dimensions dimensions) {
  Button result = new Button(command,text,c,point,dimensions);
  system.mouseListener.add(result);
  return result;
}

//Button newButton(String css_class, String css_id, String css_name, String text, Point point, Dimensions dimensions) {
//}

//Button newButton(Command command, String text, String css_class, String css_id, String css_name, CSS_File css_file, Point point, Dimensions dimensions) {
//  Button result = new Button(command,text,css_class,point,dimensions);
//  system.mouseListener.add(result);
//  return result;
//}

//preferable notation
Button newButton(Attributes attributes, String text, Point point, Dimensions dimensions) {
  Button result = new Button(attributes, text, point, dimensions);
  system.mouseListener.add(result);
  return result;
}
/***********************************************************************************************/




/*********
Android utils - comment out when not testing on mobile device
*********/


///***********************************************************************************************/
//class Discover implements Command {
//  Discover() {}
//  void execute() {
//    bt.discoverDevices();
//  }
//  void queue() {
//    system.commands.add(this);
//  }
//}
///***********************************************************************************************/



///***********************************************************************************************/
//class MakeDiscoverable implements Command {
//  MakeDiscoverable() {}
//  void execute() {
//    bt.makeDiscoverable();
//  }
//  void queue() {
//    system.commands.add(this);
//  }
//}
///***********************************************************************************************/




///***********************************************************************************************/
//class Connect implements Command {
//  Connect() {}
//  void execute() {
//    if(bt.getDiscoveredDeviceNames().size() > 0)
//      klist = newKetaiList_getDiscoveredDeviceNames();
//    else if(bt.getPairedDeviceNames().size() > 0)
//      klist = newKetaiList_getPairedDeviceNames();
//    }
//  void queue() {
//    system.commands.add(this);
//  }
//}
///***********************************************************************************************/



 
//KetaiList newKetaiList_getDiscoveredDeviceNames() {
//  return new KetaiList(this, bt.getDiscoveredDeviceNames());
//}

//KetaiList newKetaiList_getPairedDeviceNames() {
//  return new KetaiList(this, bt.getPairedDeviceNames());
//}
