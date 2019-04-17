import 'package:flutter/material.dart';
import 'package:mealplan/data/database_provider.dart';
import 'package:mealplan/data/model.dart';
import 'package:mealplan/navigation/navigation_provider.dart';
import 'package:mealplan/ui/create_meal_widget.dart';
import 'package:uuid/uuid.dart';

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

class CreateIngredientForm extends StatefulWidget {
  CreateIngredientForm();

  @override
  State<StatefulWidget> createState() {
    return CreateIngredientFormState();
  }
}

class CreateIngredientFormState extends State<CreateIngredientForm> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final String id;
  final MutableIngredient ingredient = MutableIngredient();

  CreateIngredientFormState(): this.id = Uuid().v1() {
    ingredient.id = id;
  }

  @override
  Widget build(BuildContext context) {
    final database = DatabaseProvider.of(context);
    return Form(
      key: _formKey,
      child: AnimatedSize(
        duration: Duration(milliseconds: 200),
        alignment: Alignment.center,
        vsync: this,
        child: Column(
          children: [
            CreateIngredientContainer(ingredient: ingredient, key: Key(ingredient.id)),
            Container(height: 12.0),
            FlatButton(
              color: Colors.black12,
              textColor: Colors.blue,
              child: Text("Save"),
              onPressed: () {
                final FormState form = _formKey.currentState;
                if (form.validate()) {
                  form.save();
                  final active = database.addExtraItem(ingredient);
                  NavigationProvider.of(context).finishExtraItemDialog(ingredient: active);
                }
              }
            ),
            FlatButton(
              color: Colors.black12,
              textColor: Colors.orange,
              child: Text("Cancel"),
              onPressed: () {
                NavigationProvider.of(context).finishExtraItemDialog(ingredient: null);
              }
            )
          ]
        ),
      ),
    );
  }
}