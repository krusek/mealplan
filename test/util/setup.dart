import 'package:flutter/material.dart';
import 'package:mealplan/data/database.dart';
import 'package:mealplan/data/model.dart';
import 'package:mealplan/navigation/navigation.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'mock_navigation.dart';

typedef NavigationBuilder = Navigation Function(BuildContext context);

MaterialApp buildWidget({
  WidgetBuilder builder, 
  NavigationBuilder navigationBuilder, 
  Navigation navigation,
  Database database,
  List<NavigatorObserver> navigationObservers = const []}) {
  assert(navigation == null || navigationBuilder == null);
  if (navigation == null && navigationBuilder == null) {
    navigation = MockNavigation();
  }
  if (navigation != null && navigationBuilder == null) {
    navigationBuilder = (_) => navigation;
  }

  return MaterialApp(
      title: 'Meal Plan',
      navigatorObservers: navigationObservers,
      theme: ThemeData(
        primaryColor: Colors.blueAccent,
      ),
      color: Colors.blue,
      routes: {
        "/": (context) => Provider<Navigation>(builder: navigationBuilder, child: Material(child: builder(context)))
      },
      onGenerateRoute: (settings) {
        return MaterialPageRoute<SavedMeal>(
          settings: settings,
          builder: (context) {
            return Provider<Navigation>(builder: navigationBuilder, child: Material(child: builder(context)));
          }
        ) ;
      },
      builder: (ctx, navigator) {
        return Provider<Database>.value(
          child: navigator, 
          value: database,
        );
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

MutableIngredient randomMutableIngredient() {
  return MutableIngredient.from(ingredient: randomIngredient());
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