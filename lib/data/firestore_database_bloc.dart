import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:mealplan/data/database_bloc.dart';
import 'package:mealplan/data/firestore_provider.dart';
import 'package:mealplan/data/model.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseDatabaseBloc extends DatabaseBloc {
  FirestoreBloc firebase;
  String get savedMealsName => uuid.length > 0 ? "data/$uuid/saved_meals" : "saved_meals";
  String get activeMealsName => uuid.length > 0 ? "data/$uuid/active_meals" : "active_meals";
  String get activeIngredientsName => uuid.length > 0 ? "data/$uuid/active_ingredients" : "active_ingredients";
  String get extraIngredientsName => uuid.length > 0 ? "data/$uuid/extra_ingredients" : "extra_ingredents";
  String uuid = "";

  FirebaseDatabaseBloc({this.uuid});

  @override
  void activateMeal(SavedMeal meal) {
    final String id = Uuid().v1();
    final doc = _activeMealsCollection.document(id);
    doc.setData({
      "id": doc.path,
      "name": meal.name,
    });
    final collection = doc.collection(activeIngredientsName);
    for (var ingredient in meal.ingredients) {
      final String id = Uuid().v1();
      final doc = collection.document(id);
      final data = ingredient.toJson();
      data["id"] = doc.path;
      data["acquired"] = false;
      doc.setData(data);
    }
  }

  @override
  Stream<List<ActiveMeal>> get activeMealaStream {
    return _activeMealsCollection.snapshots().map((snapshot) {
      return snapshot.documents.map((document) {
        Map<String,dynamic> json = document.data;
        json["ingredients"] = [];
        return ActiveMeal.fromJson(json);
      }).toList()..sort((meal1, meal2) => meal1.name.toLowerCase().compareTo(meal2.name.toLowerCase()));  
    });
  }

  @override
  Stream<List<ActiveIngredient>> ingredientsStream(ActiveMeal meal) {
    return this.firebase.instance.document(meal.id).collection(activeIngredientsName).snapshots().map((snapshot) {
      return snapshot.documents.map((document) {
        Map<String,dynamic> json = document.data;
        json["id"] = document.reference.path;
        return ActiveIngredient.fromJson(json);
      }).toList()..sort((ing1, ing2) => ing1.name.toLowerCase().compareTo(ing2.name.toLowerCase()));
    });
  }

  Future _loader;
  @override
  Future loader(BuildContext context) {
    if (_loader == null) _loader = _load(context);
    return _loader;
  }
  Future _load(BuildContext context) async {
    if (this.uuid == null) {
      final preferences = await SharedPreferences.getInstance();
      this.uuid = preferences.getString("uuid") ?? Uuid().v1();
      await preferences.setString("uuid", this.uuid);
    }
    print("uuid: $uuid");
    this.firebase = FirestoreProvider.of(context);
    final _ = await this.firebase.loader(context);
  }

  CollectionReference get _savedMealsCollection => firebase.instance.collection(savedMealsName);
  CollectionReference get _activeMealsCollection => firebase.instance.collection(activeMealsName);
  CollectionReference get _extraItemsCollection => firebase.instance.collection(extraIngredientsName);

  @override
  void removeActiveMeal(ActiveMeal meal) async {
    final doc = firebase.instance.document(meal.id);
    doc.delete();
    final snapshots = await doc.collection(activeIngredientsName).getDocuments();
    snapshots.documents.forEach((snapshot) {
      firebase.instance.document(snapshot.reference.path).delete();
    });
  }

  @override
  SavedMeal saveMeal(String id, String name, List<IngredientBase> ingredients) {
    final saved = SavedMeal(id, name, ingredients);
    final json = saved.toJson();
    _savedMealsCollection.document(id).setData(json);
  }

  @override
  Stream<List<SavedMeal>> get savedMealsStream {
    return _savedMealsCollection.snapshots().map((snapshot) {
      return snapshot.documents.map((doc) {
        return SavedMeal.fromJson(doc.data);
      }).toList()..sort((meal1, meal2) => meal1.name.toLowerCase().compareTo(meal2.name.toLowerCase()));
    });
  }

  @override
  void toggle({String id, bool value}) {
    firebase.instance.document(id).updateData({"acquired": value});
  }

  @override
  Stream<ActiveIngredient> ingredientStream(ActiveIngredient ingredient) {
    return firebase.instance.document(ingredient.id).snapshots().where((document) => document.data != null).map((document) {
      return ActiveIngredient.fromJson(document.data);
    });
  }

  @override
  void clearExtraList() async {
    final query = await _extraItemsCollection.getDocuments();
    query.documents.forEach((snapshot) {
      snapshot.reference.delete();
    });
  }

  @override
  void clearCheckedExtraItems() async {
    final query = await _extraItemsCollection.getDocuments();
    query.documents.forEach((snapshot) {
      if (snapshot.data["acquired"] == true)
        snapshot.reference.delete();
    });
    
  }

  @override
  Stream<List<ActiveIngredient>> get extraShoppingStream {
    return _extraItemsCollection.snapshots().map((snapshot) {
      return snapshot.documents.map((doc) {
        return ActiveIngredient.fromJson(doc.data);
      }).toList()..sort((ing1, ing2) => ing1.name.toLowerCase().compareTo(ing2.name.toLowerCase()));
    });
  }

  @override
  ActiveIngredient addExtraItem(MutableIngredient ingredient) {
    final id = Uuid().v1();
    final doc = _extraItemsCollection.document(id);
    
    final json = ingredient.toJson();
    json["id"] = doc.path;
    json["acquired"] = false;
    doc.setData(json);

    return ActiveIngredient.fromJson(json);
  }

}