
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:mealplan/data/database_bloc.dart';
import 'package:mealplan/data/model.dart';
import 'package:rxdart/rxdart.dart';

class MemoryDatabaseBloc extends DatabaseBloc {
  List<_MemoryActiveMeal> _activeMeals = [];
  List<SavedMeal> _savedMeals = [];
  List<ActiveIngredient> _extraItems = [];

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
  final _extraItemsChanges = BehaviorSubject<List<ActiveIngredient>>();

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

  Iterable<ActiveIngredient> get _allActiveIngredients => _activeMeals.expand((meal) => meal._ingredients).followedBy(_extraItems);
  void toggle({String id, bool value}) {
    ActiveIngredient ingredient = _allActiveIngredients.firstWhere((ingredient) => ingredient.id == id, orElse: () => null);
    ingredient?.acquired = value;
    _ingredientChanges.add(ingredient);
    _extraItemsChanges.add(_extraItems);
  }

  SavedMeal saveMeal(String id, String name, List<IngredientBase> ingredients) {
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

  @override
  void clearCheckedExtraItems() {
    _extraItems.removeWhere((ingredient) => ingredient.acquired);
    _extraItemsChanges.add(_extraItems);
  }

  @override
  void clearExtraList() {
    _extraItems = [];
    _extraItemsChanges.add(_extraItems);
  }

  @override
  Stream<List<ActiveIngredient>> get extraShoppingStream => _extraItemsChanges;

  @override
  ActiveIngredient addExtraItem(MutableIngredient ingredient) {
    final json = ingredient.toJson();
    json["acquired"] = false;
    final active = ActiveIngredient.fromJson(json);
    _extraItems.add(active);
    _extraItemsChanges.add(_extraItems);
    return active;
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