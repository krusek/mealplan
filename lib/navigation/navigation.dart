import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mealplan/data/model.dart';
import 'package:mealplan/ui/extra_items/extra_items_dialog.dart';
import 'package:mealplan/ui/saved/create_meal_widget.dart';

class Navigation {
  BuildContext _context;
  Navigation({@required BuildContext context}): _context = context;
  Future<SavedMeal> pushSavedMealEditor({SavedMeal meal}) {
    final arguments = EditMealRouteArguments(meal: meal);
    return Navigator.of(_context).pushNamed("/create_saved_meal/", arguments: arguments);
  }

  void pushSavedMealsList() {
    Navigator.of(_context).pushNamed("/saved_meals/");
  }

  Future<SavedMeal> pushCreateSavedMeal() {
    return Navigator.of(_context).pushNamed<SavedMeal>("/create_saved_meal/");
  }

  void switchToHome() {
    Navigator.of(_context).pushReplacementNamed("/home/"); 
  }

  bool finishSavedMeal({SavedMeal meal}) {
    return Navigator.of(_context).pop(meal);
  }

  bool finishExtraItemDialog({ActiveIngredient ingredient}) {
    return Navigator.of(_context).pop(ingredient);
  }

  Future<Ingredient> presentExtraItemDialog() {
    return showDialog(
      context: _context,
      builder: (context) {
        return ExtraItemDialog();
      }
    );
    
  }
}