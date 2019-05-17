import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mealplan/data/model.dart';
import 'package:mealplan/ui/active/active_ingredient_tile.dart';
import 'package:mealplan/ui/extra_items/extra_shopping_items_widget.dart';
import 'package:mealplan/ui/saved/create_meal_form.dart';
import 'package:mealplan/ui/saved/create_meal_widget.dart';
import 'package:mealplan/ui/util/home_scaffold.dart';

import '../../util/mock_database.dart';
import '../../util/mock_navigation.dart';
import '../../util/setup.dart';

void main() {
  Widget app;
  MockNavigation navigation;
  MockDatabase database;

  setUp(() {
    navigation = MockNavigation();
    database = MockDatabase();
    app = buildWidget(
      builder: (context) => ExtraShoppingItemsWidget(),
      database: database,
      navigation: navigation,
    );
  });

  group('extra items tests', () {
    testWidgets('test empty', (WidgetTester tester) async {
      await tester.pumpWidget(app);
      expect(find.text("Loading"), findsOneWidget);
      expect(find.byType(ActiveIngredientTile), findsNothing);
    });

    testWidgets('test non-empty', (WidgetTester tester) async {
      final count = Random.secure().nextInt(5) + 5;
      final ingredients = randomActiveIngredients(count).toList();
      database.extraShoppingSubject.add(ingredients);
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();
      
      expect(find.text("Loading"), findsNothing);
      expect(find.byType(ActiveIngredientTile), findsNWidgets(count));
    });
  });
}