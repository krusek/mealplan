
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mealplan/data/database_provider.dart';
import 'package:mealplan/data/model.dart';
import 'package:mealplan/ui/home_scaffold.dart';
import 'package:uuid/uuid.dart';

class CreateMealWidget extends StatelessWidget {
  final SavedMeal meal;
  CreateMealWidget({this.meal});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Padding(padding: EdgeInsets.symmetric(horizontal: 10.0), child: CreateMealForm(meal: this.meal))
    );
  }

  static Widget createScaffold({SavedMeal meal}) {
    return HomeScaffold(child: CreateMealWidget(meal: meal));
  }
}

class CreateMealForm extends StatefulWidget {
  final SavedMeal meal;
  CreateMealForm({this.meal});

  @override
  State<StatefulWidget> createState() {
    return CreateMealFormState(meal);
  }

}

class CreateMealFormState extends State<CreateMealForm> {
  final _formKey = GlobalKey<FormState>();
  final String id;
  final List<MutableIngredient> ingredients = [];
  String name;

  CreateMealFormState(SavedMeal meal): this.id = meal?.id ?? Uuid().v1() {
    name = meal?.name;
    meal?.ingredients?.forEach( (ingredient) {
      ingredients.add(MutableIngredient.from(ingredient: ingredient));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
            TextFormField(
              initialValue: name ?? "",
              validator: (string) => string.isEmpty ? "Meal name required" : null,
              onSaved: (value) => this.name = value,
              decoration: InputDecoration(
                labelText: "Meal Name",
                hintText: "Meal Name",
              ),
            ),
            Column(
              children: ingredients.map((ingredient) => CreateIngredientContainer(ingredient: ingredient, key: Key(ingredient.id))).toList()
            ),
            FlatButton(
              child: Text("Add Ingredient"),
              onPressed: () {
                setState(() {
                  ingredients.add(MutableIngredient());                  
                });
              }
            ),
            FlatButton(
              child: Text("Save"),
              onPressed: () {
                final FormState form = _formKey.currentState;
                if (form.validate()) {
                  form.save();
                  final database = DatabaseProvider.of(context);
                  database.saveMeal(this.id, this.name, this.ingredients);
                  Navigator.of(context).pop();
                }
              }
            )
        ]
      ),
    );
  }

}

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
        Container(
          width: double.infinity,
          height: 5.0,
          color: Colors.black12,
        ),
        TextFormField(
          initialValue: ingredient.name,
          decoration: InputDecoration(labelText: "Ingredient Name"),
          onSaved: (value) => ingredient.name = value,
        ),
        Row(
          children: <Widget>[
            Flexible(child: TextFormField(
              initialValue: ingredient.requiredAmount,
              decoration: InputDecoration(labelText: "Amount"),
              onSaved: (value) => ingredient.requiredAmount = value,
            )),
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