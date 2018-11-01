
import 'package:flutter/widgets.dart';

class SafeAreaScrollView extends StatelessWidget {
  final Widget child;
  final bool top;
  final bool bottom;
  final bool left;
  final bool right;
  SafeAreaScrollView({this.child, this.top = true, this.bottom = true, this.left = true, this.right = true, Key key}): super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: SafeArea(bottom: this.bottom, top: this.top, left: this.left, right: this.right, child: this.child));
  }

}