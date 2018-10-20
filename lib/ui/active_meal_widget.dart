import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mealplan/data/database.dart';
import 'package:mealplan/ui/active_ingredient_tile.dart';

class ActiveMealWidget extends StatelessWidget {
  final ActiveMeal activeMeal;
  const ActiveMealWidget({
    Key key,
    @required this.activeMeal
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = activeMeal.ingredients;
    print("items count: ${items.length}");
    return Column(
      children: <Widget>[
        new MealTitleWidget(title: activeMeal.name),
        Column(
          children: items.map((ingredient){
            return ActiveIngredientTile(ingredient: ingredient);
          }).toList(),
        )
      ],
    );
  }
}

class MealTitleWidget extends StatelessWidget {
  final String title;
  const MealTitleWidget({
    Key key, @required this.title
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.blueGrey,
      child: Text(title, style: TextStyle(color: Colors.white),)
    );
  }
}