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
        "/home/": (context) => HomeScaffold(child: _MyHomePage(DatabaseWidget.of(context).activeMeals)),
        "/saved_meals/": (context) => HomeScaffold(child: SavedMealsWidget(), showActions: false,),
      },
      builder: (ctx, navigator) {
        return DatabaseWidget(child: navigator);
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
    final database = DatabaseWidget.of(context);
    return MyStreamBuilder(
      initialData: this.activeMeals,
      stream: database.activeMealaStream,
      builder: (context, data) {
        return Column(
          children: activeMeals.map((meal) { 
            return ActiveMealWidget(activeMeal: meal); 
          }).toList()
        );
      }
    );
  }

}

class _MyHomePage extends StatefulWidget {
  final List<ActiveMeal> activeMeals;
  _MyHomePage(this.activeMeals);
  @override
  MyHomePageState createState() {
    return new MyHomePageState(this.activeMeals);
  }
}

class MyHomePageState extends State<_MyHomePage> {
  List<ActiveMeal> activeMeals;
  MyHomePageState(this.activeMeals);
  StreamSubscription subscription;

  @override
  Widget build(BuildContext context) {
    final database = DatabaseWidget.of(context);
    if (subscription != null) {
      subscription = database.activeMealaStream.listen((data) {
        setState(() {
          this.activeMeals = data;
        });
      });
    }
    return SingleChildScrollView(
      child: Column(
        children: activeMeals.map((meal) { 
          return ActiveMealWidget(activeMeal: meal); 
        }).toList(),
      ),
    );
  }

  @override
    void didUpdateWidget(_MyHomePage oldWidget) {
      // TODO: implement didUpdateWidget
      super.didUpdateWidget(oldWidget);
      this.subscription?.cancel();
      this.subscription = null;
    }

  @override
    void dispose() {
      this.subscription?.cancel();
      this.subscription = null;
      super.dispose();
    }
}

class MyStreamBuilder<T> extends StatefulWidget {
  final T initialData;
  final Stream<T> stream;
  final Widget Function(BuildContext context, T data) builder;
  MyStreamBuilder({this.initialData, this.stream, this.builder});
  @override
  State<StatefulWidget> createState() {
    return MyStreamBuilderState(initialData, stream);
  }

}

class MyStreamBuilderState<T> extends State<MyStreamBuilder<T>> {
  T data;
  Stream<T> stream;
  MyStreamBuilderState(this.data, this.stream);
  @override
  Widget build(BuildContext context) {
    stream.listen((data) {
      this.data = data;
    });
    return this.widget.builder(context, data);
  }

}


