import 'package:elopet/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(EloPetApp());
}

class EloPetApp extends StatelessWidget {
  EloPetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elo Pet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFF5F2EA), 
        primaryColor: Color(0xFF263F50), 
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF568B89), 
          primary: Color(0xFF263F50),
          secondary: Color(0xFF568B89),
        ),
        useMaterial3: true,
      ),
      home: SplashScreen(), 
    );
  }
}