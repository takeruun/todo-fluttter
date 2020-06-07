import 'package:flutter/material.dart';
import 'models/todo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter ToDo app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyLists(),
    );
  }
}

class MyLists extends StatefulWidget {
  @override
  _MyListsState createState() => _MyListsState();
}

class _MyListsState extends State<MyLists> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Yeah"),
    );
  }
}
