import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mealplan/data/database.dart';
import 'package:mealplan/data/model.dart';
import 'package:mealplan/ui/active/active_meal_widget.dart';
import 'package:mealplan/ui/saved/saved_meal_list_tile_widget.dart';
import 'package:provider/provider.dart';

class SavedMealsListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context);
    return Column(
      children: [
        MealTitleWidget(title: "Saved Meals"),
        StreamBuilder<List<SavedMeal>>(
          initialData: [],
          stream: database.savedMealsStream,
          builder: (context, snapshot) {
            if (snapshot.data == null) { return ListTile(title: Text("No Saved Meals.")); }
            return Column(
              children: snapshot.data.map((meal) {
                return new SavedMealListTileWidget(meal: meal);
              }).toList(),
            );
          }
        ),
      ]
    );
  }
}