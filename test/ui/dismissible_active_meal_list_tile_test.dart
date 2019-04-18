import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mealplan/data/model.dart';
import 'package:mealplan/ui/active/dismissible_active_meal_list_tile.dart';

import '../util/mock_database_bloc.dart';
import '../util/setup.dart';

void main() {
  final activeMeal = ActiveMeal(randomSavedMeal());
  MockDatabaseBloc databaseBloc;
  MaterialApp app;
  setUp(() {
    final builder = (context) => DismissibleActiveMealListTile(activeMeal: activeMeal);
    databaseBloc = MockDatabaseBloc();
    app = buildWidget(builder: builder, navigationBloc: null, databaseBloc: databaseBloc);
  });

  testWidgets('Test widget has appropriate title', (WidgetTester tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    expect(find.text(activeMeal.name), findsOneWidget);
    expect(find.byKey(Key(activeMeal.id)), findsOneWidget);
  });

  testWidgets('Test tap icon removes active meal', (WidgetTester tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    expect(databaseBloc.removedMeals.isEmpty, true);
    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();
    expect(databaseBloc.removedMeals.first, activeMeal);
  });

  testWidgets('Test swipe widget removes active meal', (WidgetTester tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    expect(databaseBloc.removedMeals.isEmpty, true);
    await tester.drag(find.byType(Dismissible), Offset(500, 0));
    await tester.pumpAndSettle();
    expect(databaseBloc.removedMeals.first, activeMeal);
  });
}