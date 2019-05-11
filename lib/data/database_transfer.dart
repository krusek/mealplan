
// import 'package:flutter/widgets.dart';
// import 'package:mealplan/data/database_bloc.dart';
// import 'package:mealplan/data/database_provider.dart';
// import 'package:mealplan/data/model.dart';

// class DatabaseTransfer extends StatefulWidget {
//   final Widget child;
//   DatabaseTransfer({this.child});
//   @override
//   DatabaseTransferState createState() {
//     return new DatabaseTransferState();
//   }

//   static TransferBloc of(BuildContext context) {
//     return (context.inheritFromWidgetOfExactType(DatabaseTransferWidget) as DatabaseTransferWidget).bloc;
//   }
// }

// class DatabaseTransferState extends State<DatabaseTransfer> {
//   final TransferBloc bloc = TransferBloc();
//   @override
//   Widget build(BuildContext context) {
//     return DatabaseTransferWidget(child: this.widget.child, bloc: this.bloc);
//   }
// }

// class DatabaseTransferWidget extends InheritedWidget {
//   final TransferBloc bloc;
//   DatabaseTransferWidget({Widget child, this.bloc}): super(child: child);
//   @override
//   bool updateShouldNotify(InheritedWidget oldWidget) {
//     return true;
//   }

// }

// class TransferBloc {
//   DatabaseBloc destination;
//   DatabaseBloc source;
//   Future _load(BuildContext context) async {
//     this.destination = Provider.of<Database>(context);
//     this.source = DatabaseProvider2.of(context);

//     final dloader = this.destination.loader(context);
//     final sloader = this.source.loader(context);

//     await Future.wait([dloader, sloader]);

//     this.source.savedMealsStream.listen((meals) {
//       for (SavedMeal meal in meals) {
//         this.destination.saveMeal(meal.id, meal.name, meal.ingredients);
//       }
//     });
//   }

//   Future _loader;
//   Future loader(BuildContext context) {
//     if (_loader == null) _loader = _load(context);
//     return _loader;
//   }
// }