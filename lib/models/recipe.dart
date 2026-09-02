// Malzemeler için alt sınıf
class Malzeme {
  final String isim;
  final String? miktar; // <-- DİKKAT: num yerine String yaptık!
  final String birim;

  Malzeme({
    required this.isim,
    this.miktar,
    required this.birim,
  });

  factory Malzeme.fromJson(Map<String, dynamic> json) {
    return Malzeme(
      // .toString() ekleyerek gelen veri sayı da olsa metin de olsa hepsini güvenli bir şekilde yazata çeviriyoruz.
      isim: json['isim']?.toString() ?? '',
      miktar: json['miktar']?.toString(), 
      birim: json['birim']?.toString() ?? '',
    );
  }
  // Malzeme nesnesini JSON'a çevirir
  Map<String, dynamic> toJson() {
    return {
      'isim': isim,
      'miktar': miktar,
      'birim': birim,
    };
  }

}

// Ana Tarif sınıfı
class Recipe {
  final String tarifAdi;
  final String kategori;
  final dynamic porsiyon; 
  final dynamic hazirlikSuresiDk; 
  final dynamic pisirmeSuresiDk; // Sayı veya metin gelebilir diye dynamic yaptık
  final String zorluk;
  final List<String> pisirmeYontemi;
  final List<Malzeme> malzemeler;
  final List<String> yapilisAdimlari;

  Recipe({
    required this.tarifAdi,
    required this.kategori,
    this.porsiyon,
    this.hazirlikSuresiDk,
    this.pisirmeSuresiDk,
    required this.zorluk,
    required this.pisirmeYontemi,
    required this.malzemeler,
    required this.yapilisAdimlari,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      tarifAdi: json['tarif_adi']?.toString() ?? '',
      kategori: json['kategori']?.toString() ?? '',
      porsiyon: json['porsiyon'],
      hazirlikSuresiDk: json['hazirlik_suresi_dk'],
      pisirmeSuresiDk: json['pisirme_suresi_dk'],
      zorluk: json['zorluk']?.toString() ?? '',
      pisirmeYontemi: List<String>.from(json['pisirme_yontemi'] ?? []),
      malzemeler: (json['malzemeler'] as List?)
              ?.map((item) => Malzeme.fromJson(item))
              .toList() ??
          [],
      yapilisAdimlari: List<String>.from(json['yapilis_adimlari'] ?? []),
    );
  }
  // Recipe nesnesini JSON'a çevirir
  Map<String, dynamic> toJson() {
    return {
      'tarif_adi': tarifAdi,
      'kategori': kategori,
      'porsiyon': porsiyon,
      'hazirlik_suresi_dk': hazirlikSuresiDk,
      'pisirme_suresi_dk': pisirmeSuresiDk,
      'zorluk': zorluk,
      'pisirme_yontemi': pisirmeYontemi,
      // Alt listedeki malzemeleri de tek tek JSON'a çeviriyoruz
      'malzemeler': malzemeler.map((m) => m.toJson()).toList(),
      'yapilis_adimlari': yapilisAdimlari,
    };
  }

}