import 'package:sizer/sizer.dart';
abstract class LocalHelper {
  static double getFontSize(double fontSize) {
    fontSize = ((fontSize * 30.0) / 35.0).sp;
    return fontSize;
  }
}