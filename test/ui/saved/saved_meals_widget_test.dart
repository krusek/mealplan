import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mealplan/ui/active/active_meals_widget.dart';
import 'package:mealplan/ui/saved/saved_meals_list_widget.dart';
import 'package:mealplan/ui/saved/saved_meals_widget.dart';

import '../../util/mock_database.dart';
import '../../util/mock_navigation.dart';
import '../../util/setup.dart';

void main() {

  testWidgets('saved meals widget has active and potential', (WidgetTester tester) async {
    final widget = SavedMealsWidget();
    final app = buildWidget(builder: (context) => widget, database: MockDatabase());
    await tester.pumpWidget(app);
    expect(find.byType(ActiveMealsWidget), findsOneWidget);
    expect(find.byType(SavedMealsListWidget), findsOneWidget);
  });

  testWidgets('actions includes creating saved meal', (WidgetTester tester) async {
    final navigator = MockNavigation();
    final app = buildWidget(
      builder: (context) => Column(children: SavedMealsWidget.actions(context)), 
      database: MockDatabase(),
      navigation: navigator,
    );

    await tester.pumpWidget(app);
    await tester.tap(find.byType(FlatButton));
    await tester.pumpAndSettle();
    expect(navigator.savedMealEditorPushed, true);
  });
}