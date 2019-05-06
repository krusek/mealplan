import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mealplan/data/database_provider.dart';
import 'package:mealplan/data/model.dart';
import 'package:mealplan/ui/active/active_ingredient_tile.dart';

class ActiveMealWidget extends StatelessWidget {
  final ActiveMeal activeMeal;
  const ActiveMealWidget({
    Key key,
    @required this.activeMeal
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final database = DatabaseProvider.of(context);
    return StreamBuilder(
      initialData: null,
      stream: database.ingredientsStream(activeMeal),
      builder: (context, snapshot) {
        if (snapshot.data == null) { 
          return Text("Loading..."); 
        }
        return Column(
          children: <Widget>[
            new MealTitleWidget(title: activeMeal.name),
            Column(
              children: snapshot.data.map((ingredient){
                return ActiveIngredientTile(ingredient: ingredient);
              }).toList().cast<ActiveIngredientTile>(),
            )
          ],
        );
      },
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
      height: 25.0,
      color: Colors.blueGrey,
      child: Center(
        child: Text(title, style: TextStyle(color: Colors.white),)
      )
    );
  }
}