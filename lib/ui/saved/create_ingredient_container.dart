import 'package:flutter/material.dart';
import 'package:mealplan/data/model.dart';

class CreateIngredientContainer extends StatelessWidget {
  final MutableIngredient ingredient;
  const CreateIngredientContainer({
    Key key,
    this.ingredient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          initialValue: ingredient.name,
          decoration: InputDecoration(labelText: "Ingredient Name"),
          onSaved: (value) => ingredient.name = value,
          validator: (value) => value.isEmpty ? "Required" : null,
        ),
        Row(
          children: <Widget>[
            Flexible(child: TextFormField(
              initialValue: ingredient.requiredAmount,
              decoration: InputDecoration(labelText: "Amount"),
              onSaved: (value) => ingredient.requiredAmount = value,
            )),
            Container(
              width: 10.0,
            ),
            Flexible(child: TextFormField(
              initialValue: ingredient.unit,
              decoration: InputDecoration(labelText: "Unit"),
              onSaved: (value) => ingredient.unit = value,
            ))
          ],
        )
      ]
    );
  }
} 