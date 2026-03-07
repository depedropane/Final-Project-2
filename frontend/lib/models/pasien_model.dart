class Pasien {
  final int? pasienId;
  final String nama;
  final String email;
  final String? password;
  final String? nik;
  final String? tanggalLahir;
  final String? tempatLahir;
  final String? alamat;
  final String? jenisKelamin;
  final String? noTelepon;

  Pasien({
    this.pasienId,
    required this.nama,
    required this.email,
    this.password,
    this.nik,
    this.tanggalLahir,
    this.tempatLahir,
    this.alamat,
    this.jenisKelamin,
    this.noTelepon,
  });

  factory Pasien.fromJson(Map<String, dynamic> json) {
    return Pasien(
      pasienId: json['pasien_id'],
      nama: json['nama'],
      email: json['email'],
      nik: json['nik'],
      tanggalLahir: json['tanggal_lahir'],
      tempatLahir: json['tempat_lahir'],
      alamat: json['alamat'],
      jenisKelamin: json['jenis_kelamin'],
      noTelepon: json['no_telepon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'email': email,
      if (password != null) 'password': password,
      if (nik != null && nik!.isNotEmpty) 'nik': nik,
      if (tanggalLahir != null && tanggalLahir!.isNotEmpty) 'tanggal_lahir': tanggalLahir,
      if (tempatLahir != null && tempatLahir!.isNotEmpty) 'tempat_lahir': tempatLahir,
      if (alamat != null && alamat!.isNotEmpty) 'alamat': alamat,
      if (jenisKelamin != null) 'jenis_kelamin': jenisKelamin,
      if (noTelepon != null && noTelepon!.isNotEmpty) 'no_telepon': noTelepon,
    };
  }
}