import 'package:flutter/material.dart';
import 'models/recipe.dart';
import 'tarif_detay.dart';
import 'global_veriler.dart'; 

class MalzemeAramaSayfasi extends StatefulWidget {
  const MalzemeAramaSayfasi({super.key});

  @override
  State<MalzemeAramaSayfasi> createState() => _MalzemeAramaSayfasiState();
}

class _MalzemeAramaSayfasiState extends State<MalzemeAramaSayfasi> {
  final TextEditingController _malzemeController = TextEditingController();
  final List<String> _eklenenMalzemeler = [];
  List<Recipe> _bulunanTarifler = [];
  bool _aramaYapildi = false;

  // TEMEL MALZEMELER LİSTESİ (Bunları evde var sayar ve yüzdeden düşer)
  final List<String> _temelMalzemeler = [
    'tuz', 'su', 'yağ', 'sıvı yağ', 'sıvıyağ', 'zeytinyağı', 
    'karabiber', 'pul biber', 'pulbiber', 'şeker',  'salça'
  ];

  @override
  void initState() {
    super.initState();
    // Sayfa açıldığında tarifler yüklenmemişse yükle
    tumTarifleriYukle(); 
  }

  void _malzemeEkle() {
    String yeniMalzeme = _malzemeController.text.trim().toLowerCase();
    if (yeniMalzeme.isNotEmpty && !_eklenenMalzemeler.contains(yeniMalzeme)) {
      setState(() {
        _eklenenMalzemeler.add(yeniMalzeme);
        _malzemeController.clear();
      });
    }
  }

  void _aramaYap() {
    List<Recipe> sonuclar = [];
    
    for (var tarif in tumTarifler) { 
      // JSON'daki malzemeler listenin adı 'malzemeler' olmalı
      // Malzeme modelindeki isim değişkenin adı neyse (örneğin 'ad', 'isim', 'malzemeAdi') onu kullanıyoruz:
      List<String> tarifMalzemeleri = tarif.malzemeler.map((m) => m.isim).toList();

      // 1. Tarifin içinden temel malzemeleri temizle
      List<String> gerekliAnaMalzemeler = tarifMalzemeleri.where((m) {
        String mLower = m.toLowerCase();
        return !_temelMalzemeler.any((temel) => mLower.contains(temel));
      }).toList();

      // 2. Kalan ana malzemeler ile kullanıcının girdiklerini eşleştir
      int eslesmeSayisi = 0;
      for (var gerekli in gerekliAnaMalzemeler) {
        bool eslestiMi = _eklenenMalzemeler.any((kullaniciMalz) => 
            gerekli.toLowerCase().contains(kullaniciMalz) || 
            kullaniciMalz.contains(gerekli.toLowerCase()));
            
        if (eslestiMi) {
          eslesmeSayisi++;
        }
      }

      // 3. Yüzde 80 Barajı
      double eslesmeOrani = 0;
      if (gerekliAnaMalzemeler.isNotEmpty) {
        eslesmeOrani = (eslesmeSayisi / gerekliAnaMalzemeler.length) * 100;
      } else {
        eslesmeOrani = 100; 
      }

      if (eslesmeOrani >= 80) {
        sonuclar.add(tarif);
      }
    }

    setState(() {
      _bulunanTarifler = sonuclar;
      _aramaYapildi = true;
    });
  }

  void _malzemeSil(String malzeme) {
    setState(() {
      _eklenenMalzemeler.remove(malzeme);
      _bulunanTarifler.clear();
      _aramaYapildi = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Ne Pişirsem?', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _malzemeController,
                    decoration: InputDecoration(
                      hintText: 'Örn: Un, Tavuk, Patates...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (value) => _malzemeEkle(),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _malzemeEkle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Wrap(
              spacing: 8.0,
              children: _eklenenMalzemeler.map((malzeme) {
                return Chip(
                  label: Text(malzeme),
                  backgroundColor: Colors.orange.withValues(alpha: 0.2),
                  deleteIcon: const Icon(Icons.close, size: 18),
                  onDeleted: () => _malzemeSil(malzeme),
                );
              }).toList(),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: _aramaYap,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text('Tarif Bul', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: !_aramaYapildi 
                  ? const Center(child: Text("Malzeme ekleyip arama yapın.", style: TextStyle(color: Colors.grey)))
                  : _bulunanTarifler.isEmpty
                      ? const Center(child: Text("Bu malzemelerle eşleşen tarif bulunamadı 😢", style: TextStyle(color: Colors.redAccent)))
                      : ListView.builder(
                          itemCount: _bulunanTarifler.length,
                          itemBuilder: (context, index) {
                            final tarif = _bulunanTarifler[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              child: ListTile(
                                leading: const Icon(Icons.fastfood, color: Colors.orange),
                                title: Text(tarif.tarifAdi, style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text('${tarif.pisirmeSuresiDk} dk • ${tarif.zorluk}'),
                                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => TarifDetaySayfasi(tarif: tarif)),
                                  );
                                },
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