import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mealplan/ui/extra_items/create_ingredient_form.dart';
import 'package:mealplan/ui/extra_items/extra_items_dialog.dart';

import '../../util/setup.dart';

void main() {
  ExtraItemDialog dialog;
  Widget app;

  setUp(() {
    dialog = ExtraItemDialog();
    app = buildWidget(builder: (_) => dialog);
  });

  testWidgets('Extra dialog has proper children', (WidgetTester tester) async {
    await tester.pumpWidget(app);

    expect(find.text('Add Shopping Item'), findsOneWidget);
    expect(find.byType(CreateIngredientForm), findsOneWidget);
  });
}