
import 'package:flutter_test/flutter_test.dart';
import 'package:mealplan/data/model.dart';
import 'package:uuid/uuid.dart';



Map<String, dynamic> _createJson(List<String> keys, {Map<String, dynamic> base = const {}}) {
  final random = Map<String, dynamic>.fromIterable(keys, value: (_) => Uuid().v1());
  final b = Map<String,dynamic>.from(base);
  b.addAll(random);
  return b;
}

void main() {

  group('parsing', () {
    test('active meal', () async {
      final json = _createJson(['name', 'id']);

      final meal = ActiveMeal.fromJson(json);
      final copy = meal.toJson();
      expect(json, copy);
    });

    test('saved meal', () async {
      List<Map<String, dynamic>> list = _randomIngredientList();
      final json = _createJson(['id', 'name'], base: {'ingredients': list});

      final saved = SavedMeal.fromJson(json);
      final copy = saved.toJson();
      expect(copy, json);
    });

    test('ingredient', () async {
      final json = _createJson(['name', 'required_amount', 'unit']);

      final ingredient = Ingredient.fromJson(json);
      final copy = ingredient.toJson();
      expect(copy, json);
    });


    test('ingredient list', () async {
      List<Map<String, dynamic>> list = _randomIngredientList();

      final ingredients = list.map((json) => Ingredient.fromJson(json)).toList();
      final copy = Ingredient.toJsonList(ingredients);
      expect(copy, list);
    });

    test('mutable ingredient', () async {
      final json = _createJson(['name', 'required_amount', 'unit', 'id']);

      final ingredient = Ingredient.fromJson(json);
      final mutable = MutableIngredient.from(ingredient: ingredient);
      expect(mutable.id != '', true);
      expect(mutable.id != json['id'], true);
      mutable.id = json['id'];
      final copy = mutable.toJson();
      expect(copy, json);
      final string = mutable.toString();
      expect(string, contains(mutable.name));
      expect(string, contains(mutable.requiredAmount));
      expect(string, contains(mutable.unit));
    });

    test('active ingredient', () async {
      final json = _createJson(['name', 'required_amount', 'unit', 'id'], base: {'acquired': true});

      final ingredient = ActiveIngredient.fromJson(json);
      final copy = ingredient.toJson();
      expect(copy, json);
    });

    test('active ingredient from ingredient', () async {
      var json = _createJson(['name', 'required_amount', 'unit', 'id'], base: {'acquired': true});

      final ingredient = Ingredient.fromJson(json);
      final active = ActiveIngredient(ingredient, acquired: true);
      expect(active.id != json['id'], true);
      json['id'] = active.id;
      final copy = active.toJson();
      expect(copy, json);
    });

    test('active ingredient list', () async {
      final list = [
        _createJson(['name', 'required_amount', 'unit', 'id'], base: {'acquired': true}),
        _createJson(['name', 'required_amount', 'unit', 'id'], base: {'acquired': false}),
        _createJson(['name', 'required_amount', 'unit', 'id'], base: {'acquired': false}),
        _createJson(['name', 'required_amount', 'unit', 'id'], base: {'acquired': true}),
      ];

      final ingredients = ActiveIngredient.from(list);
      final copy = ActiveIngredient.toJsonList(ingredients);
      expect(copy, list);
    });
  });
}

List<Map<String, dynamic>> _randomIngredientList() {
  final list = [
    _createJson(['name', 'required_amount', 'unit']),
    _createJson(['name', 'required_amount', 'unit']),
    _createJson(['name', 'required_amount', 'unit']),
    _createJson(['name', 'required_amount', 'unit']),
  ];
  return list;
}