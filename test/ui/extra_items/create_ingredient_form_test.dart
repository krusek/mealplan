import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mealplan/ui/extra_items/create_ingredient_form.dart';

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
      builder: (_) => CreateIngredientForm(),
      navigation: navigation,
      database: database,
    );
  });

  testWidgets('description', (WidgetTester tester) async {
    await tester.pumpWidget(app);
  });

  group('extra items dialog buttons',() {
    testWidgets('test cancel button', (WidgetTester tester) async {
      await tester.pumpWidget(app);

      navigation.expectedExtraItem = null;
      await tester.tap(find.text("Cancel"));
      assert(navigation.finishedExtraItemDialog);
    });

    testWidgets('test save without data does nothing', (WidgetTester tester) async {
      // Here we could attempt to mock out the key and fake the validation. This way
      // we could know that the save button attempts to validate.
      await tester.pumpWidget(app);

      navigation.expectedExtraItem = null;
      await tester.tap(find.text("Save"));
      assert(navigation.finishedExtraItemDialog == false);
    });

    testWidgets('test save with data saves', (WidgetTester tester) async {
      // Here we could attempt to mock out the key and fake the validation. This way
      // we could know that the save button attempts to validate.
      await tester.pumpWidget(app);

      //CreateIngredientFormState state = tester.state(find.byType(CreateIngredientForm));
      

      navigation.expectedExtraItem = null;
      await tester.tap(find.text("Save"));
      assert(navigation.finishedExtraItemDialog == false);
    });
    testWidgets('test cancel button', (WidgetTester tester) async {
      await tester.pumpWidget(app);

      navigation.expectedExtraItem = null;
      await tester.tap(find.text("Cancel"));
      assert(navigation.finishedExtraItemDialog);
    });
  });

}