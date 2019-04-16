import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mealplan/data/model.dart';

import 'package:mealplan/ui/saved_meal_list_tile_widget.dart';

import '../util/mock_navigation_bloc.dart';
import '../util/setup.dart';

void main() {
  final meal = SavedMeal("123", "My meal", []);
  MockNavigationBloc bloc;
  MaterialApp app;

  setUp(() {
    final builder = (context) => SavedMealListTileWidget(meal: meal);
    bloc = MockNavigationBloc();
    app = buildWidget(builder: builder, bloc: bloc);

  });
  testWidgets('Test appropriate title', (WidgetTester tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();
    expect(find.text(meal.name), findsOneWidget);
  });

  testWidgets('Test edit button title', (WidgetTester tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();
    expect(find.text("Edit Meal"), findsOneWidget);
  });

  testWidgets('Test saved meal editor pushed', (WidgetTester tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();
    expect(bloc.savedMealEditorPushed, false);

    await tester.tap(find.byType(FlatButton));
    
    await tester.pumpAndSettle();
    expect(bloc.savedMealEditorPushed, true);
  });
}
