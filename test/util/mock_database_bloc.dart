
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:mealplan/data/database_bloc.dart';
import 'package:mealplan/data/model.dart';

class MockDatabaseBloc extends DatabaseBloc {
  final List<SavedMeal> activatedMeals = [];
  @override
  void activateMeal(SavedMeal meal) {
    activatedMeals.add(meal);
  }

  @override
  // TODO: implement activeMealaStream
  Stream<List<ActiveMeal>> get activeMealaStream => null;

  @override
  ActiveIngredient addExtraItem(MutableIngredient ingredient) {
    // TODO: implement addExtraItem
    return null;
  }

  @override
  void clearCheckedExtraItems() {
    // TODO: implement clearCheckedExtraItems
  }

  @override
  void clearExtraList() {
    // TODO: implement clearExtraList
  }

  @override
  // TODO: implement extraShoppingStream
  Stream<List<ActiveIngredient>> get extraShoppingStream => null;

  Map<String, List<ActiveIngredient>> activeIngredientMap = Map();
  @override
  Stream<ActiveIngredient> ingredientStream(ActiveIngredient ingredient) {
    return Stream.fromIterable(activeIngredientMap[ingredient.id] ?? []);
  }

  Map<String, StreamController<List<ActiveIngredient>>> ingredientControllerMap = Map();
  @override
  Stream<List<ActiveIngredient>> ingredientsStream(ActiveMeal meal) {
    return ingredientControllerMap[meal.id]?.stream ?? Stream.empty();
  }

  @override
  Future loader(BuildContext context) {
    // TODO: implement loader
    return null;
  }

  final removedMeals = List<ActiveMeal>();
  @override
  void removeActiveMeal(ActiveMeal meal) {
    removedMeals.add(meal);
  }

  @override
  SavedMeal saveMeal(String id, String name, List<IngredientBase> ingredients) {
    // TODO: implement saveMeal
    return null;
  }

  @override
  // TODO: implement savedMealsStream
  Stream<List<SavedMeal>> get savedMealsStream => null;

  final Map<String, bool> toggles = Map();
  @override
  void toggle({String id, bool value}) {
    toggles[id] = value;
  }

}