import 'package:flutter/material.dart';
import 'package:mealplan/data/database_provider.dart';
import 'package:mealplan/data/model.dart';

class DismissibleActiveMealListTile extends StatelessWidget {
  const DismissibleActiveMealListTile({
    Key key,
    @required this.activeMeal,
  }) : super(key: key);

  final ActiveMeal activeMeal;

  @override
  Widget build(BuildContext context) {
    final database = DatabaseProvider.of(context);
    return Dismissible(
      key: Key(activeMeal.id),
      onDismissed: (_) {
        database.removeActiveMeal(activeMeal);
      },
      child: ListTile(
        title: Text(activeMeal.name),
        trailing: IconButton(
          color: Colors.orange,
          icon: Icon(Icons.close),
          onPressed: () {
            database.removeActiveMeal(activeMeal);
          },
        ),
      ),
    );
  }
}