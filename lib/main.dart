import 'dart:convert';

import 'package:figure_flutter/mainpage.dart';
import 'package:figure_flutter/profile_dto.dart';
import 'package:figure_flutter/welcome.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';




String sessionToken = "";
late ProfileDTO sessionProfile;

late SharedPreferences localStorage;

Future initSharedPrefs() async {
  localStorage = await SharedPreferences.getInstance();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSharedPrefs();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Widget screenToShow;
    try {
      sessionToken = localStorage.getString("session_token")!;
      sessionProfile = ProfileDTO.fromJson(jsonDecode(localStorage.getString("profile")!));
      screenToShow = const MainWidget();
    } catch (e) {
      screenToShow = const WelcomeScreen();
    }
    // httpclient.addCredentials(url, realm, credentials)

    return MaterialApp(
        title: 'Figure',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          body: screenToShow,
        ));
  }
}
