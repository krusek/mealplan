
import 'package:flutter/widgets.dart';
import 'package:mealplan/data/model.dart';

abstract class DatabaseBloc {
  Stream<List<ActiveMeal>> get activeMealaStream;
  Stream<List<SavedMeal>> get savedMealsStream;
  Stream<List<ActiveIngredient>> ingredientsStream(ActiveMeal meal);
  Stream<ActiveIngredient> ingredientStream(ActiveIngredient ingredient);

  void activateMeal(SavedMeal meal);
  void toggle({String id, bool value});
  void saveMeal(String id, String name, List<MutableIngredient> ingredients);
  void removeActiveMeal(ActiveMeal meal);
  Future loader(BuildContext context);
}