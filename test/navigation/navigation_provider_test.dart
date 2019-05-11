import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mealplan/data/model.dart';
import 'package:mealplan/navigation/navigation_provider.dart';
import 'package:meta/meta.dart';
import 'package:provider/provider.dart';

import '../util/setup.dart';

class BLah extends Equatable {

}

void main() {
  Widget app;
  NavigationTestWidget widget;
  MockNavigatorWidget navigator;
  setUp(() {
    app = buildWidget(
      builder: (_) {
        widget = NavigationTestWidget();
        navigator = MockNavigatorWidget(child: Provider<Navigation>(child: widget));
        return navigator;
      },
    );
  });

  testWidgets('test navigation provider forwards push named', (WidgetTester tester) async {
    await tester.pumpWidget(app);

    _NavigationTestWidgetState state = tester.state(find.byWidget(widget));
    _MockNavigatorWidgetState mockNavigator = tester.state(find.byWidget(navigator));
    mockNavigator.forwarding = false;
    mockNavigator.expectedName = "/create_saved_meal/";
    state.pushCreateSavedMeal();
    assert(mockNavigator.routePushed);
  });

  testWidgets('test navigation provider pops for finishing saved meal', (WidgetTester tester) async {
    await tester.pumpWidget(app);

    final meal = randomSavedMeal();

    _NavigationTestWidgetState state = tester.state(find.byWidget(widget));
    _MockNavigatorWidgetState mockNavigator = tester.state(find.byWidget(navigator));
    mockNavigator.forwarding = false;
    mockNavigator.expectedResult = meal;
    state.finishSavedMeal(meal: meal);
    assert(mockNavigator.routePopped);
  });

  testWidgets('test navigation provider pops for finishing extra item dialog', (WidgetTester tester) async {
    await tester.pumpWidget(app);

    final ingredient = randomActiveIngredient();

    _NavigationTestWidgetState state = tester.state(find.byWidget(widget));
    _MockNavigatorWidgetState mockNavigator = tester.state(find.byWidget(navigator));
    mockNavigator.forwarding = false;
    mockNavigator.expectedResult = ingredient;
    state.finishExtraItemDialog(ingredient: ingredient);
    assert(mockNavigator.routePopped);
  });

  test('figuring out stuff', () {
    expectLater(actual, emitsInOrder(matchers))
  });
}

class MockNavigatorWidget extends Navigator {
  final Widget child;
  MockNavigatorWidget({@required this.child}): super(onGenerateRoute: (settings) {
    return MaterialPageRoute<SavedMeal>(
      builder: (context) {
        return Container();
      }
    );
  });

  @override
  _MockNavigatorWidgetState createState() => _MockNavigatorWidgetState();
}

class _MockNavigatorWidgetState extends NavigatorState {
  bool forwarding = true;
  @override
  Widget build(BuildContext context) {
    return (this.widget as MockNavigatorWidget).child;
  }

  @override
  Future<T> push<T extends Object>(Route<T> route) { 
    if (forwarding) {
      return Future.value(null);
    }
    print("route: ${route.settings.name}");
    assert(false);
    return Future.value(null);
  }

  String expectedName;
  bool routePushed = false;
  bool Function(Object arguments) expectedArgumentsMatcher;
  @override
  Future<T> pushNamed<T extends Object>(
    String routeName, {
    Object arguments,
  }) {
    if (expectedName == null && routeName == '/') { return Future.value(null); }
    assert(!routePushed);
    assert(routeName == expectedName, 'pushed route has incorrect name, expected: $expectedName, found: $routeName');
    if (expectedArgumentsMatcher != null) {
      assert(expectedArgumentsMatcher(arguments), 'route arguments do not match expectation.');
    }
    routePushed = true;
    return Future.value(null);
  }

  bool routePopped = false;
  Object expectedResult;
  @override
  bool pop<T extends Object>([ T result ]) {
    assert(!routePopped);
    assert(expectedResult is T);
    assert(expectedResult == result);
    routePopped = true;
    return false;
  }
}

class NavigationTestWidget extends StatefulWidget {
  @override
  _NavigationTestWidgetState createState() => _NavigationTestWidgetState();
}

class _NavigationTestWidgetState extends State<NavigationTestWidget> implements NavigationBloc {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container();
  }

  @override
  bool finishExtraItemDialog({ActiveIngredient ingredient}) {
    final navigator = Provider.of<Navigation>(this.context);
    return navigator.finishExtraItemDialog(ingredient: ingredient);
  }

  @override
  bool finishSavedMeal({SavedMeal meal}) {
    return Provider.of<Navigation>(this.context).finishSavedMeal(meal: meal);
  }

  @override
  Future<Ingredient> presentExtraItemDialog() {
    // TODO: implement presentExtraItemDialog
    return null;
  }

  @override
  Future<SavedMeal> pushCreateSavedMeal() {
    final navigator = Provider.of<Navigation>(this.context);
    return navigator.pushCreateSavedMeal();
  }

  @override
  Future<SavedMeal> pushSavedMealEditor({SavedMeal meal}) {
    // TODO: implement pushSavedMealEditor
    return null;
  }

  @override
  void pushSavedMealsList() {
    // TODO: implement pushSavedMealsList
  }

  @override
  void switchToHome() {
    // TODO: implement switchToHome
  }
}