import 'package:flutter/material.dart';
import 'package:mealplan/data/database_bloc.dart';
import 'package:mealplan/data/database_provider.dart';
import 'package:mealplan/data/model.dart';
import 'package:mealplan/navigation/navigation_provider.dart';
import 'package:uuid/uuid.dart';

import 'mock_navigation_bloc.dart';

MaterialApp buildWidget({WidgetBuilder builder, MockNavigationBloc navigationBloc, DatabaseBloc databaseBloc}) {
  navigationBloc = navigationBloc ?? MockNavigationBloc();
  return MaterialApp(
      title: 'Meal Plan',
      theme: ThemeData(
        primaryColor: Colors.blueAccent,
      ),
      color: Colors.blue,
      routes: {
        "/": (context) => NavigationProvider(builder: (_) => navigationBloc, child: Material(child: builder(context)))
      },
      builder: (ctx, navigator) {
        return NavigationProvider(builder: (_) => navigationBloc, child: DatabaseProvider(child: navigator, uuid: "", database: DatabaseType.memory, bloc: databaseBloc));
      },
    );
}

SavedMeal randomSavedMeal({int ingredientCount = 0}) {
  final ingredients = Iterable.generate(ingredientCount).map((_) {
    return randomIngredient();
  }).toList();
  return SavedMeal(Uuid().v1().toString(), Uuid().v1().toString(), ingredients);
}

Ingredient randomIngredient() {
  return Ingredient(name: Uuid().v1().toString(), requiredAmount: Uuid().v1().toString(), unit: Uuid().v1().toString());
}

ActiveIngredient randomActiveIngredient({bool acquired}) {
  final ingredient = randomIngredient();
  return ActiveIngredient(ingredient, acquired: acquired ?? false);
}

Iterable<ActiveIngredient> randomActiveIngredients(int count) sync* {
  for (int ix = 0; ix < count; ix++) {
    yield randomActiveIngredient();
  }
}

bool Function(Widget widget) filteredPredicate<T>(bool predicate(T filtered)) {
  return (widget) {
    if (!(widget is T)) return false;
    final item = widget as T;
    return predicate(item);
  };
}