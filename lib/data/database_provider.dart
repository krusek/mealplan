
import 'package:flutter/widgets.dart';
import 'package:mealplan/data/database_bloc.dart';
import 'package:mealplan/data/firestore_database_bloc.dart';
import 'package:mealplan/data/inmemory_database_bloc.dart';

enum DatabaseType {
  memory, firestore
}

class _DatabaseWidget2 extends InheritedWidget {
  final DatabaseBloc _bloc;
  _DatabaseWidget2({Widget child, @required DatabaseBloc bloc}): this._bloc = bloc, assert(bloc != null), super(child: child);

  static DatabaseBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_DatabaseWidget2) as _DatabaseWidget2)._bloc;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}

class DatabaseProvider2 extends StatefulWidget {
  final Widget child;
  DatabaseProvider2({Key key, this.child}) : super(key: key);
  @override
  DatabaseProviderState2 createState() {
    return new DatabaseProviderState2();
  }

  static DatabaseBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_DatabaseWidget2) as _DatabaseWidget2)._bloc;
  }
}

class DatabaseProviderState2 extends State<DatabaseProvider2> {
  static final DatabaseType database = DatabaseType.memory;
  final DatabaseBloc bloc;
  
  DatabaseProviderState2():
  this.bloc = database == DatabaseType.firestore ? FirebaseDatabaseBloc(uuid: "") : MemoryDatabaseBloc();

  @override
  Widget build(BuildContext context) {
    return _DatabaseWidget2(bloc: this.bloc, child: this.widget.child);
  }
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
  final String uuid;
  DatabaseProvider({Key key, this.child, this.uuid}) : super(key: key);
  @override
  DatabaseProviderState createState() {
    return new DatabaseProviderState(uuid: this.uuid);
  }

  static DatabaseBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_DatabaseWidget) as _DatabaseWidget)._bloc;
  }
}

class DatabaseProviderState extends State<DatabaseProvider> {
  static final DatabaseType database = DatabaseType.memory;
  final String uuid;
  final DatabaseBloc bloc;
  
  DatabaseProviderState({this.uuid}):
  this.bloc = database == DatabaseType.firestore ? FirebaseDatabaseBloc(uuid: uuid) : MemoryDatabaseBloc();

  @override
  Widget build(BuildContext context) {
    return _DatabaseWidget(bloc: this.bloc, child: this.widget.child);
  }
}