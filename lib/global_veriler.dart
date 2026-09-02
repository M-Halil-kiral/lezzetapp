import 'dart:convert';
import 'package:flutter/services.dart';
import 'models/recipe.dart';

// Herkesin ulaşabileceği favoriler listesi
List<Recipe> favoriTarifler = [];

// YENİ: Herkesin ulaşabileceği TÜM TARİFLER listesi
List<Recipe> tumTarifler = [];

// JSON dosyasını okuyup ana listeye atma işlemi (Artık global)
Future<void> tumTarifleriYukle() async {
  if (tumTarifler.isEmpty) { // Sadece bir kere yüklenmesini sağlar
    final String response = await rootBundle.loadString('assets/recipes.json');
    final data = await jsonDecode(response);
    tumTarifler = (data as List).map((json) => Recipe.fromJson(json)).toList();
  }
}