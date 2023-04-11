import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class Functions {
  static isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static bool checkConnectionError(e) {
    if (e.toString().contains('SocketException') ||
        e.toString().contains('HandshakeException')) {
      return true;
    } else {
      return false;
    }
  }

  static Future<String> translate(String input) async {
    final translator = GoogleTranslator();
    var translation = await translator.translate(input, to: 'vi');
    return translation.text;
  }
}
