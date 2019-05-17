import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mealplan/data/model.dart';
import 'package:mealplan/ui/saved/create_meal_form.dart';
import 'package:mealplan/ui/saved/create_meal_widget.dart';
import 'package:mealplan/ui/saved/mutable_ingredient_container.dart';
import 'package:mealplan/ui/util/home_scaffold.dart';
import 'package:uuid/uuid.dart';

import '../../util/setup.dart';

void main() {
  SavedMeal meal;
  Widget app;

  group('Create Meal Widget', () {
    setUp(() {
      meal = randomSavedMeal();
      app = buildWidget(
        builder: (context) {
          return CreateMealWidget(meal: meal);
        }
      );
    });

    testWidgets('create meal widget populated', (WidgetTester tester) async {
      await tester.pumpWidget(app);
      expect(find.byType(CreateMealForm), findsOneWidget);
    });
  });

  group('Create Meal Form', () {
    setUp(() {
      meal = randomSavedMeal();
      app = buildWidget(
        builder: (context) {
          return CreateMealWidget.createScaffold(meal: meal);
        }
      );
    });

    testWidgets('create meal widget populated', (WidgetTester tester) async {
      await tester.pumpWidget(app);
      expect(find.byType(HomeScaffold), findsOneWidget);
      expect(find.byType(CreateMealWidget), findsOneWidget);
    });
  });

  group('create meal arguments', () {
    test('create some arguments', () {
      final meal = randomSavedMeal();
      final arguments = EditMealRouteArguments(meal: meal);
      expect(meal, arguments.meal);
    });
  });
}