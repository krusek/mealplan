import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

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
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

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
  CollectionReference _savedMealCollection;
  CollectionReference _activeMealCollection;

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

    _savedMealCollection = this.instance.collection("saved_meals");
    _activeMealCollection = this.instance.collection("active_meals");
  }

  Stream<QuerySnapshot> get savedMealsStream => _savedMealCollection.snapshots();
  Stream<QuerySnapshot> get activeMealCollection => _activeMealCollection.snapshots();

  Firestore get instance => _firestore;

  Future loader(BuildContext context) {
    if (_loader != null) return _loader;
    _loader = _load(context);
    return _loader;
  }
}