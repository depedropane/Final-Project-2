class JadwalRutinitasItem {
  final int jadwalRutinitasId;
  final String namaAktivitas;
  final String jamMulai;
  final String jamSelesai;
  final List<String> pengulangan;
  final String status;

  JadwalRutinitasItem({
    required this.jadwalRutinitasId,
    required this.namaAktivitas,
    required this.jamMulai,
    required this.jamSelesai,
    required this.pengulangan,
    required this.status,
  });

  // Fungsi untuk mengubah JSON (dari memori HP) kembali jadi Object Flutter
  factory JadwalRutinitasItem.fromJson(Map<String, dynamic> json) {
    return JadwalRutinitasItem(
      jadwalRutinitasId: json['jadwalRutinitasId'],
      namaAktivitas: json['namaAktivitas'],
      jamMulai: json['jamMulai'],
      jamSelesai: json['jamSelesai'],
      pengulangan: List<String>.from(json['pengulangan']),
      status: json['status'],
    );
  }

  // Fungsi untuk mengubah Object Flutter jadi JSON (biar bisa disimpan ke HP)
  Map<String, dynamic> toJson() {
    return {
      'jadwalRutinitasId': jadwalRutinitasId,
      'namaAktivitas': namaAktivitas,
      'jamMulai': jamMulai,
      'jamSelesai': jamSelesai,
      'pengulangan': pengulangan,
      'status': status,
    };
  }
}