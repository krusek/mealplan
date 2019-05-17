import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mealplan/ui/active/active_meals_widget.dart';
import 'package:mealplan/ui/active/dismissible_active_meal_list_tile.dart';

import '../../util/mock_database.dart';
import '../../util/mock_navigation.dart';
import '../../util/setup.dart';

void main() {
  MockNavigation navigation;
  MockDatabase database;
  MaterialApp app;

  setUp(() async {
    final builder = (context) => ActiveMealsWidget();
    navigation = MockNavigation();
    database = MockDatabase();
    app = buildWidget(builder: builder, navigation: navigation, database: database);
  });

  group('empty active meals', () {
    testWidgets('test title', (WidgetTester tester) async {
      await tester.pumpWidget(app);
      expect(find.text("Active Meals"), findsOneWidget);
    });

    testWidgets('test no data', (WidgetTester tester) async {
      await tester.pumpWidget(app);
      expect(find.text("No active meals"), findsOneWidget);
    });
  });

  group('non-empty active meals', () {

    testWidgets('test data list', (WidgetTester tester) async {
      final count = Random.secure().nextInt(5) + 5;

      await tester.pumpWidget(app);
      expect(find.text("No active meals"), findsOneWidget);

      final meals = randomSavedMeals(mealCount: count);
      meals.forEach((meal) {
        database.activateMeal(meal);
      });

      await tester.pumpAndSettle();

      expect(find.text("No active meals"), findsNothing);
      expect(find.byType(DismissibleActiveMealListTile), findsNWidgets(count));
    });
  });
}