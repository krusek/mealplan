import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mealplan/data/model.dart';
import 'package:mealplan/ui/active/active_ingredient_tile.dart';
import 'package:mealplan/ui/active/active_meal_widget.dart';
import 'package:mealplan/ui/saved/create_ingredient_container.dart';
import 'package:uuid/uuid.dart';

import '../../util/mock_database_bloc.dart';
import '../../util/setup.dart';

void main() {
  IngredientContainerForm form;
  GlobalKey<FormState> formKey;
  MutableIngredient ingredient;
  MockDatabaseBloc databaseBloc;
  Widget app;

  Finder nameFinder;
  Finder amountFinder;
  Finder unitFinder;
  setUp(() {
    ingredient = randomMutableIngredient();
    databaseBloc = MockDatabaseBloc();
    formKey = GlobalKey<FormState>();
    form = IngredientContainerForm(ingredient: ingredient, formKey: formKey);
    app = buildWidget(databaseBloc: databaseBloc, builder: (context) => form);

    nameFinder = find.widgetWithText(TextFormField, ingredient.name);
    amountFinder = find.widgetWithText(TextFormField, ingredient.requiredAmount);
    unitFinder = find.widgetWithText(TextFormField, ingredient.unit);
  });

  testWidgets('test ingredient fields exist', (WidgetTester tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    expect(nameFinder, findsOneWidget);
    expect(amountFinder, findsOneWidget);
    expect(unitFinder, findsOneWidget);
  });

  testWidgets('test ingredient updated on save', (WidgetTester tester) async {
    final id = ingredient.id;
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    final name = Uuid().v1();
    final amount = Uuid().v1();
    final unit = Uuid().v1();

    await tester.enterText(nameFinder, name);
    await tester.enterText(amountFinder, amount);
    await tester.enterText(unitFinder, unit);

    await tester.tap(find.byType(FlatButton));

    expect(ingredient.name, name);
    expect(ingredient.requiredAmount, amount);
    expect(ingredient.unit, unit);
    expect(ingredient.id, id);
  });

  group('required fields', () {
    assertRequired({WidgetTester tester, Finder finder, bool required}) async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      await tester.enterText(finder, '');
      expect(find.widgetWithText(TextFormField, ''), findsOneWidget);

      await tester.tap(find.byType(FlatButton));
      await tester.pumpAndSettle();
      expect(find.text('Required'), required ? findsOneWidget : findsNothing);
    }

    testWidgets('test name required', (WidgetTester tester) async {
      await assertRequired(tester: tester, finder: nameFinder, required: true);
    });

    testWidgets('test amount required', (WidgetTester tester) async {
      await assertRequired(tester: tester, finder: amountFinder, required: false);
    });

    testWidgets('test unit required', (WidgetTester tester) async {
      await assertRequired(tester: tester, finder: unitFinder, required: false);
    });

  });
}


class IngredientContainerForm extends StatelessWidget {
  final MutableIngredient ingredient;
  final GlobalKey<FormState> formKey;
  IngredientContainerForm({this.ingredient, this.formKey});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          CreateIngredientContainer(ingredient: ingredient),
          FlatButton(
            child: Text('Submit'),
            onPressed: () {
              if (this.formKey.currentState.validate()) {
                this.formKey.currentState.save();
              }
            },
          )
        ],
      ),
    );
  }


}

// class IngredientContainerFormState extends State<IngredientContainerForm> with TickerProviderStateMixin {
//   final MutableIngredient ingredient;
//   IngredientContainerFormState({this.ingredient});
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         CreateIngredientContainer(ingredient: ingredient),
//         FlatButton(
//           child: Text('Submit'),
//           onPressed: () {
//             if (this.widget.formKey.currentState.validate()) {
//               this.widget.formKey.currentState.save();
//             }
//           },
//         )
//       ],
//     );
//   }
// }