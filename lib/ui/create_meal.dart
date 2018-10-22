
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CreateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: "Meal Name",
            hintText: "Meal Name",
          ),
        )
      ]
    );
  }
} 