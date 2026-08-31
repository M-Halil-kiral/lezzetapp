import 'package:flutter/material.dart';
import 'package:lezzetapp/models/recipe.dart';
import 'package:lezzetapp/tarif_detay.dart';

class FavorilerSayfasi extends StatefulWidget {
  // Şimdilik test için dışarıdan liste alıyoruz, sonra bunu telefonun hafızasına bağlayacağız.
  final List<Recipe> favoriTarifler;

  const FavorilerSayfasi({super.key, required this.favoriTarifler});

  @override
  State<FavorilerSayfasi> createState() => _FavorilerSayfasiState();
}

class _FavorilerSayfasiState extends State<FavorilerSayfasi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Column(
          children: [
            // Üst Başlık
            const Padding(
              padding: EdgeInsets.only(top: 35.0, left: 16.0, right: 16.0, bottom: 20.0),
              child: Row(
                children: [
                  Icon(Icons.favorite, color: Colors.red, size: 30),
                  SizedBox(width: 10),
                  Text(
                    'Favorilerim',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            // Favori Listesi
            Expanded(
              child: widget.favoriTarifler.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.heart_broken, size: 80, color: Colors.grey[300]),
                          const SizedBox(height: 15),
                          const Text(
                            'Henüz favori tarifiniz yok.',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: widget.favoriTarifler.length,
                      itemBuilder: (context, index) {
                        final recipe = widget.favoriTarifler[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TarifDetaySayfasi(tarif: recipe),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                // Görsel Kutusu
                                Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: const Icon(Icons.fastfood, size: 40, color: Colors.orange),
                                ),
                                const SizedBox(width: 15),
                                // Bilgiler
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        recipe.tarifAdi,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Süre: ⏱️ ${recipe.pisirmeSuresiDk ?? 0} dk',
                                        style: const TextStyle(fontSize: 13, color: Colors.black87),
                                      ),
                                    ],
                                  ),
                                ),
                                // Çıkarma Butonu
                                IconButton(
                                  icon: const Icon(Icons.favorite, color: Colors.red),
                                  onPressed: () {
                                    // İleride buraya favorilerden çıkarma kodunu yazacağız
                                  },
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}