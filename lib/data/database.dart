
import 'package:flutter/widgets.dart';
import 'package:mealplan/data/model.dart';

enum DatabaseType {
  memory, firestore
}

abstract class Database {
  Stream<List<ActiveMeal>> get activeMealaStream;
  Stream<List<SavedMeal>> get savedMealsStream;
  Stream<List<ActiveIngredient>> get extraShoppingStream;
  Stream<List<ActiveIngredient>> ingredientsStream(ActiveMeal meal);
  Stream<ActiveIngredient> ingredientStream(ActiveIngredient ingredient);

  ActiveIngredient addExtraItem(MutableIngredient ingredient);
  void clearExtraList();
  void clearCheckedExtraItems();
  void activateMeal(SavedMeal meal);
  void toggle({String id, bool value});
  SavedMeal saveMeal(String id, String name, List<IngredientBase> ingredients);
  void removeActiveMeal(ActiveMeal meal);
  Future loader(BuildContext context);
}