import 'package:flutter/material.dart';

void main() {
  runApp(const EloPetApp());
}

class EloPetApp extends StatelessWidget {
  const EloPetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elo Pet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5F2EA), 
        primaryColor: const Color(0xFF263F50), 
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF568B89), 
          primary: const Color(0xFF263F50),
          secondary: const Color(0xFF568B89),
        ),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text(
            'Elo Pet\nToda vida merece uma segunda chance.',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF263F50),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}