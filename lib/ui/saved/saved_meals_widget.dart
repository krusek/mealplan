
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mealplan/data/database_provider.dart';
import 'package:mealplan/data/model.dart';
import 'package:mealplan/navigation/navigation_provider.dart';
import 'package:mealplan/ui/active/active_meal_widget.dart';
import 'package:mealplan/ui/active/dismissible_active_meal_list_tile.dart';
import 'package:mealplan/ui/saved/saved_meal_list_tile_widget.dart';
import 'package:mealplan/ui/util/safe_area_scroll_view.dart';

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
          NavigationProvider.of(context).pushCreateSavedMeal();
        },
        child: Text("Create", style: TextStyle(color: Colors.white),),
      ),
    ];
  }
}

class SavedMealsListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final database = DatabaseProvider.of(context);
    return Column(
      children: [
        MealTitleWidget(title: "Saved Meals"),
        StreamBuilder<List<SavedMeal>>(
          initialData: [],
          stream: database.savedMealsStream,
          builder: (context, snapshot) {
            if (snapshot.data == null) { return ListTile(title: Text("No Saved Meals.")); }
            return Column(
              children: snapshot.data.map((meal) {
                return new SavedMealListTileWidget(meal: meal);
              }).toList(),
            );
          }
        ),
      ]
    );
  }
}

class ActiveMealsWidget extends StatefulWidget {
  @override
  ActiveMealsWidgetState createState() {
    return new ActiveMealsWidgetState();
  }
}

class ActiveMealsWidgetState extends State<ActiveMealsWidget> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final database = DatabaseProvider.of(context);
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