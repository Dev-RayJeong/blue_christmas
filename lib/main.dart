
import 'package:flutter/material.dart';
import 'postList.dart';

void main() => runApp(MyApp());

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blueGrey
      ),
      title: 'Blue Christmas',
      home: PostList(),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}
