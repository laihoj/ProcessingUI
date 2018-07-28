/////////////////////////////////////////////////////////////////////////////////////////////////
interface Selectable {
  void select();
  void deselect();
}
/////////////////////////////////////////////////////////////////////////////////////////////////

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

void ellipse(Point point, Dimensions dimensions) {
  ellipse(point.x, point.y, dimensions.dims[0],dimensions.dims[0]);
}


abstract class Ellipse_Widget extends Widget {
  Ellipse_Widget(Point point, Dimensions dimensions) {
    super(point, dimensions);
  }
  boolean isTarget() {
    return isTargetEllipse(this.point, this.dimensions);
  }
}




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
