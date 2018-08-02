/////////////////////////////////////////////////////////////////////////////////////////////////
//WebElements is a separate project in which
//I try to make java applications in HTML and CSS.
//This is probably worth splitting into its own project.
//For now, it remains partially in the HackDroneX project.
/////////////////////////////////////////////////////////////////////////////////////////////////


HashMap<String,HashMap<String,String>> readCSS(String filename) {
  HashMap<String,HashMap<String,String>> css_dictionary = new HashMap<String,HashMap<String,String>>();
  String file = "";
  String[] lines = loadStrings(filename);
  for(String line: lines) {
    line = line.trim();
    file += line;
  }
  for(String block: file.split("\\}")) {
    String[] selectorAndProperty = block.split("\\{");
    String selector = selectorAndProperty[0];
    String[] declarations = selectorAndProperty[1].split(":|;");
    HashMap<String,String> properties = new HashMap<String,String>();
    for(int i = 0; i < declarations.length; i += 2) {
      properties.put(declarations[i].trim(), declarations[i+1].trim());
    }
    css_dictionary.put(selector.trim(),properties);
  }
  return css_dictionary;
}

class CSS_File {
  String filename;
  HashMap<String,HashMap<String,String>> properties; 
  CSS_File(String filename) {
    this.filename = filename;
    properties = null;
    try {
      properties = readCSS(filename);
      println(this.toString());
    } catch(NullPointerException e) {
      println("failed to read css");
    }
  }
  //fix up toString, currently it should be called print instead of toString
  String toString() {
    String res = "";
    for(String k: this.properties.keySet()) {
      res += k+"{\n";
      for(String propertyKey: properties.get(k).keySet()) {
        res += propertyKey+":"+this.properties.get(k).get(propertyKey)+";\n";
      }
      res += "}\n";
    }
    return res;
  }
  void put(String selector, String property, String value) {
    this.properties.get(selector).put(property,value);
  }
  void save() {
    saveStrings("data/" + filename,split(this.toString(),'\n'));
  }
}

class Attributes {
  String css_class, css_id, css_name, css_style;
  int css_width, css_height;
  int css_x, css_y;
  Point point;
  Command onClick, onRelease; 
  Attributes(String css_class, String css_id, String css_name, String css_style, Command onClick, Command onRelease) {
    this.css_class = css_class;
    this.css_id = css_id;
    this.css_name = css_name;
    this.css_style = css_style;
    this.onClick = onClick;
    this.onRelease = onRelease;
  }
}

class Style {
  color stroke, fill;
  Style() {
    this.stroke = -1;
    this.fill = -1;
  }
  void apply() {
    if(stroke == -1) {noStroke();} else {stroke(255);}
    if(fill == -1) {noFill();} else {fill(255);}
  }
}