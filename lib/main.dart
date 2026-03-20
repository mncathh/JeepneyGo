import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';

void main() => runApp(const JeepneyGoApp());

// Design Tokens — warm sunset palette
class J {
  // Brand
  static const red = Color(0xFFE8380D);
  static const orange = Color(0xFFFF6B35);
  static const gold = Color(0xFFc9a227);
  static const goldLt = Color(0xFFf5c842);

  // Surface
  static const bg = Color(0xFFF6F2EC);   
  static const card = Color(0xFFFFFCF7);  
  static const white = Color(0xFFFFFFFF);

  // Ink
  static const ink = Color(0xFF1C1814);
  static const sub = Color(0xFF6B6055);
  static const muted = Color(0xFFADA395);
  static const line = Color(0xFFECE6DC);

  // Semantic
  static const green = Color(0xFF16A34A);
  static const blue = Color(0xFF0077B6);
  static const pink = Color(0xFFBE185D);
}

class JeepneyGoApp extends StatelessWidget {
  const JeepneyGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JeepneyGo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Nunito', 
        scaffoldBackgroundColor: J.bg,
        colorScheme: ColorScheme.fromSeed(seedColor: J.red),
      ),
      home: const WelcomeScreen(),
    );
  }
}