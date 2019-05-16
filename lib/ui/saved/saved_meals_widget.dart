
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mealplan/navigation/navigation.dart';
import 'package:mealplan/ui/saved/saved_meals_list_widget.dart';
import 'package:mealplan/ui/util/safe_area_scroll_view.dart';
import 'package:provider/provider.dart';

import 'active_meals_widget.dart';


class SavedMealsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeAreaScrollView(
      child: Column(
        children: [
          ActiveMealsWidget(),
          SavedMealsListWidget(),
        ]
      ),
    );
  }


  static List<Widget> actions(BuildContext context) {
    return [
      FlatButton(
        onPressed: () {
          Provider.of<Navigation>(context).pushCreateSavedMeal();
        },
        child: Text("Create", style: TextStyle(color: Colors.white),),
      ),
    ];
  }
}