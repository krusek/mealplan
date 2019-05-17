import 'package:flutter/material.dart';
import 'package:mealplan/data/firestore_database.dart';
import 'package:mealplan/data/firestore_holder.dart';
import 'package:mealplan/data/model.dart';
import 'package:mealplan/navigation/navigation.dart';
import 'package:mealplan/ui/active/active_meal_widget.dart';
import 'package:mealplan/ui/extra_items/extra_shopping_items_widget.dart';
import 'package:mealplan/ui/saved/create_meal_widget.dart';
import 'package:mealplan/ui/saved/saved_meals_widget.dart';
import 'package:mealplan/ui/util/home_scaffold.dart';
import 'package:mealplan/ui/util/safe_area_scroll_view.dart';
import 'package:mealplan/ui/util/splash.dart';
import 'package:provider/provider.dart';
import 'data/database.dart';

void main() => runApp(new MyApp());

const String LK = "";

class MyApp extends StatelessWidget {
  MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meal Plan',
      theme: ThemeData(
        primaryColor: Colors.blueAccent,
      ),
      color: Colors.blue,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case "/create_saved_meal/":
          final argument = settings.arguments as EditMealRouteArguments;
          return createScaffoldRoute<SavedMeal>(context, CreateMealWidget(meal: argument?.meal), null);
          case "/":
          return createRoute(context, Splash());
          case "/home/":
          return createScaffoldRoute(context, MyHomePage(), MyHomePage.actions);
          case "/saved_meals/":
          return createScaffoldRoute(context, SavedMealsWidget(), SavedMealsWidget.actions);
        }
        return null;
      },
      builder: (_, navigator) {
        return MultiProvider(
          providers: [
            Provider<FirestoreHolder>.value(value: FirestoreHolder()),
            Provider<Database>(builder: (_) => FirebaseDatabase(uuid: LK)),
          ],
          child: navigator
        );
      },
    );
  }

  MaterialPageRoute<T> createScaffoldRoute<T>(BuildContext context, Widget child, List<Widget> Function(BuildContext context) actions) {
    return MaterialPageRoute(
      builder: (context) => Provider<Navigation>(
        builder: (context) => Navigation(context: context),
        child: Builder(
          builder: (context) => HomeScaffold(
            child: child,
            actions: actions == null ? [] : actions(context),
          ),
        ) ,
      ),
    );
  }


  MaterialPageRoute<T> createRoute<T>(BuildContext context, Widget child) {
    return MaterialPageRoute(
      builder: (context) => Provider<Navigation>(
        builder: (context) => Navigation(context: context),
        child: child,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage();
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context);
    return SafeAreaScrollView(
      child: Column(
        children: [
          MealTitleWidget(title: "Extra Shopping Items"),
          new ExtraShoppingItemsWidget(),
          StreamBuilder<List<ActiveIngredient>>(
            initialData: <ActiveIngredient>[],
            stream: database.extraShoppingStream,
            builder: (context, snapshot) {
              final allDisabled = _allCount(snapshot.data);
              final checkedDisabled = _checkedCount(snapshot.data);
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FlatButton(
                    textColor: Colors.blue,
                    child: Text("Add Item"),
                    onPressed: () {
                      Provider.of<Navigation>(context).presentExtraItemDialog();
                    },
                  ),
                  FlatButton(
                    textColor: Colors.orange,
                    child: Text("Clear Checked"),
                    onPressed: checkedDisabled ? null : () {
                      database.clearCheckedExtraItems();
                    },
                  ),
                  FlatButton(
                    textColor: Colors.orange,
                    child: Text("Clear All"),
                    onPressed: allDisabled ? null : () {
                      database.clearExtraList();
                    },
                  ),
                ],
              );
            }
          ),
          StreamBuilder(
            initialData: [],
            stream: database.activeMealsStream,
            builder: (context, data) {
              if (data.data == null) return Text("Loading");
              if (data.data.length == 0) {
                return Column(
                  children: <Widget>[
                    MealTitleWidget(title: "Active Meals"),
                    ListTile(
                      title: Text("No meals added"),
                      trailing: FlatButton(
                        textColor: Theme.of(context).accentColor,
                        child: Text("Create Meals"),
                        onPressed: () {
                          Provider.of<Navigation>(context).pushSavedMealsList();
                        }
                      )
                    ),
                  ],
                );
              }
              return Column(
                children: data.data.map((meal) { 
                  return ActiveMealWidget(activeMeal: meal); 
                }).toList().cast<ActiveMealWidget>()
              );
            }
          ),
        ]
      ),
    );
  }

  bool _allCount(List<dynamic> list) {
    return list?.length == null || list?.length == 0;
  }

  bool _checkedCount(List<dynamic> list) {
    if (list == null) return true;
    return !list.any((ing) => ing.acquired);
  }

  static List<Widget> actions(BuildContext context) {
    return [
      FlatButton(
        onPressed: () {
          Provider.of<Navigation>(context).pushSavedMealsList();
        },
        child: Text("Meals", style: TextStyle(color: Colors.white),),
      ),
      FlatButton(
        onPressed: () {
          final database = Provider.of<Database>(context) as FirebaseDatabase;
          if (database == null) return;
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("uuid: ${database.uuid}")
              );
            }
          );
        },
        child: Text("UUID", style: TextStyle(color: Colors.white),),
      ),
    ];
  }
}

