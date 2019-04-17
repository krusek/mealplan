import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mealplan/data/database_provider.dart';
import 'package:mealplan/data/model.dart';

class ActiveIngredientTile extends StatefulWidget {
  final ActiveIngredient _ingredient;
  const ActiveIngredientTile({
    Key key, @required ActiveIngredient ingredient
  }) : _ingredient = ingredient, assert(ingredient != null), super(key: key);

  @override
  _ActiveIngredientTileState createState() {
    return new _ActiveIngredientTileState();
  }
}

class _ActiveIngredientTileState extends State<ActiveIngredientTile> {
  StreamSubscription<ActiveIngredient> subscription;
  _ActiveIngredientTileState();
  @override
  Widget build(BuildContext context) {
    final database = DatabaseProvider.of(context);
    final ingredient = this.widget._ingredient;
    if (this.subscription == null) {
      this.subscription =  database.ingredientStream(ingredient).listen((_) {
        setState((){});
      });
    }
    return ListTile(
      onTap: () {
        database.toggle(id: ingredient.id, value: !ingredient.acquired);

      },
      title: Text(ingredient.name, 
        style: TextStyle(
          decoration: ingredient.acquired ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: _subtitle(ingredient),
      leading: Checkbox(value: ingredient.acquired, onChanged: (value){
        database.toggle(id: ingredient.id, value: value);
      },)
    );
  }

  Widget _subtitle(ActiveIngredient ingredient) {
    if ((ingredient.unit.length + ingredient.requiredAmount.length) == 0) return null;
    return Text("${ingredient.requiredAmount} ${ingredient.unit}", 
        style: TextStyle(
          decoration: ingredient.acquired ? TextDecoration.lineThrough : null,
        ),
    );
  }

  @override
    void didUpdateWidget(ActiveIngredientTile oldWidget) {
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