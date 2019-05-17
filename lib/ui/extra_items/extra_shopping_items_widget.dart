import 'package:flutter/widgets.dart';
import 'package:mealplan/data/database.dart';
import 'package:mealplan/ui/active/active_ingredient_tile.dart';
import 'package:provider/provider.dart';

class ExtraShoppingItemsWidget extends StatefulWidget {
  const ExtraShoppingItemsWidget({
    Key key,
  }) : super(key: key);

  @override
  ExtraShoppingItemsWidgetState createState() {
    return new ExtraShoppingItemsWidgetState();
  }
}

class ExtraShoppingItemsWidgetState extends State<ExtraShoppingItemsWidget> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context);
    return AnimatedSize(
      duration: Duration(milliseconds: 200),
      alignment: Alignment.topCenter,
      vsync: this,
      child: StreamBuilder(
        initialData: [],
        stream: database.extraShoppingStream,
        builder: (context, snapshot) {
          if (snapshot.data.length == 0) return Text("Loading");
          return Column(
            children: snapshot.data.map((ingredient) {
              return ActiveIngredientTile(ingredient: ingredient);
            }).toList().cast<Widget>()
          );
        },
      ),
    );
  }
}