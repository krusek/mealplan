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
      ),
    );
    final Firestore firestore = Firestore(app: app);
    await firestore.settings(timestampsInSnapshotsEnabled: true);
  }

  Firestore get instance => _firestore;

  Future get loader => _loader;
}