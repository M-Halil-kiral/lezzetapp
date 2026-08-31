import 'package:flutter/material.dart';
import 'home_page.dart';
import 'favoriler_sayfasi.dart';
import 'global_veriler.dart';

class AnaIskelet extends StatefulWidget {
  const AnaIskelet({super.key});

  @override
  State<AnaIskelet> createState() => _AnaIskeletState();
}

class _AnaIskeletState extends State<AnaIskelet> {
  int _seciliIndex = 0;

  // Geçiş yapılacak sayfaların listesi
  final List<Widget> _sayfalar = [
    const AnaSayfa(),
    FavorilerSayfasi(favoriTarifler: favoriTarifler), // Global listeyi gönderiyoruz
    const Center(child: Text("Tarifler Yakında")),
    const Center(child: Text("Zamanlayıcı Yakında")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _sayfalar[_seciliIndex],
      
      // Senin şık alt menü tasarımın, artık tüm sayfalarda sabit ve tıklanabilir!
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _menuButonu(Icons.home, 0),
            _menuButonu(Icons.favorite, 1),
            _menuButonu(Icons.restaurant, 2),
            _menuButonu(Icons.pending, 3),
          ],
        ),
      ),
    );
  }

  // Butonlara tıklanma efekti ve renk değişimi veren özel fonksiyon
  Widget _menuButonu(IconData ikon, int index) {
    bool seciliMi = _seciliIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _seciliIndex = index;
        });
      },
      child: Icon(
        ikon,
        size: 32,
        color: seciliMi ? Colors.orange : Colors.grey,
      ),
    );
  }
}