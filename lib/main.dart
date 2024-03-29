import 'package:buddiesgram/pages/HomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings = const Settings(

//      timestampsInSnapshotsEnabled: true
      );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'funnet.online',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.green.shade400,
        dialogBackgroundColor: Colors.greenAccent,
        primarySwatch: Colors.green,
        accentColor: Colors.green,
        cardColor: Colors.white70,
      ),
      home: HomePage(),
    );
  }
}
