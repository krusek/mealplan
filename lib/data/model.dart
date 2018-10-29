
import 'package:uuid/uuid.dart';

class ActiveMeal {
  final String id;
  final String name;

  ActiveMeal(SavedMeal meal):
    this.name = meal.name,
    this.id = Uuid().v1();
  ActiveMeal.fromJson(Map<String, dynamic> json)
    : this.name = json["name"],
      this.id = json["id"];
  Map<String, dynamic> toJson() {
    final json = Map<String, dynamic>();
    json["name"] = this.name;
    json["id"] = this.id;
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

abstract class IngredientBase {
  String get name;
  String get requiredAmount;
  String get unit;

  Map<String, dynamic> toJson() {
    final json = Map<String, dynamic>();
    json['name'] = this.name;
    json['required_amount'] = this.requiredAmount;
    json['unit'] = this.unit;
    return json;
  }
}

class Ingredient extends IngredientBase {
  final String name;
  final String requiredAmount;
  final String unit;

  Ingredient({this.name = "", this.requiredAmount = "", this.unit = ""});
  Ingredient.fromJson(Map<String,dynamic> json)
  : name = json['name'],
    requiredAmount = json['required_amount'],
    unit = json['unit'];

  static List<Map<String, dynamic>> toJsonList(List<IngredientBase> ingredients) {
    return ingredients.map((ingredient) => ingredient.toJson()).toList();
  }

}

class ActiveIngredient extends IngredientBase {
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
    final json =super.toJson();
    json["id"] = this.id;
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

class MutableIngredient extends IngredientBase {
  String id;
  String name = "";
  String requiredAmount = "";
  String unit = "";
  MutableIngredient(): this.id = Uuid().v1();

  static MutableIngredient from({IngredientBase ingredient}) {
    final mutable = MutableIngredient();
    mutable.name = ingredient.name;
    mutable.requiredAmount = ingredient.requiredAmount;
    mutable.unit = ingredient.unit;
    return mutable;
  }

  @override
    Map<String, dynamic> toJson() {
      final json = super.toJson();
      json["id"] = this.id;
      return json;
    }

  @override
  String toString() {
    return "ingredient: $name for $requiredAmount - $unit";
  }
}