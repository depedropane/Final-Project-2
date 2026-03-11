class JadwalObatItem {
  final int jadwalObatId;
  final String jamMinum;
  final String namaObat;
  final String dosis;
  String status; // "pending" atau "done"
  final int? trackingObatId;

  JadwalObatItem({
    required this.jadwalObatId,
    required this.jamMinum,
    required this.namaObat,
    required this.dosis,
    required this.status,
    this.trackingObatId,
  });

  factory JadwalObatItem.fromJson(Map<String, dynamic> json) {
    return JadwalObatItem(
      jadwalObatId: json['jadwal_obat_id'] ?? 0,
      jamMinum: json['jam_minum'] ?? '',
      namaObat: json['nama_obat'] ?? '',
      dosis: json['dosis'] ?? '',
      status: json['status'] ?? 'pending',
      trackingObatId: json['tracking_obat_id'],
    );
  }

  bool get isDone => status == 'done';
}