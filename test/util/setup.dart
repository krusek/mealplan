import 'package:flutter/material.dart';
import 'package:mealplan/data/database_provider.dart';
import 'package:mealplan/navigation/navigation_provider.dart';

import 'mock_navigation_bloc.dart';

MaterialApp buildWidget({WidgetBuilder builder, MockNavigationBloc bloc}) {
  bloc = bloc ?? MockNavigationBloc();
  return MaterialApp(
      title: 'Meal Plan',
      theme: ThemeData(
        primaryColor: Colors.blueAccent,
      ),
      color: Colors.blue,
      routes: {
        "/": (context) => NavigationProvider(builder: (_) => bloc, child: Material(child: builder(context)))
      },
      builder: (ctx, navigator) {
        return NavigationProvider(builder: (_) => bloc, child: DatabaseProvider(child: navigator, uuid: "", database: DatabaseType.memory,));
      },
    );
}