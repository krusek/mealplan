import 'package:flutter/widgets.dart';
import 'package:mealplan/data/database_bloc.dart';
import 'package:mealplan/data/firestore_provider.dart';
import 'package:mealplan/data/model.dart';
import 'package:uuid/uuid.dart';

class FirebaseDatabaseBloc extends DatabaseBloc {
  FirestoreBloc firebase;
  final String savedMealsName = "saved_meals";
  final String activeMealsName = "active_meals";
  final String activeIngredientsName = "active_ingredients";
  @override
  void activateMeal(SavedMeal meal) {
    final String id = Uuid().v1();
    final doc = firebase.instance.collection(activeMealsName).document(id);
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
    return this.firebase.instance.collection(activeMealsName).snapshots().map((snapshot) {
      return snapshot.documents.map((document) {
        Map<String,dynamic> json = document.data;
        json["ingredients"] = [];
        return ActiveMeal.fromJson(json);
      }).toList();  
    });
  }

  @override
  Stream<List<ActiveIngredient>> ingredientsStream(ActiveMeal meal) {
    return this.firebase.instance.document(meal.id).collection(activeIngredientsName).snapshots().map((snapshot) {
      return snapshot.documents.map((document) {
        Map<String,dynamic> json = document.data;
        json["id"] = document.reference.path;
        return ActiveIngredient.fromJson(json);
      }).toList();
    });
  }

  @override
  Future loader(BuildContext context) async {
    this.firebase = FirestoreProvider.of(context);
    await this.firebase.loader;
  }

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
  void saveMeal(String id, String name, List<MutableIngredient> ingredients) {
    final saved = SavedMeal(id, name, ingredients);
    final json = saved.toJson();
    firebase.instance.collection(savedMealsName).document(id).setData(json);
  }

  // TODO: implement savedMealsStream
  @override
  Stream<List<SavedMeal>> get savedMealsStream {
    return firebase.instance.collection(savedMealsName).snapshots().map((snapshot) {
      return snapshot.documents.map((doc) {
        return SavedMeal.fromJson(doc.data);
      }).toList();
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

}