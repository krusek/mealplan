import 'package:mealplan/data/model.dart';
import 'package:mealplan/navigation/navigation_provider.dart';

class MockNavigationBloc extends NavigationBloc {
  bool savedMealEditorPushed = false;
  @override
  void pushSavedMealEditor({SavedMeal meal}) {
    savedMealEditorPushed = true;
  }
}