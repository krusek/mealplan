import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mealplan/data/model.dart';
import 'package:mealplan/ui/extra_items/extra_items_dialog.dart';
import 'package:mealplan/ui/saved/create_meal_widget.dart';

class _NavigationBloc extends NavigationBloc {
  BuildContext _context;
  _NavigationBloc({BuildContext context}): _context = context;
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

  @override
  bool finishSavedMeal({SavedMeal meal}) {
    return Navigator.of(_context).pop(meal);
  }

  @override
  bool finishExtraItemDialog({ActiveIngredient ingredient}) {
    return Navigator.of(_context).pop(ingredient);
  }

  @override
  Future<Ingredient> presentExtraItemDialog() {
    return showDialog(
      context: _context,
      builder: (context) {
        return ExtraItemDialog();
      }
    );
  }
}

abstract class NavigationBloc {
  Future<SavedMeal> pushSavedMealEditor({SavedMeal meal});
  void pushSavedMealsList();
  Future<SavedMeal> pushCreateSavedMeal();
  void switchToHome();
  bool finishSavedMeal({SavedMeal meal});
  Future<Ingredient> presentExtraItemDialog();
  bool finishExtraItemDialog({ActiveIngredient ingredient});
}


typedef NavigationBlocBuilder = NavigationBloc Function(BuildContext context);

class NavigationProvider extends InheritedWidget {
  NavigationProvider({Widget child, NavigationBlocBuilder builder}): _navigationBuilder = builder ?? ((context) => _NavigationBloc(context: context)), super(child: child); 
  final NavigationBlocBuilder _navigationBuilder;
  /// The "inheritance" features of this widget are not actually used.
  /// Therefore we can safely always return [false] here.
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  static NavigationBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(NavigationProvider) as NavigationProvider)._navigationBuilder(context);
  }
}