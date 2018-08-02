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
  return dimensions.dims[0] / 2 > sqrt((float)(Math.pow(point.x + dimensions.dims[0] / 2 - mouseX,2) + Math.pow(point.y + dimensions.dims[0] / 2- mouseY,2)));
}

void ellipse(Point point, Dimensions dimensions) {
  ellipseMode(CORNER);
  ellipse(point.x, point.y, dimensions.dims[0], dimensions.dims[0]);
  //ellipse(point.x - dimensions.dims[0]/2, point.y - dimensions.dims[0]/2, dimensions.dims[0], dimensions.dims[0]);
}

void rect(Point point, Dimensions dimensions) {
  rect(point.x, point.y, dimensions.dims[0],dimensions.dims[1]);
}


abstract class Ellipse_Widget extends Widget {
  Ellipse_Widget(Point point, Dimensions dimensions) {
    super(new Point(point), new Dimensions(dimensions));
  }
  boolean isTarget() {
    return isTargetEllipse(this.point, this.dimensions);
  }
}

class Save_Configurations extends AbstractCommand {
  CSS_Slider[] css_widgets;
  Save_Configurations(CSS_Slider... widgets) {
    this.css_widgets = widgets;
  }
  void execute() {
    for(CSS_Slider widget: this.css_widgets) {
      System.css.put(widget.getSelector(),widget.getProperty(),""+(int)Math.floor(widget.getValue()));
    }
    System.css.save();
  }
}

class Switch_Weapon extends AbstractCommand {
  Shooter shooter;
  Shooter.Gun gun;
  Switch_Weapon(Shooter shooter, Shooter.Gun gun) {
    this.shooter = shooter;
    this.gun = gun;
  }
  void execute() {
    this.shooter.gun = gun;
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
