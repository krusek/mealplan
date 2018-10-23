import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeScaffold extends StatelessWidget {
  final Widget child;
  final List<Widget> actions;
  const HomeScaffold({
    Key key, this.child, this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meal plan"),
        backgroundColor: Colors.blue,
        actions: this.actions,
      ),
      body: this.child,
    );
  }
}