import 'dart:async';

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

    _loader = _load();
  }

  Future<void> _load() async {
    final FirebaseApp app = await FirebaseApp.configure(
      name: 'mealplan',
      options: const FirebaseOptions(
        googleAppID: '1:1027379553987:ios:8616aae43e5489f9',
        gcmSenderID: '1027379553987',
        apiKey: 'AIzaSyBVxtNl3v1O0VHLadE4x64JwDFTH81tM9A',
        projectID: 'mealplan-9d33e',
        bundleID: "com.korbonix.mealplan",
      ),
    );
    final Firestore firestore = Firestore(app: app);
    await firestore.settings(timestampsInSnapshotsEnabled: true);

    _savedMealCollection = this.instance.collection("saved_meals");
    _activeMealCollection = this.instance.collection("active_meals");
    
    _savedMealCollection.snapshots().listen((snapshot) {
      if (snapshot.documents.length > 0) {
        print("saved meal changes: ${snapshot.documents[0].data}");
      } else {
        print("empty saved meals");
      }
    });
    _activeMealCollection.snapshots().listen((snapshot) {
      if (snapshot.documents.length > 0) {
        print("active meal changes: ${snapshot.documents[0].data}");
      } else {
        print("empty active meals");
      }
    });
  }

  Stream<QuerySnapshot> get savedMealsStream => _savedMealCollection.snapshots();
  Stream<QuerySnapshot> get activeMealCollection => _activeMealCollection.snapshots();

  void deleteReference(DocumentReference reference) {
    this.instance.runTransaction((transaction) {
      transaction.delete(reference);
    });
  }

  Firestore get instance => _firestore;

  Future get loader => _loader;
}