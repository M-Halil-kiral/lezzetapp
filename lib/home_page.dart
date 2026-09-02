import 'package:flutter/material.dart';
import 'models/recipe.dart'; 
import 'tarif_detay.dart';
import 'global_veriler.dart';

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  // SİLDİK: List<Recipe> tumTarifler = []; (Çünkü artık globalde var)
  
  List<Recipe> gosterilenTarifler = [];
  int gosterilecekAdet = 20;
  final int artisMiktari = 20;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _aramaController = TextEditingController();
  
  bool yukleniyor = true; 
  String arananKelime = "";

  @override
  void initState() {
    super.initState();
    verileriHazirla();
    
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        dahaFazlaYukle();
      }
    });
  }

  // GÜNCELLENDİ: Artık globalden çekiyoruz
  Future<void> verileriHazirla() async {
    await tumTarifleriYukle(); // global_veriler.dart içindeki fonksiyonu çağırdık
    
    setState(() {
      gosterilenTarifler = tumTarifler.take(gosterilecekAdet).toList();
      yukleniyor = false;
    });
  }
                

  // Aşağı kaydırdıkça yeni tarifleri ekleme fonksiyonu
  void dahaFazlaYukle() {
    // Eğer arama yapılıyorsa tüm sonuçları listelediğimiz için sayfalama yapmaya gerek yok
    if (arananKelime.isNotEmpty) return;
    
    // Eğer gösterecek daha fazla tarif kaldıysa limiti artır
    if (gosterilecekAdet < tumTarifler.length) {
      setState(() {
        gosterilecekAdet += artisMiktari;
        gosterilenTarifler = tumTarifler.take(gosterilecekAdet).toList();
      });
    }
  }

  // Arama çubuğuna yazıldıkça tetiklenen fonksiyon
  void aramaYap(String kelime) {
    setState(() {
      arananKelime = kelime;
      
      if (kelime.isEmpty) {
        // Arama kutusu silindiyse eski 20'li sayfalama moduna dön
        gosterilenTarifler = tumTarifler.take(gosterilecekAdet).toList();
      } else {
        // İçinde aranan kelime geçen tarifleri filtrele (büyük/küçük harf duyarlılığını kaldırdık)
        gosterilenTarifler = tumTarifler.where((tarif) {
          return tarif.tarifAdi.toLowerCase().contains(kelime.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Column(
          children: [
            // Üst Kısım: Logo ve Başlık
            Padding(
                  padding: const EdgeInsets.only(top: 35.0, left: 16.0, right: 16.0, bottom: 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Öğeleri sağa ve sola ayırır
                    crossAxisAlignment: CrossAxisAlignment.center, 
                    children: [
                      // Sol taraftaki Logo
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        clipBehavior: Clip.hardEdge, // Görselin köşelerden taşmasını engeller
                        child: Image.asset(
                          'assets/icons/sadelogoyemektarifleri.png',
                          fit: BoxFit.cover, 
                        ),
                      ),
                      
                      // Sağ üstteki Yazı
                      const Text(
                        'Lezzet Tarifleri',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(221, 0, 0, 0),
                        ),
                      ),
                    ],
                  ),
                ),

            // DİNAMİK Arama Çubuğu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(35),
                ),
                child: TextField(
                  controller: _aramaController,
                  onChanged: (kelime) => aramaYap(kelime), // Klavyeye her basıldığında filtrele
                  decoration: const InputDecoration(
                    icon: Icon(Icons.search, color: Colors.black54, size: 26),
                    hintText: 'Bugün Ne Yiyeceğiz ?',
                    hintStyle: TextStyle(color: Colors.black54),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // YEMEK LİSTESİ (Kaydırma kontrolcüsü ve performanslı yapı eklendi)
            Expanded(
              child: yukleniyor 
              ? const Center(child: CircularProgressIndicator()) 
              : gosterilenTarifler.isEmpty
                  ? const Center(child: Text('Aradığınız tarif bulunamadı 😢'))
                  : ListView.builder(
                      controller: _scrollController, // Kaydırmayı dinleyen modül
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: gosterilenTarifler.length,
                               itemBuilder: (context, index) {
                                  final recipe = gosterilenTarifler[index];
                                  
                                  // YENİ KONTROL: Bu tarif favoriler listemizde var mı yok mu bakıyoruz
                                  bool favoriMi = favoriTarifler.any((t) => t.tarifAdi == recipe.tarifAdi);

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
                                          // 1. Yemek Görseli Kutusu
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
                                          
                                          // 2. Yemek Bilgileri (Yazılar)
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
                                                  'Süre: ⏱️ ${recipe.pisirmeSuresiDk ?? 0} dk\nZorluk: ⭐ ${recipe.zorluk.toUpperCase()}',
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // 3. ÇALIŞAN KALP BUTONU İŞTE BURADA:
                                          IconButton(
                                            icon: Icon(
                                              favoriMi ? Icons.favorite : Icons.favorite_border,
                                              color: favoriMi ? Colors.red : Colors.grey,
                                              size: 28,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                if (favoriMi) {
                                                  // Zaten kırmızıyken basılırsa listeden çıkar
                                                  favoriTarifler.removeWhere((t) => t.tarifAdi == recipe.tarifAdi);
                                                } else {
                                                  // Gri iken basılırsa listeye ekle
                                                  favoriTarifler.add(recipe);
                                                }
                                              });
                                            },
                                          ),
                                          
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