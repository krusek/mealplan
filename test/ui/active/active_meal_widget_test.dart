import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mealplan/data/model.dart';
import 'package:mealplan/ui/active/active_ingredient_tile.dart';
import 'package:mealplan/ui/active/active_meal_widget.dart';

import '../../util/mock_database_bloc.dart';
import '../../util/setup.dart';

typedef _ActiveIngredientPredicate = bool Function(Widget widget) Function(ActiveIngredient ingredient);

bool Function(Widget widget) filteredPredicate<T>(bool predicate(T filtered)) {
  return (widget) {
    if (!(widget is T)) return false;
    final item = widget as T;
    return predicate(item);
  };
}

void main() {
  final activeMeal = ActiveMeal(randomSavedMeal());
  MockDatabaseBloc databaseBloc;
  MaterialApp app;
  StreamController<List<ActiveIngredient>> controller;
  setUp(() {
    controller = StreamController<List<ActiveIngredient>>();
    final builder = (context) => ActiveMealWidget(activeMeal: activeMeal);
    databaseBloc = MockDatabaseBloc();
    databaseBloc.ingredientControllerMap[activeMeal.id] = controller;
    app = buildWidget(builder: builder, navigationBloc: null, databaseBloc: databaseBloc);
  });

  tearDown(() async {
    await controller.close();
  });

  testWidgets('Test no data means loading state.', (WidgetTester tester) async {
    await tester.pumpWidget(app);
    expect(find.text('Loading...'), findsOneWidget);
  });

  group('active_meal_widget data verification', () {
    List<ActiveIngredient> ingredients = [];
    setUp(() async {
      ingredients = randomActiveIngredients(4).toList();
      controller.add(ingredients);
    });

    testWidgets('Test some data means right amount of data.', (WidgetTester tester) async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      expect(find.byType(ActiveIngredientTile), findsNWidgets(ingredients.length));
    });

    testWidgets('Test some data means correct data.', (WidgetTester tester) async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final _ActiveIngredientPredicate predicate = (ingredient) {
        return filteredPredicate<ActiveIngredientTile>((tile) {
          return tile.ingredient == ingredient;
        });
      };
      for (final ingredient in ingredients) {
        expect(find.byWidgetPredicate(predicate(ingredient)), findsOneWidget);
      }
    });
  });
}

