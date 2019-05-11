
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mealplan/data/database.dart';
import 'package:mealplan/data/model.dart';
import 'package:mealplan/navigation/navigation_provider.dart';
import 'package:mealplan/ui/util/home_scaffold.dart';
import 'package:mealplan/ui/util/safe_area_scroll_view.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'mutable_ingredient_container.dart';

class EditMealRouteArguments {
  final SavedMeal meal;
  const EditMealRouteArguments({this.meal});
}

class CreateMealWidget extends StatelessWidget {
  final SavedMeal meal;
  CreateMealWidget({this.meal});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: SafeAreaScrollView(
        child: CreateMealForm(meal: this.meal),
      ),
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

class CreateMealFormState extends State<CreateMealForm> with TickerProviderStateMixin {
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
    final theme = Theme.of(context);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
            child: TextFormField(
              initialValue: name ?? "",
              validator: (string) => string.isEmpty ? "Meal name required" : null,
              onSaved: (value) => this.name = value,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: "Meal Name",
                hintText: "Meal Name",
              ),
            ),
          ),
          AnimatedSize(
            duration: Duration(milliseconds: 200),
            vsync: this,
            alignment: Alignment.topCenter,
            child: 
            Column(
              children: ingredients.map((ingredient) {
                return Padding(
                  padding: EdgeInsets.all(10.0),
                  child:MutableIngredientContainer(ingredient: ingredient, key: Key(ingredient.id))
                );
              }).toList()
            ),
          ),
          FlatButton(
            textColor: theme.accentColor,
            color: theme.buttonColor,
            child: Text("Add Ingredient"),
            onPressed: () {
              setState(() {
                ingredients.add(MutableIngredient());                  
              });
            }
          ),
          FlatButton(
            textColor: theme.accentColor,
            color: theme.buttonColor,
            child: Text("Save"),
            onPressed: () {
              final FormState form = _formKey.currentState;
              if (form.validate()) {
                form.save();
                final database = Provider.of<Database>(context);
                final meal = database.saveMeal(this.id, this.name, this.ingredients);
                Provider.of<Navigation>(context).finishSavedMeal(meal: meal);
              }
            }
          )
        ]
      ),
    );
  }
}