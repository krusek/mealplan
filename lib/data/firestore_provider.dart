import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

/// This widget is used to provide the connection to firestore. It has
/// a helper inherited widget that is used for speedy ancestor lookups.
/// 
/// In order for the firestore to work the file `assets/firestore.json` 
/// needs to be provided. See [FirestoreBloc._load] to see what is 
/// expected in that json file.
class FirestoreProvider extends StatefulWidget {
  final Widget _child;
  FirestoreProvider({Widget child}) : this._child = child;

  static FirestoreBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(_FirestoreWidget) as _FirestoreWidget)
          .state.bloc;

  @override
  State<StatefulWidget> createState() {
    return _FirestoreState();
  }
}

class _FirestoreWidget extends InheritedWidget {
  final _FirestoreState state;
  _FirestoreWidget({Widget child, @required this.state}): super(child: child);

  /// This is only used as a helper, so notification is never needed.
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

}

class _FirestoreState extends State<FirestoreProvider> {
  FirestoreBloc bloc;
  _FirestoreState({FirestoreBloc bloc}): this.bloc = bloc ?? FirestoreBloc();
  @override
  Widget build(BuildContext context) {
    return _FirestoreWidget(child: this.widget._child, state: this);
  }

}

class FirestoreBloc {
  Firestore _firestore;
  Future _loader;

  FirestoreBloc() {
    _firestore = Firestore.instance;
  }

  Future<void> _load(BuildContext context) async {
    final bundle = DefaultAssetBundle.of(context);
    final string = await bundle.loadString("assets/firestore.json");
    final data = json.decode(string);
    final FirebaseApp app = await FirebaseApp.configure(
      name: 'mealplan',
      options: FirebaseOptions(
        googleAppID: data["googleAppID"],
        gcmSenderID: data["gcmSenderID"],
        apiKey: data["apiKey"],
        projectID: data["projectID"],
        bundleID: data["bundleID"],
      ),
    );
    final Firestore firestore = Firestore(app: app);
    await firestore.settings(timestampsInSnapshotsEnabled: true);  
  }

  Firestore get instance => _firestore;

  Future loader(BuildContext context) {
    if (_loader != null) return _loader;
    _loader = _load(context);
    return _loader;
  }
}