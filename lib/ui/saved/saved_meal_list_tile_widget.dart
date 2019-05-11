
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mealplan/data/database.dart';
import 'package:mealplan/data/model.dart';
import 'package:mealplan/navigation/navigation.dart';
import 'package:provider/provider.dart';

class SavedMealListTileWidget extends StatelessWidget {
  SavedMealListTileWidget({
    Key key,
    @required final SavedMeal meal,
  }): this.meal = meal, super(key: key ?? Key(meal.id));

  final SavedMeal meal;

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context);
    return ListTile(
      title: Text(meal.name),
      onTap: () {
        database.activateMeal(meal);
      },
      trailing: FlatButton(
        textColor: Theme.of(context).accentColor,
        child: Text("Edit Meal"),
        onPressed: () {
          Provider.of<Navigation>(context).pushSavedMealEditor(meal: meal);
        }
      ),
    );
  }
}
