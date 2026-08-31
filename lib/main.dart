import 'package:flutter/material.dart';
import 'home_page.dart'; // Ana sayfayı diğer dosyadan çağırıyoruz


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lezzet Tarifleri',
      home: const AnaSayfa(),
    );
  }
}