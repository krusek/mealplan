
import 'package:flutter/widgets.dart';
import 'package:mealplan/data/database_bloc.dart';
import 'package:mealplan/data/firestore_database_bloc.dart';
import 'package:mealplan/data/firestore_provider.dart';
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

/// This class was created to facilitate copying data from one firebase
/// data store to another. It can be ignored.
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

/// This widget is only used to facilitate Widget lookups for the 
/// [DatabaseProvider].
class _DatabaseWidget extends InheritedWidget {
  final DatabaseBloc _bloc;
  _DatabaseWidget({Widget child, @required DatabaseBloc bloc}): this._bloc = bloc, assert(bloc != null), super(child: child);

  static DatabaseBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_DatabaseWidget) as _DatabaseWidget)._bloc;
  }

  /// The "inheritance" features of this widget are not actually used.
  /// Therefore we can safely always return [false] here.
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}

/// This Widget provides the database as a bloc. 
/// 
/// It uses a private InheritedWidget to ensure that lookup can be
/// fast.
class DatabaseProvider extends StatefulWidget {
  final Widget child;
  /// The uuid to be used with firestore to keep data pertaining to
  /// different devices separated. If you want to share data between
  /// two different devices then they should use the same value. It 
  /// does not have to be an actual uuid, but at least a string without
  /// any special characters.
  final String uuid;
  DatabaseProvider({Key key, this.child, this.uuid}) : super(key: key);
  @override
  _DatabaseProviderState createState() {
    return _DatabaseProviderState(uuid: this.uuid);
  }

  static DatabaseBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_DatabaseWidget) as _DatabaseWidget)._bloc;
  }
}

class _DatabaseProviderState extends State<DatabaseProvider> {
  static final DatabaseType database = DatabaseType.memory;
  final String uuid;
  final DatabaseBloc bloc;
  
  _DatabaseProviderState({this.uuid}):
  this.bloc = database == DatabaseType.firestore ? FirebaseDatabaseBloc(uuid: uuid) : MemoryDatabaseBloc();

  @override
  Widget build(BuildContext context) {
    final child =  _DatabaseWidget(bloc: this.bloc, child: this.widget.child);
    if (database == DatabaseType.firestore) {
      return FirestoreProvider(child: child);
    } else {
      return child;
    }
  }
}