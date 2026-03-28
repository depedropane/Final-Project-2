# Nauli Reminder 🏥

> ⚠️ **STATUS: MASIH DALAM FASE PENGEMBANGAN** - Dokumentasi ini belum final dan akan terus diperbarui.

Aplikasi kesehatan berbasis mobile yang memudahkan pasien untuk mendaftar, login, dan mengakses layanan kesehatan secara digital.

---

## 📌 Deskripsi

**Nauli Reminder** adalah aplikasi full-stack yang terdiri dari:
- **Frontend**: Aplikasi mobile Flutter (lintas platform: Android, iOS, Web, Linux, macOS, Windows)
- **Backend**: REST API menggunakan Go (Gin framework) dengan database PostgreSQL

---

## 🛠️ Teknologi yang Digunakan

### Frontend
| Teknologi | Keterangan |
|-----------|------------|
| Flutter (Dart) | Framework UI lintas platform |
| Provider | State management |
| HTTP | Komunikasi dengan REST API |
| Shared Preferences | Penyimpanan lokal (token & sesi) |
| Google Fonts | Kustomisasi tipografi |
| Flutter Toast | Notifikasi pop-up |
| Intl | Internasionalisasi & format tanggal |
| Smooth Page Indicator | Indikator halaman onboarding |

### Backend
| Teknologi | Keterangan |
|-----------|------------|
| Go | Bahasa pemrograman utama |
| Gin | Web framework HTTP |
| GORM | ORM untuk database |
| PostgreSQL | Database relasional |
| godotenv | Manajemen environment variable |
| bcrypt | Enkripsi password |

---

## 📁 Struktur Proyek

```
Final-Project-2/
├── backend/
│   ├── main.go              # Entry point server
│   ├── go.mod               # Go module dependencies
│   ├── database/
│   │   └── connection.go    # Koneksi ke PostgreSQL
│   ├── models/
│   │   ├── pasien.go        # Model data pasien
│   │   └── nakes.go         # Model data tenaga kesehatan
│   ├── handlers/
│   │   ├── pasien_handler.go    # Handler CRUD pasien
│   │   └── nakes_handler.go     # Handler CRUD nakes
│   └── routes/
│       └── routes.go        # Definisi endpoint API
│
└── frontend/
    ├── pubspec.yaml         # Flutter dependencies
    └── lib/
        ├── main.dart        # Entry point Flutter
        ├── config/
        │   └── app_config.dart   # Konfigurasi URL API
        ├── models/
        │   └── pasien_model.dart # Model data pasien
        ├── providers/
        │   └── auth_provider.dart # State management autentikasi
        ├── screens/
        │   ├── onboarding_screen.dart
        │   ├── login_screen.dart
        │   ├── register_screen.dart
        │   └── home_screen.dart
        └── services/
            └── api_service.dart  # Layanan komunikasi API
```

---

## 🚀 Cara Menjalankan

### Prasyarat
- Go 1.25+
- Flutter SDK 3.x
- PostgreSQL
- Android Emulator / Device (untuk testing mobile)

---

### Backend

1. **Clone repository**
   ```bash
   git clone https://github.com/depedropane/Final-Project-2.git
   cd Final-Project-2/backend
   ```

2. **Buat file `.env`** di folder `backend/` dan isi dengan konfigurasi berikut:
   ```env
   DB_HOST=localhost
   DB_USER=postgres
   DB_PASSWORD=your_password
   DB_NAME=sahabatsehat
   DB_PORT=5432
   DB_SSLMODE=disable
   PORT=8080
   ```

3. **Install dependencies dan jalankan server**
   ```bash
   go mod tidy
   go run main.go
   ```

4. Server berjalan di `http://localhost:8080`

---

### Frontend

1. **Masuk ke folder frontend**
   ```bash
   cd Final-Project-2/frontend
   ```

2. **Install dependencies Flutter**
   ```bash
   flutter pub get
   ```

3. **Jalankan aplikasi** (pastikan emulator/device sudah aktif)
   ```bash
   flutter run
   ```

> **Catatan:** Secara default, frontend dikonfigurasi untuk terhubung ke `http://10.0.2.2:8080/api/v1` (alamat localhost dari Android Emulator). Jika menggunakan device fisik atau platform lain, ubah `baseUrl` di `lib/config/app_config.dart`.


## 👤 Author

**depedropane**  
GitHub: [https://github.com/depedropane](https://github.com/depedropane)
