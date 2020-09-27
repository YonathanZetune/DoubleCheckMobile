import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class DoubleCheckInfo extends ChangeNotifier {
  static String _currSession = "";

  String get currSession => _currSession;

  set currSession(String newSess) {
    _currSession = newSess;
    notifyListeners();
  }
}
