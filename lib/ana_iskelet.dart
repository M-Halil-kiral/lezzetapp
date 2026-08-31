import 'package:flutter/material.dart';
import 'package:lezzetapp/favorier_sayfasi.dart';
import 'home_page.dart';
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
    const Center(child: Text("Yakında")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _sayfalar[_seciliIndex],
      
      // DIŞ KUTU: Ekranın en altına kadar bembeyaz inmesini ve gölgeyi sağlar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Siyahlık olmasın diye beyaz yaptık
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        
        // GÜVENLİK KALKANI: SafeArea'yı İÇERİ koyduk! 
        // Böylece arka plan beyaz kalırken, ikonlar sanal tuşların altında ezilmekten kurtulup yukarı çıkar.
        child: SafeArea(
          child: BottomNavigationBar(
            elevation: 0, // Kendi gölgesini kapattık (Container'ın gölgesini kullanıyoruz)
            selectedItemColor: Colors.orange,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: false, 
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed, 
            backgroundColor: Colors.white, 
            currentIndex: _seciliIndex, 
            onTap: (index) {
              setState(() {
                _seciliIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home, size: 30),
                label: 'Ana Sayfa',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite, size: 30),
                label: 'Favoriler',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.restaurant, size: 30),
                label: 'Tarifler',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.pending, size: 30),
                label: 'Yakında',
              ),
            ],
          ),
        ),
      ), 
    );
  }
}