import 'package:flutter/material.dart';
import 'models/recipe.dart';

class TarifDetaySayfasi extends StatelessWidget {
  final Recipe tarif; // Ana sayfadan gelecek olan tarif nesnesi

  const TarifDetaySayfasi({super.key, required this.tarif});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: Text(
          tarif.tarifAdi,
          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),


            actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, size: 28),
            onPressed: () {
              // İleride buraya tıklandığında kalbi kırmızı yapma kodu gelecek
              print("Detay sayfasında favoriye tıklandı!");
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Yemek Görseli Alanı (Şimdilik İkon)
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.amber[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.restaurant, size: 80, color: Colors.brown),
            ),
            const SizedBox(height: 20),

            // Süre ve Zorluk Bilgisi
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _infoCard(Icons.timer, '${tarif.pisirmeSuresiDk ?? 0} dk'),
                _infoCard(Icons.star, tarif.zorluk.toUpperCase()),
                if (tarif.kategori.isNotEmpty) _infoCard(Icons.category, tarif.kategori),
              ],
            ),
            const SizedBox(height: 25),

            // MALZEMELER KISMI
            const Text(
              'Malzemeler',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 5)
                ],
              ),
              child: Column(
                children: tarif.malzemeler.map((malzeme) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        const Icon(Icons.circle, size: 10, color: Colors.orange),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '${malzeme.miktar ?? ''} ${malzeme.birim} ${malzeme.isim}',
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 25),

            // YAPILIŞ ADIMLARI KISMI
            const Text(
              'Yapılışı',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...tarif.yapilisAdimlari.asMap().entries.map((adim) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 5)
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      radius: 12,
                      child: Text('${adim.key + 1}', style: const TextStyle(fontSize: 12)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        adim.value,
                        style: const TextStyle(fontSize: 15, height: 1.4),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // Küçük bilgi kartları için yardımcı widget
  Widget _infoCard(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 5)],
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.orange),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}