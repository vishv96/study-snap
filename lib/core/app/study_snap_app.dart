import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StudySnapApp extends StatelessWidget {
  const StudySnapApp({super.key});

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudySnap',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Scaffold(body: Center(child: Text('StudySnap'))),
    );
  }
}
