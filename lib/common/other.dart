import 'package:flutter/material.dart';

// Set Scroll Behavior of App.  Không có kiểu dãn dãn ra khi vuốt tới đáy
class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}


