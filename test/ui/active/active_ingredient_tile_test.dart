import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mealplan/data/model.dart';
import 'package:mealplan/ui/active/active_ingredient_tile.dart';

import '../../util/mock_database.dart';
import '../../util/setup.dart';

void main() {
  MockDatabase databaseBloc;
  setUp(() {
    databaseBloc = MockDatabase();
  });

  testWidgets("Tap widget toggles weirdly updated ingredient off -> on", (WidgetTester tester) async {
    final ingredient = randomActiveIngredient(acquired: false);
    final laterIngredient = randomActiveIngredient(acquired: true);
    final builder = (context) => ActiveIngredientTile(ingredient: ingredient);
    databaseBloc.activeIngredientMap[ingredient.id] = [laterIngredient];
    final app = buildWidget(builder: builder, database: databaseBloc, navigation: null);

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ListTile));
    await tester.pumpAndSettle();
    expect(databaseBloc.toggles[laterIngredient.id], false);
  });

  testWidgets("Tap listtile toggles ingredient off -> on", (WidgetTester tester) async {
    final ingredient = randomActiveIngredient(acquired: false);
    await testTapWidgetTogglesDatabase(ingredient, databaseBloc, tester, ListTile);
  });

  testWidgets("Tap checkbox toggles ingredient off -> on", (WidgetTester tester) async {
    final ingredient = randomActiveIngredient(acquired: false);
    await testTapWidgetTogglesDatabase(ingredient, databaseBloc, tester, Checkbox);
  });

  testWidgets("Tap listtile toggles ingredient on -> off", (WidgetTester tester) async {
    final ingredient = randomActiveIngredient(acquired: true);
    await testTapWidgetTogglesDatabase(ingredient, databaseBloc, tester, ListTile);
  });

  testWidgets("Tap checkbox toggles ingredient on -> off", (WidgetTester tester) async {
    final ingredient = randomActiveIngredient(acquired: true);
    await testTapWidgetTogglesDatabase(ingredient, databaseBloc, tester, Checkbox);
  });
}

Future testTapWidgetTogglesDatabase(ActiveIngredient ingredient, MockDatabase databaseBloc, WidgetTester tester, Type type) async {
  final builder = (context) => ActiveIngredientTile(ingredient: ingredient);
  final app = buildWidget(builder: builder, database: databaseBloc, navigation: null);
  
  await tester.pumpWidget(app);
  await tester.pumpAndSettle();
  await tester.tap(find.byType(type));
  await tester.pumpAndSettle();
  expect(databaseBloc.toggles[ingredient.id], !ingredient.acquired);
}