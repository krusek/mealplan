import 'package:mealplan/data/model.dart';
import 'package:mealplan/navigation/navigation.dart';

class MockNavigationBloc extends NavigationBloc {
  bool savedMealEditorPushed = false;

  @override
  bool finishExtraItemDialog({ActiveIngredient ingredient}) {
    // TODO: implement finishExtraItemDialog
    return null;
  }

  @override
  bool finishSavedMeal({SavedMeal meal}) {
    // TODO: implement finishSavedMeal
    return null;
  }

  @override
  Future<Ingredient> presentExtraItemDialog() {
    // TODO: implement presentExtraItemDialog
    return null;
  }

  @override
  Future<SavedMeal> pushCreateSavedMeal() {
    savedMealEditorPushed = true;
    return Future.value(null);
  }

  @override
  Future<SavedMeal> pushSavedMealEditor({SavedMeal meal}) {
    savedMealEditorPushed = true;
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