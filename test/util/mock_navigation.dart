import 'package:mealplan/data/model.dart';
import 'package:mealplan/navigation/navigation.dart';

class MockNavigation extends Navigation {
  bool savedMealEditorPushed = false;

  ActiveIngredient expectedExtraItem;
  bool finishedExtraItemDialog = false;
  @override
  bool finishExtraItemDialog({ActiveIngredient ingredient}) {
    assert(finishedExtraItemDialog == false);
    finishedExtraItemDialog = true;
    assert(expectedExtraItem == ingredient);
    return true;
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

  SavedMeal expectedSavedMeal;
  @override
  Future<SavedMeal> pushCreateSavedMeal() {
    savedMealEditorPushed = true;
    assert(expectedSavedMeal == null);
    return Future.value(null);
  }

  @override
  Future<SavedMeal> pushSavedMealEditor({SavedMeal meal}) {
    savedMealEditorPushed = true;
    assert(meal == this.expectedSavedMeal);
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