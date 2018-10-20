import 'package:flutter/material.dart';
import 'package:mealplan/data/database.dart';
import 'package:mealplan/ui/active_meal_widget.dart';
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
        "/home/": (context) => MyHomePage(),
      },
      builder: (context, navigator) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Meal plan"),
            backgroundColor: Colors.blue,
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/saved_meals/");
                },
                child: Text("Meals"),
              )
            ],
          ),
          body: DatabaseWidget(child: navigator),
        );
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final database = DatabaseWidget.of(context);
    return SingleChildScrollView(
          child: Column(
        children: database.activeMeals.map((meal) { return ActiveMealWidget(activeMeal: meal); }).toList(),
      ),
    );
  }

}


