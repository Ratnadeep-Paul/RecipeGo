import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screen/home.dart';
import 'screen/login.dart';
import 'screen/search.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Login(),
    routes: {
      "/login": (context) => Login(),
      "/home": (context) => Home(),
    },
  ));
}
