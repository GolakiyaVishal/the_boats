import 'package:flutter/material.dart';
import 'package:the_boats/ui/boats_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Boat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BoatsScreen(),
    );
  }
}