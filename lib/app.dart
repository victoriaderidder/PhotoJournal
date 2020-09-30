import 'package:flutter/material.dart';
import 'widgets/homepage.dart';

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wasteagram',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blueGrey,
        accentColor: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'Wasteagram'),
    );
  }
}
