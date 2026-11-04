import 'package:elopet/screens/home.dart';
import 'package:flutter/material.dart';
import 'home.dart'; 

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _iniciarNavegacao();
  }

  // Função para aguardar o tempo e mudar de tela
  Future<void> _iniciarNavegacao() async {
    await Future.delayed(const Duration(seconds: 6));

    if (!mounted) return;

    //pushReplacement substitui a Splash pela Home para o usuário não voltar para a Splash ao apertar "Voltar"
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color(0xFF263F50), 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pets,
              size: 90,
              color: Color(0xFFF5F2EA), 
            ),
            SizedBox(height: 20),
            
            Text(
              'Elo Pet',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF5F2EA), 
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 8),

            Text(
              'Toda vida merece uma segunda chance.',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFFB9C9BD), 
              ),
            ),
            SizedBox(height: 48),

            CircularProgressIndicator(
              color: Color(0xFF568B89), 
            ),
          ],
        ),
      ),
    );
  }
}