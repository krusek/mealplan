import 'package:flutter/material.dart';
import 'package:mealplan/data/model.dart';
import 'package:mealplan/ui/create_meal_widget.dart';

class _NavigationBloc extends NavigationBloc {
  BuildContext _context;
  _NavigationBloc({BuildContext context}): _context = context;
  void pushSavedMealEditor({SavedMeal meal}) {
    Navigator.push(_context, 
      MaterialPageRoute(
        builder: (context) {
          return CreateMealWidget.createScaffold(meal: meal);
        }
      )
    );
  }
}

abstract class NavigationBloc {
  void pushSavedMealEditor({SavedMeal meal});
}


typedef NavigationBlocBuilder = NavigationBloc Function(BuildContext context);

class NavigationProvider extends InheritedWidget {
  NavigationProvider({Widget child, NavigationBlocBuilder builder}): _navigationBuilder = builder ?? ((context) => _NavigationBloc(context: context)), super(child: child); 
  final NavigationBlocBuilder _navigationBuilder;
  /// The "inheritance" features of this widget are not actually used.
  /// Therefore we can safely always return [false] here.
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  static NavigationBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(NavigationProvider) as NavigationProvider)._navigationBuilder(context);
  }
}