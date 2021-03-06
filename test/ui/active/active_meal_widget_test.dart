import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mealplan/data/model.dart';
import 'package:mealplan/ui/active/active_ingredient_tile.dart';
import 'package:mealplan/ui/active/active_meal_widget.dart';

import '../../util/mock_database.dart';
import '../../util/setup.dart';

typedef _ActiveIngredientPredicate = bool Function(Widget widget) Function(ActiveIngredient ingredient);

void main() {
  final activeMeal = ActiveMeal(randomSavedMeal());
  MockDatabase databaseBloc;
  MaterialApp app;
  StreamController<List<ActiveIngredient>> controller;
  setUp(() {
    controller = StreamController<List<ActiveIngredient>>();
    final builder = (context) => ActiveMealWidget(activeMeal: activeMeal);
    databaseBloc = MockDatabase();
    databaseBloc.ingredientControllerMap[activeMeal.id] = controller;
    app = buildWidget(builder: builder, navigation: null, database: databaseBloc);
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

