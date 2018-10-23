
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mealplan/data/database.dart';
import 'package:mealplan/ui/active_meal_widget.dart';
import 'package:mealplan/ui/create_meal.dart';

class SavedMealsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ActiveMealsWidget(),
        SavedMealsListWidget(),
      ]
    );
  }


  static List<Widget> actions(BuildContext context) {
    return [
      FlatButton(
        onPressed: () {
          Navigator.of(context).pushNamed("/create_saved_meal/");
        },
        child: Text("Create", style: TextStyle(color: Colors.white),),
      ),
    ];
  }
}

class SavedMealsListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final database = DatabaseProvider.of(context);
    return Column(
      children: [
        MealTitleWidget(title: "Saved Meals"),
        StreamBuilder<List<SavedMeal>>(
          initialData: database.savedMeals,
          stream: database.savedMealsStream,
          builder: (context, snapshot) {
            return Column(
              children: snapshot.data.map((meal) {
                return ListTile(
                  title: Text(meal.name),
                  onTap: () {
                    database.activateMeal(meal);
                  },
                  trailing: FlatButton(
                    child: Text("Edit Meal"),
                    onPressed: () {
                      Navigator.push(context, 
                        MaterialPageRoute(
                          builder: (context) {
                            return CreateWidget.createScaffold(meal: meal);
                          }
                        )
                      );
                    }
                  ),
                );
              }).toList(),
            );
          }
        ),
      ]
    );
  }

}

class ActiveMealsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final database = DatabaseProvider.of(context);
    return Column(
      children: [
        MealTitleWidget(title: "Active Meals"),
        StreamBuilder<List<ActiveMeal>>(
          initialData: database.activeMeals,
          stream: database.activeMealaStream,
          builder: (context, snapshot) {
            final list = snapshot.data;
            if (list.length > 0) {
              return _mealsColumn(context, list);
            } else {
              return ListTile(title: Text("No active meals"));
            }
          }
        ),
      ]
    );
  }

  Widget _mealsColumn(BuildContext context, List<ActiveMeal> meals) {
    final database = DatabaseProvider.of(context);
    return Column(
      children: meals.map((meal) {
        return ListTile(
          title: Text(meal.name),
          trailing: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              database.removeActiveMeal(meal);
            },
          ),
        );
      }).toList()
    );
  }
}