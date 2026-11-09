import 'dart:async';
import 'package:flutter/material.dart';
import 'package:projetorealeza/telalogin.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TelaLogin()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/imagens/logo_realeza.png',
              width: 300,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 25),
            const CircularProgressIndicator(
              color: Color(0xFFEBA5D7),
            ),
          ],
        ),
      ),
    );
  }
}

