
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class DatabaseWidget extends InheritedWidget {
  final _bloc = DatabaseBloc();
  DatabaseWidget({Widget child}): super(child: child);

  static DatabaseBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(DatabaseWidget) as DatabaseWidget)._bloc;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}

class DatabaseBloc {
  List<ActiveMeal> _activeMeals = [];
  List<SavedMeal> _savedMeals = [];

  Future loader(BuildContext context) async {
    String data = await DefaultAssetBundle.of(context).loadString("assets/sample_data.json");
    final result = json.decode(data);
    _activeMeals = result['active_meals'].map((item) { return ActiveMeal.fromJson(item); }).cast<ActiveMeal>().toList();
    _savedMeals = result['saved_meals'].map((item) { return SavedMeal.fromJson(item); }).cast<SavedMeal>().toList();
    this.activateMeal(_savedMeals[1]);
    this.activateMeal(_savedMeals[0]);
  }

  final _ingredientChanges = PublishSubject<ActiveIngredient>();
  final _activeMealsChanges = PublishSubject<List<ActiveMeal>>();

  Stream<List<ActiveMeal>> get activeMealaStream => _activeMealsChanges.stream;

  Stream<ActiveIngredient> ingredientStream(ActiveIngredient ingredient) {
    return _ingredientChanges.stream.where((active) { return active.id == ingredient.id; });
  }

  void activateMeal(SavedMeal meal) {
    final activeMeal = ActiveMeal(meal);
    _activeMeals.add(activeMeal);
    _activeMealsChanges.add(_activeMeals);
  }

  void toggle({String id, bool value}) {
    final ingredient = _activeMeals.expand((meal) => meal.ingredients).firstWhere((ingredient) => ingredient.id == id);
    ingredient?.acquired = value;
    _ingredientChanges.add(ingredient);
  }

  void removeActiveMeal(ActiveMeal meal) {
    _activeMeals.remove(meal);
    _activeMealsChanges.add(_activeMeals);
  }

  List<ActiveMeal> get activeMeals => _activeMeals;
  List<SavedMeal> get savedMeals => _savedMeals;

  void dispose() {
    _ingredientChanges.close();
  }

}

class ActiveMeal {
  final String id;
  final String name;
  final List<ActiveIngredient> ingredients;

  bool get acquired { 
    if (this.ingredients.length == 0) { return true; }
    return this.ingredients.map((ingredient) => ingredient.acquired).reduce((a,b) => a & b);
  }

  ActiveMeal(SavedMeal meal):
    this.name = meal.name,
    this.id = Uuid().v1(),
    this.ingredients = meal.ingredients.map((ingredient) { return ActiveIngredient(ingredient); }).toList();
  ActiveMeal.fromJson(Map<String, dynamic> json)
    : this.name = json["name"],
      this.id = json["id"],
      this.ingredients = ActiveIngredient.from(json['ingredients']);
}

class SavedMeal {
  final String name;
  final List<Ingredient> ingredients;

  SavedMeal(this.name, this.ingredients);
  SavedMeal.fromJson(Map<String, dynamic> json)
    : name = json["name"],
      ingredients = json['ingredients'].map((item){ return Ingredient.fromJson(item); }).cast<Ingredient>().toList();
}

class Ingredient {
  final String name;
  final String requiredAmount;
  final String unit;

  Ingredient(this.name, this.requiredAmount, this.unit);
  Ingredient.fromJson(Map<String,dynamic> json)
  : name = json['name'],
    requiredAmount = json['required_amount'],
    unit = json['unit'];

}

class ActiveIngredient {
  final String id;
  final String name;
  final String requiredAmount;
  final String unit;
  bool acquired;

  ActiveIngredient(Ingredient ingredient): 
    this.name = ingredient.name, 
    this.requiredAmount = ingredient.requiredAmount, 
    this.unit = ingredient.unit,
    this.acquired = false,
    this.id = Uuid().v1();
  ActiveIngredient.fromJson(Map<String,dynamic> json)
  : name = json['name'],
    requiredAmount = json['required_amount'],
    unit = json['unit'],
    acquired = json['acquired'],
    id = json['id'];

  static List<ActiveIngredient> from(List<dynamic> json) {
    final items = json.map((item){ return ActiveIngredient.fromJson(item); }).cast<ActiveIngredient>().toList();
    return items;
  }
}