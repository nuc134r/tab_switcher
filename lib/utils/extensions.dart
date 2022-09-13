import 'package:flutter/material.dart';

extension TabSwitcherColorUtils on Color {
  Color get onColor {
    return computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }
}
