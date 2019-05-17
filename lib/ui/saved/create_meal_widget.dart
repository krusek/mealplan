
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mealplan/data/model.dart';
import 'package:mealplan/ui/util/home_scaffold.dart';
import 'package:mealplan/ui/util/safe_area_scroll_view.dart';

import 'create_meal_form.dart';

class EditMealRouteArguments {
  final SavedMeal meal;
  const EditMealRouteArguments({this.meal});
}

class CreateMealWidget extends StatelessWidget {
  final SavedMeal meal;
  CreateMealWidget({this.meal});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: SafeAreaScrollView(
        child: CreateMealForm(meal: this.meal),
      ),
    );
  }

  static Widget createScaffold({SavedMeal meal}) {
    return HomeScaffold(child: CreateMealWidget(meal: meal));
  }
}