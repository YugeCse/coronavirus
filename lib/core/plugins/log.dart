import 'dart:typed_data';

import 'package:flutter/services.dart';

class Log {
  factory Log._() => null;

  static const MethodChannel _methodChannel =
      const MethodChannel('com.mrper.coronavirus.plugins.log-plugin');

  static void i(String tag, String messsage) =>
      _methodChannel.invokeMethod('i', {'tag': tag, 'message': messsage});

  static void e(String tag, String messsage) =>
      _methodChannel.invokeMethod('e', {'tag': tag, 'message': messsage});

  static void w(String tag, String messsage) =>
      _methodChannel.invokeMethod('e', {'tag': tag, 'message': messsage});

  static void println(dynamic object) {
    dynamic printObj;
    if ([num, int, double, String, Uint8List].contains(object.runtimeType))
      printObj = object;
    else
      printObj = object.toString();
    _methodChannel.invokeMethod('println', {'object': printObj});
  }
}
