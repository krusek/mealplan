import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mealplan/ui/saved/saved_meal_list_tile_widget.dart';

import '../../util/mock_database.dart';
import '../../util/mock_navigation.dart';
import '../../util/setup.dart';

void main() {
  final meal = randomSavedMeal();
  MockNavigation navigation;
  MockDatabase database;
  MaterialApp app;

  setUp(() {
    final builder = (context) => SavedMealListTileWidget(meal: meal);
    navigation = MockNavigation();
    database = MockDatabase();
    app = buildWidget(builder: builder, navigation: navigation, database: database);

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
    expect(navigation.savedMealEditorPushed, false);

    await tester.tap(find.byType(FlatButton));
    
    await tester.pumpAndSettle();
    expect(navigation.savedMealEditorPushed, true);
  });

  testWidgets('Test saved meal activated', (WidgetTester tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();


    await tester.tap(find.byType(ListTile));

    await tester.pumpAndSettle();

    final activated = database.activatedMeals.first;
    expect(activated, meal, reason:"meal not activated");
  });
}
