// This is a basic Flutter widget test.
// To perform an interaction with a widget in your test, use the WidgetTester utility that Flutter
// provides. For example, you can send tap and scroll gestures. You can also use WidgetTester to
// find child widgets in the widget tree, read text, and verify that the values of widget properties
// are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mealplan/data/database_provider.dart';
import 'package:mealplan/data/model.dart';
import 'package:mealplan/navigation/navigation_provider.dart';

import 'package:mealplan/ui/saved_meal_list_tile_widget.dart';

MaterialApp buildWidget({WidgetBuilder builder, MockNavigationBloc bloc}) {
  bloc = bloc ?? MockNavigationBloc();
  return MaterialApp(
      title: 'Meal Plan',
      theme: ThemeData(
        primaryColor: Colors.blueAccent,
      ),
      color: Colors.blue,
      routes: {
        "/": (context) => NavigationProvider(builder: (_) => bloc, child: Material(child: builder(context)))
      },
      builder: (ctx, navigator) {
        return NavigationProvider(builder: (_) => bloc, child: DatabaseProvider(child: navigator, uuid: "", database: DatabaseType.memory,));
      },
    );
}

class MockNavigationBloc extends NavigationBloc {
  bool savedMealEditorPushed = false;
  @override
  void pushSavedMealEditor({SavedMeal meal}) {
    savedMealEditorPushed = true;
  }
}

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
