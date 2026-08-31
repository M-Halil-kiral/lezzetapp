import 'package:flutter/material.dart';
// İskelet dosyamızı buraya dahil ediyoruz
import 'ana_iskelet.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lezzet Tarifleri',
      debugShowCheckedModeBanner: false,
      // DİKKAT: Burası AnaSayfa() DEĞİL, AnaIskelet() olmalı!
      home: const AnaIskelet(), 
    );
  }
}