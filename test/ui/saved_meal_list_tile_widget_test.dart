import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mealplan/ui/saved_meal_list_tile_widget.dart';

import '../util/mock_database_bloc.dart';
import '../util/mock_navigation_bloc.dart';
import '../util/setup.dart';

void main() {
  final meal = randomSavedMeal();
  MockNavigationBloc navigationBloc;
  MockDatabaseBloc databaseBloc;
  MaterialApp app;

  setUp(() {
    final builder = (context) => SavedMealListTileWidget(meal: meal);
    navigationBloc = MockNavigationBloc();
    databaseBloc = MockDatabaseBloc();
    app = buildWidget(builder: builder, navigationBloc: navigationBloc, databaseBloc: databaseBloc);

  });
  testWidgets('Test appropriate text', (WidgetTester tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();
    expect(find.text(meal.name), findsOneWidget);
    expect(find.text("Edit Meal"), findsOneWidget);
  });

  testWidgets('Test saved meal editor pushed', (WidgetTester tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();
    expect(navigationBloc.savedMealEditorPushed, false);

    await tester.tap(find.byType(FlatButton));
    
    await tester.pumpAndSettle();
    expect(navigationBloc.savedMealEditorPushed, true);
  });

  testWidgets('Test saved meal activated', (WidgetTester tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();


    await tester.tap(find.byType(ListTile));

    await tester.pumpAndSettle();

    final activated = databaseBloc.activatedMeals.first;
    expect(activated, meal, reason:"meal not activated");
  });
}
