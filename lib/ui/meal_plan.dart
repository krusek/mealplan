
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mealplan/data/database.dart';
import 'package:mealplan/ui/active_meal_widget.dart';

class SavedMealsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ActiveMealsWidget(),
      ]
    );
  }
}

class ActiveMealsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final database = DatabaseWidget.of(context);
    return Column(
      children: [
        MealTitleWidget(title: "Active Meals"),
        StreamBuilder<List<ActiveMeal>>(
          initialData: database.activeMeals,
          stream: database.activeMealaStream,
          builder: (context, snapshot) {
            return Column(
              children: snapshot.data.map((meal) {
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
        ),
      ]
    );
  }
}