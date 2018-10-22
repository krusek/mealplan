import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mealplan/data/database.dart';
import 'package:mealplan/ui/active_meal_widget.dart';
import 'package:mealplan/ui/meal_plan.dart';
import 'package:mealplan/ui/splash.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.blueAccent,
      ),
      color: Colors.blue,
      routes: {
        "/": (context) => Splash(),
        "/home/": (context) => HomeScaffold(child: MyHomePage(DatabaseProvider.of(context).activeMeals)),
        "/saved_meals/": (context) => HomeScaffold(child: SavedMealsWidget(), showActions: false,),
      },
      builder: (ctx, navigator) {
        return DatabaseProvider(child: navigator);
      },
    );
  }
}

class HomeScaffold extends StatelessWidget {
  final Widget child;
  final bool showActions;
  const HomeScaffold({
    Key key, this.child, this.showActions = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final actions = <Widget>[
      FlatButton(
        onPressed: () {
          Navigator.of(context).pushNamed("/saved_meals/");
        },
        child: Text("Meals", style: TextStyle(color: Colors.white),),
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text("Meal plan"),
        backgroundColor: Colors.blue,
        actions: this.showActions ? actions : [],
      ),
      body: this.child,
    );
  }
}

class MyHomePage extends StatelessWidget {
  final List<ActiveMeal> activeMeals;
  MyHomePage(this.activeMeals);
  @override
  Widget build(BuildContext context) {
    final database = DatabaseProvider.of(context);
    return StreamBuilder(
      initialData: this.activeMeals,
      stream: database.activeMealaStream,
      builder: (context, data) {
        return SingleChildScrollView(
          child: Column(
            children: activeMeals.map((meal) { 
              return ActiveMealWidget(activeMeal: meal); 
            }).toList()
          ),
        );
      }
    );
  }
}