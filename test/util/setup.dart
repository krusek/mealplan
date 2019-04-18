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
    return Ingredient(name: Uuid().v1().toString(), requiredAmount: Uuid().v1().toString(), unit: Uuid().v1().toString());
  }).toList();
  return SavedMeal(Uuid().v1().toString(), Uuid().v1().toString(), ingredients);
}