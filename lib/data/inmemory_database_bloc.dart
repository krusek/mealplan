
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:mealplan/data/database_bloc.dart';
import 'package:mealplan/data/model.dart';
import 'package:rxdart/rxdart.dart';

class MemoryDatabaseBloc extends DatabaseBloc {
  List<_MemoryActiveMeal> _activeMeals = [];
  List<SavedMeal> _savedMeals = [];

  Future loader(BuildContext context) async {
    String data = await DefaultAssetBundle.of(context).loadString("assets/sample_data.json");
    final result = json.decode(data);
    _activeMeals = result['active_meals'].map((item) { return _MemoryActiveMeal.fromJson(item); }).cast<_MemoryActiveMeal>().toList();
    _savedMeals = result['saved_meals'].map((item) { return SavedMeal.fromJson(item); }).cast<SavedMeal>().toList();
    _activeMealsChanges.add(_activeMeals);
    _savedMealsChanges.add(_savedMeals);
    this.activateMeal(_savedMeals[1]);
    this.activateMeal(_savedMeals[0]);
  }

  final _ingredientChanges = BehaviorSubject<ActiveIngredient>();
  final _activeMealsChanges = BehaviorSubject<List<_MemoryActiveMeal>>();
  final _savedMealsChanges = BehaviorSubject<List<SavedMeal>>();

  Stream<List<_MemoryActiveMeal>> get activeMealaStream => _activeMealsChanges.stream;
  Stream<List<SavedMeal>> get savedMealsStream => _savedMealsChanges.stream;

  Stream<ActiveIngredient> ingredientStream(ActiveIngredient ingredient) {
    return _ingredientChanges.stream.where((active) { return active.id == ingredient.id; });
  }

  void activateMeal(SavedMeal meal) {
    final activeMeal = _MemoryActiveMeal(meal);
    _activeMeals.add(activeMeal);
    _activeMealsChanges.add(_activeMeals);
  }

  void toggle({String id, bool value}) {
    final ingredient = _activeMeals.expand((meal) => meal._ingredients).firstWhere((ingredient) => ingredient.id == id, orElse: () => null);
    ingredient?.acquired = value;
    _ingredientChanges.add(ingredient);
  }

  void saveMeal(String id, String name, List<MutableIngredient> ingredients) {
    _savedMeals.removeWhere((meal) => meal.id == id);
    final saved = SavedMeal(id, name, ingredients);
    _savedMeals.add(saved);
    this._savedMealsChanges.add(_savedMeals);
  }

  void removeActiveMeal(ActiveMeal meal) {
    _activeMeals.remove(meal);
    _activeMealsChanges.add(_activeMeals);
  }

  void dispose() {
    _ingredientChanges.close();
    _activeMealsChanges.close();
    _savedMealsChanges.close();
  }

  @override
  Stream<List<ActiveIngredient>> ingredientsStream(ActiveMeal meal) {
    return activeMealaStream.map((list) {
      for (_MemoryActiveMeal m in list) {
        if (m.id == meal.id) { return m._ingredients; }
      }
      return null;
    }).where((list) => list != null).distinct();
  }
}

class _MemoryActiveMeal extends ActiveMeal {
  final List<ActiveIngredient> _ingredients;
  _MemoryActiveMeal(SavedMeal meal):
    this._ingredients = meal.ingredients.map((ingredient) { return ActiveIngredient(ingredient); }).toList(),
    super(meal);
  _MemoryActiveMeal.fromJson(Map<String, dynamic> json)
    : this._ingredients = ActiveIngredient.from(json['ingredients']),
    super.fromJson(json);
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json["ingredients"] = ActiveIngredient.toJsonList(this._ingredients);
    return json;
  }
}