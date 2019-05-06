import 'package:flutter/material.dart';
import 'create_ingredient_form.dart';

class ExtraItemDialog extends SimpleDialog {
  ExtraItemDialog():
  super(
      title: Text("Add Shopping Item"),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: CreateIngredientForm(),
        ),
      ]
    );
}

