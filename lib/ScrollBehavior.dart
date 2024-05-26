import 'package:flutter/material.dart';
import 'package:agahi_app/widget/customScaffold.dart';

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
