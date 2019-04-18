import 'package:flutter/material.dart';
import 'package:mealplan/data/database_provider.dart';
import 'package:mealplan/data/firestore_database_bloc.dart';
import 'package:mealplan/data/model.dart';
import 'package:mealplan/navigation/navigation_provider.dart';
import 'package:mealplan/ui/active/active_meal_widget.dart';
import 'package:mealplan/ui/extra_items/extra_shopping_items_widget.dart';
import 'package:mealplan/ui/saved/create_meal_widget.dart';
import 'package:mealplan/ui/saved/saved_meals_widget.dart';
import 'package:mealplan/ui/util/home_scaffold.dart';
import 'package:mealplan/ui/util/safe_area_scroll_view.dart';
import 'package:mealplan/ui/util/splash.dart';

void main() => runApp(new MyApp());

const String LK = "";

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meal Plan',
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
        // "/create_saved_meal/": (context) => CreateMealWidget.creatfleScaffold(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case "/create_saved_meal/":
          final argument = settings.arguments as EditMealRouteArguments;
          return MaterialPageRoute<SavedMeal>(
            builder: (context) {
              return CreateMealWidget.createScaffold(meal: argument?.meal);
            }
          );
        }
        return null;
      },
      builder: (ctx, navigator) {
        return NavigationProvider(child: DatabaseProvider(child: navigator, uuid: LK,));
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage();
  @override
  Widget build(BuildContext context) {
    final database = DatabaseProvider.of(context);
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
                      NavigationProvider.of(context).presentExtraItemDialog();
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
            stream: database.activeMealaStream,
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
                          NavigationProvider.of(context).pushSavedMealsList();
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
          NavigationProvider.of(context).pushSavedMealsList();
        },
        child: Text("Meals", style: TextStyle(color: Colors.white),),
      ),
      FlatButton(
        onPressed: () {
          FirebaseDatabaseBloc provider = DatabaseProvider.of(context);
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("uuid: ${provider.uuid}")
              );
            }
          );
        },
        child: Text("UUID", style: TextStyle(color: Colors.white),),
      ),
    ];
  }
}

