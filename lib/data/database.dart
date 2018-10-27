
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:mealplan/data/firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class _DatabaseWidget extends InheritedWidget {
  final DatabaseBloc _bloc;
  _DatabaseWidget({Widget child, DatabaseBloc bloc}): this._bloc = bloc ?? _FirebaseDatabaseBloc(), super(child: child);

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
  final DatabaseBloc bloc = _FirebaseDatabaseBloc();
  @override
  Widget build(BuildContext context) {
    return _DatabaseWidget(bloc: this.bloc, child: this.widget.child);
  }
}

abstract class DatabaseBloc {
  Stream<List<ActiveMeal>> get activeMealaStream;
  Stream<List<SavedMeal>> get savedMealsStream;
  Stream<List<ActiveIngredient>> ingredientsStream(ActiveMeal meal);
  Stream<ActiveIngredient> ingredientStream(ActiveIngredient ingredient);

  void activateMeal(SavedMeal meal);
  void toggle({String id, bool value});
  void saveMeal(String id, String name, List<MutableIngredient> ingredients);
  void removeActiveMeal(ActiveMeal meal);
  Future loader(BuildContext context);
}

class _FirebaseDatabaseBloc extends DatabaseBloc {
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
        print("saved meal doc: ${doc.data}");
        return SavedMeal.fromJson(doc.data);
      }).toList();
    })..listen((data) {
      print("saved meal count: ${data.length}");
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

class _MemoryDatabaseBloc extends DatabaseBloc {
  List<ActiveMeal> _activeMeals = [];
  List<SavedMeal> _savedMeals = [];

  Future loader(BuildContext context) async {
    String data = await DefaultAssetBundle.of(context).loadString("assets/sample_data.json");
    final result = json.decode(data);
    _activeMeals = result['active_meals'].map((item) { return ActiveMeal.fromJson(item); }).cast<ActiveMeal>().toList();
    _savedMeals = result['saved_meals'].map((item) { return SavedMeal.fromJson(item); }).cast<SavedMeal>().toList();
    _activeMealsChanges.add(_activeMeals);
    _savedMealsChanges.add(_savedMeals);
    this.activateMeal(_savedMeals[1]);
    this.activateMeal(_savedMeals[0]);
  }

  final _ingredientChanges = BehaviorSubject<ActiveIngredient>();
  final _activeMealsChanges = BehaviorSubject<List<ActiveMeal>>();
  final _savedMealsChanges = BehaviorSubject<List<SavedMeal>>();

  Stream<List<ActiveMeal>> get activeMealaStream => _activeMealsChanges.stream;
  Stream<List<SavedMeal>> get savedMealsStream => _savedMealsChanges.stream;

  Stream<ActiveIngredient> ingredientStream(ActiveIngredient ingredient) {
    return _ingredientChanges.stream.where((active) { return active.id == ingredient.id; });
  }

  void activateMeal(SavedMeal meal) {
    final activeMeal = ActiveMeal(meal);
    _activeMeals.add(activeMeal);
    _activeMealsChanges.add(_activeMeals);
  }

  void toggle({String id, bool value}) {
    final ingredient = _activeMeals.expand((meal) => meal._ingredients).firstWhere((ingredient) => ingredient.id == id, orElse: () => null);
    ingredient?.acquired = value;
    _ingredientChanges.add(ingredient);
  }

  void saveMeal(String id, String name, List<MutableIngredient> ingredients) {
    _savedMeals.removeWhere((meal) => meal.id == id);
    final saved = SavedMeal(id, name, ingredients);
    _savedMeals.add(saved);
    this._savedMealsChanges.add(_savedMeals);
  }

  void removeActiveMeal(ActiveMeal meal) {
    _activeMeals.remove(meal);
    _activeMealsChanges.add(_activeMeals);
  }

  void dispose() {
    _ingredientChanges.close();
    _activeMealsChanges.close();
    _savedMealsChanges.close();
  }

  @override
  Stream<List<ActiveIngredient>> ingredientsStream(ActiveMeal meal) {
    return activeMealaStream.map((list) {
      for (var m in list) {
        if (m.id == meal.id) { return m._ingredients; }
      }
      return null;
    }).where((list) => list != null).distinct();
  }

}

class ActiveMeal {
  final String id;
  final String name;
  final List<ActiveIngredient> _ingredients;

  bool get acquired { 
    if (this._ingredients.length == 0) { return true; }
    return this._ingredients.map((ingredient) => ingredient.acquired).reduce((a,b) => a & b);
  }

  ActiveMeal(SavedMeal meal):
    this.name = meal.name,
    this.id = Uuid().v1(),
    this._ingredients = meal.ingredients.map((ingredient) { return ActiveIngredient(ingredient); }).toList();
  ActiveMeal.fromJson(Map<String, dynamic> json)
    : this.name = json["name"],
      this.id = json["id"],
      this._ingredients = ActiveIngredient.from(json['ingredients']);
  Map<String, dynamic> toJson() {
    final json = Map<String, dynamic>();
    json["name"] = this.name;
    json["id"] = this.id;
    json["ingredients"] = ActiveIngredient.toJsonList(this._ingredients);
    return json;
  }
}

class SavedMeal {
  final String id;
  final String name;
  final List<Ingredient> ingredients;

  SavedMeal(this.id, this.name, List<MutableIngredient> mutable):
    this.ingredients = mutable.map((ingredient) => Ingredient(name: ingredient.name, requiredAmount: ingredient.requiredAmount, unit: ingredient.unit)).toList();
  SavedMeal.fromJson(Map<String, dynamic> json)
    : name = json["name"],
      id = json["id"],
      ingredients = json['ingredients'].map((item){ return Ingredient.fromJson(Map<String,dynamic>.from(item)); }).cast<Ingredient>().toList();

  Map<String, dynamic> toJson() {
    final json = Map<String, dynamic>();
    json["name"] = this.name;
    json["id"] = this.id;
    json["ingredients"] = Ingredient.toJsonList(this.ingredients);
    return json;
  }
}

class Ingredient {
  final String name;
  final String requiredAmount;
  final String unit;

  Ingredient({this.name = "", this.requiredAmount = "", this.unit = ""});
  Ingredient.fromJson(Map<String,dynamic> json)
  : name = json['name'],
    requiredAmount = json['required_amount'],
    unit = json['unit'];
  
  Map<String, dynamic> toJson() {
    final json = Map<String, dynamic>();
    json['name'] = this.name;
    json['required_amount'] = this.requiredAmount;
    json['unit'] = this.unit;
    return json;
  }

  static List<Map<String, dynamic>> toJsonList(List<Ingredient> ingredients) {
    return ingredients.map((ingredient) => ingredient.toJson()).toList();
  }

}

class ActiveIngredient {
  final String id;
  final String name;
  final String requiredAmount;
  final String unit;
  bool acquired;

  ActiveIngredient(Ingredient ingredient): 
    this.name = ingredient.name, 
    this.requiredAmount = ingredient.requiredAmount, 
    this.unit = ingredient.unit,
    this.acquired = false,
    this.id = Uuid().v1();
  ActiveIngredient.fromJson(Map<String,dynamic> json)
  : name = json['name'],
    requiredAmount = json['required_amount'],
    unit = json['unit'],
    acquired = json['acquired'],
    id = json['id'];
  
  Map<String, dynamic> toJson() {
    final json = Map<String, dynamic>();
    json['name'] = this.name;
    json['id'] = this.id;
    json['required_amount'] = this.requiredAmount;
    json['unit'] = this.unit;
    json['acquired'] = this.acquired;
    return json;
  }

  static List<Map<String, dynamic>> toJsonList(List<ActiveIngredient> ingredients) {
    return ingredients.map((ingredient) => ingredient.toJson()).toList();
  }

  static List<ActiveIngredient> from(List<dynamic> json) {
    final items = json.map((item){ return ActiveIngredient.fromJson(item); }).cast<ActiveIngredient>().toList();
    return items;
  }
}

class MutableIngredient {
  String id;
  String name = "";
  String requiredAmount = "";
  String unit = "";
  MutableIngredient(): this.id = Uuid().v1();

  static MutableIngredient from({Ingredient ingredient}) {
    final mutable = MutableIngredient();
    mutable.name = ingredient.name;
    mutable.requiredAmount = ingredient.requiredAmount;
    mutable.unit = ingredient.unit;
    return mutable;
  }

  @override
  String toString() {
    return "ingredient: $name for $requiredAmount - $unit";
  }
}