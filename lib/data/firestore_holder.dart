import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

/// In order for the firestore to work the file `assets/firestore.json` 
/// needs to be provided. See [FirestoreHolder._load] to see what is 
/// expected in that json file.
class FirestoreHolder {
  Firestore _firestore;
  Future _loader;

  FirestoreHolder() {
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