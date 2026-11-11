import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/menu.dart'; // Mengimpor file menu.dart yang sudah dibuat

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyPortfolio',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          secondary: Colors.amber[700],
        ),
        useMaterial3: true,
      ),
      home: MyHomePage(), // Menghubungkan ke MyHomePage dari menu.dart
    );
  }
}