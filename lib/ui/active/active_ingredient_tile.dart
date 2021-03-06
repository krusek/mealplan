import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mealplan/data/database.dart';
import 'package:mealplan/data/model.dart';
import 'package:provider/provider.dart';

class ActiveIngredientTile extends StatelessWidget {
  final ActiveIngredient ingredient;
  ActiveIngredientTile({Key key, @required this.ingredient}): assert(ingredient != null), super(key: key);
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context);
    return StreamBuilder(
      stream: database.ingredientStream(ingredient),
      initialData: ingredient,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final ingredient = snapshot.data as ActiveIngredient;
        return ListTile(
          onTap: () {
            database.toggle(id: ingredient.id, value: !ingredient.acquired);
          },
          title: Text(ingredient.name, 
            style: TextStyle(
              decoration: ingredient.acquired ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: _subtitle(ingredient),
          leading: Checkbox(
            value: ingredient.acquired, 
            onChanged: (value){
              database.toggle(id: ingredient.id, value: value);
            },
          ),
          trailing: SpecialCheckbox(
            value: ingredient.acquired, 
            onChanged: (value){
              database.toggle(id: ingredient.id, value: value);
            },

          )
        );
      },
    );
  }

  Widget _subtitle(ActiveIngredient ingredient) {
    if ((ingredient.unit.length + ingredient.requiredAmount.length) == 0) return null;
    return Text("${ingredient.requiredAmount} ${ingredient.unit}", 
        style: TextStyle(
          decoration: ingredient.acquired ? TextDecoration.lineThrough : null,
        ),
    );
  }

}

class SpecialCheckbox extends StatelessWidget {
  final bool value;
  final Function(bool) onChanged;
  SpecialCheckbox({this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final child = Center( 
      child: Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.blue.withAlpha(125),
        border: Border.all(width: 2, color: value ? Colors.blue : Colors.black45,),
      ),
    ));
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: value ? Colors.blue : Colors.black45,),
        borderRadius: BorderRadius.circular(4),
      ),
      child: value ? child : null,
    );
  }

}