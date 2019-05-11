import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mealplan/data/database.dart';
import 'package:mealplan/navigation/navigation_provider.dart';
import 'package:provider/provider.dart';

class Splash extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(32.0),
            child: Text("Mealplan")
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (context == null) { return; }
    List<Future> futures = List();

    futures.add(Future.delayed(Duration(seconds: 1)));
    futures.add(Provider.of<Database>(context).loader(context));

    Future.wait(futures).then((_) {
      if (context == null) { return; }
      Provider.of<Navigation>(context).switchToHome();
    });
  }
}
