
import 'package:flutter/widgets.dart';
import 'package:mealplan/data/database_bloc.dart';
import 'package:mealplan/data/firestore_database_bloc.dart';
import 'package:mealplan/data/inmemory_database_bloc.dart';

enum DatabaseType {
  memory, firestore
}


class _DatabaseWidget extends InheritedWidget {
  final DatabaseBloc _bloc;
  _DatabaseWidget({Widget child, @required DatabaseBloc bloc}): this._bloc = bloc, assert(bloc != null), super(child: child);

  static DatabaseBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_DatabaseWidget) as _DatabaseWidget)._bloc;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}

class DatabaseProvider extends StatefulWidget {
  final Widget child;
  DatabaseProvider({Key key, this.child}) : super(key: key);
  @override
  DatabaseProviderState createState() {
    return new DatabaseProviderState();
  }

  static DatabaseBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_DatabaseWidget) as _DatabaseWidget)._bloc;
  }
}

class DatabaseProviderState extends State<DatabaseProvider> {
  static final DatabaseType database = DatabaseType.firestore;
  final DatabaseBloc bloc = database == DatabaseType.firestore ? FirebaseDatabaseBloc() : MemoryDatabaseBloc();
  @override
  Widget build(BuildContext context) {
    return _DatabaseWidget(bloc: this.bloc, child: this.widget.child);
  }
}