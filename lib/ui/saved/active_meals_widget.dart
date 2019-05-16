import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mealplan/data/database.dart';
import 'package:mealplan/data/model.dart';
import 'package:mealplan/ui/active/active_meal_widget.dart';
import 'package:mealplan/ui/active/dismissible_active_meal_list_tile.dart';
import 'package:provider/provider.dart';

class ActiveMealsWidget extends StatefulWidget {
  @override
  ActiveMealsWidgetState createState() {
    return new ActiveMealsWidgetState();
  }
}

class ActiveMealsWidgetState extends State<ActiveMealsWidget> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context);
    return Column(
      children: [
        MealTitleWidget(title: "Active Meals"),
        AnimatedSize(
          duration: Duration(milliseconds: 200),
          alignment: Alignment.topCenter,
          vsync: this,
          child: StreamBuilder<List<ActiveMeal>>(
            initialData: [],
            stream: database.activeMealaStream,
            builder: (context, snapshot) {
              final list = snapshot.data;
              if (list != null && list.length > 0) {
                return _mealsColumn(context, list);
              } else {
                return ListTile(title: Text("No active meals"));
              }
            }
          ),
        ),
      ]
    );
  }

  Widget _mealsColumn(BuildContext context, List<ActiveMeal> meals) {
    return Column(
      children: meals.map((meal) {
        return new DismissibleActiveMealListTile(activeMeal: meal);
      }).toList()
    );
  }
}