import 'dart:ui';

class BarDrawingAreaConfig {
  BarDrawingAreaConfig();


 late Size _size;
  Size get size => _size;


 void adjustSize(Size newSize) {
   _size = newSize;
 }
}