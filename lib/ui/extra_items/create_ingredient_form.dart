import 'package:flutter/material.dart';
import 'package:mealplan/data/database.dart';
import 'package:mealplan/data/model.dart';
import 'package:mealplan/navigation/navigation_provider.dart';
import 'package:mealplan/ui/saved/mutable_ingredient_container.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CreateIngredientForm extends StatefulWidget {
  CreateIngredientForm();

  @override
  State<StatefulWidget> createState() {
    return CreateIngredientFormState();
  }
}

class CreateIngredientFormState extends State<CreateIngredientForm> with TickerProviderStateMixin {
  final _formKey;
  final String id;
  final MutableIngredient ingredient = MutableIngredient();

  CreateIngredientFormState({GlobalKey<FormState> formKey}): 
  this.id = Uuid().v1(), 
  this._formKey = formKey ?? GlobalKey<FormState>() {
    ingredient.id = id;
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context);
    return Form(
      key: _formKey,
      child: AnimatedSize(
        duration: Duration(milliseconds: 200),
        alignment: Alignment.center,
        vsync: this,
        child: Column(
          children: [
            MutableIngredientContainer(ingredient: ingredient, key: Key(ingredient.id)),
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
                  Provider.of<Navigation>(context).finishExtraItemDialog(ingredient: active);
                }
              }
            ),
            FlatButton(
              color: Colors.black12,
              textColor: Colors.orange,
              child: Text("Cancel"),
              onPressed: () {
                Provider.of<Navigation>(context).finishExtraItemDialog(ingredient: null);
              }
            )
          ]
        ),
      ),
    );
  }
}