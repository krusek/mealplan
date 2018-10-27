import 'package:flutter/material.dart';
import 'package:mealplan/data/database_provider.dart';
import 'package:mealplan/data/firestore_provider.dart';
import 'package:mealplan/ui/active_meal_widget.dart';
import 'package:mealplan/ui/create_meal_widget.dart';
import 'package:mealplan/ui/home_scaffold.dart';
import 'package:mealplan/ui/saved_meals_widget.dart';
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
        "/home/": (context) => HomeScaffold(
          child: MyHomePage(),
            actions: MyHomePage.actions(context),
          ),
        "/saved_meals/": (context) => HomeScaffold(
          child: SavedMealsWidget(),
          actions: SavedMealsWidget.actions(context),
        ),
        "/create_saved_meal/": (context) => CreateMealWidget.createScaffold(),
      },
      builder: (ctx, navigator) {
        return FirestoreProvider(child: DatabaseProvider(child: navigator));
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage();
  @override
  Widget build(BuildContext context) {
    final database = DatabaseProvider.of(context);
    return StreamBuilder(
      initialData: [],
      stream: database.activeMealaStream,
      builder: (context, data) {
        if (data.data == null) return Text("Loading");
        return SingleChildScrollView(
          child: Column(
            children: data.data.map((meal) { 
              return ActiveMealWidget(activeMeal: meal); 
            }).toList().cast<ActiveMealWidget>()
          ),
        );
      }
    );
  }

  static List<Widget> actions(BuildContext context) {
    return [
      FlatButton(
        onPressed: () {
          Navigator.of(context).pushNamed("/saved_meals/");
        },
        child: Text("Meals", style: TextStyle(color: Colors.white),),
      ),
    ];
  }
}