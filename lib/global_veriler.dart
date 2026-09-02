import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/recipe.dart';

// Herkesin ulaşabileceği favoriler listesi
List<Recipe> favoriTarifler = [];

// Herkesin ulaşabileceği TÜM TARİFLER listesi
List<Recipe> tumTarifler = [];

// 1. JSON dosyasını okuyup ana listeye atma işlemi
Future<void> tumTarifleriYukle() async {
  if (tumTarifler.isEmpty) { 
    final String response = await rootBundle.loadString('assets/recipes.json');
    final data = await jsonDecode(response);
    tumTarifler = (data as List).map((json) => Recipe.fromJson(json)).toList();
  }
}

// 2. Uygulama açıldığında telefonun hafızasından favorileri yükle
Future<void> favorileriYukle() async {
  final prefs = await SharedPreferences.getInstance();
  final String? kayitliVeri = prefs.getString('favori_tarifler_listesi');
  
  if (kayitliVeri != null) {
    List<dynamic> jsonListesi = jsonDecode(kayitliVeri);
    favoriTarifler = jsonListesi
        .map((json) => Recipe.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}

// 3. Kalbe basıldığında favorileri telefonun hafızasına kaydet
Future<void> favorileriKaydet() async {
  final prefs = await SharedPreferences.getInstance();
  
  List<Map<String, dynamic>> jsonListesi = favoriTarifler.map((t) => t.toJson()).toList();
  await prefs.setString('favori_tarifler_listesi', jsonEncode(jsonListesi));
}