import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../models/pasien_model.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers untuk mengambil input user
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nikController = TextEditingController();
  final _tanggalLahirController = TextEditingController();
  final _tempatLahirController = TextEditingController();
  final _alamatController = TextEditingController();
  final _noTeleponController = TextEditingController();

  String? _selectedGender;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nikController.dispose();
    _tanggalLahirController.dispose();
    _tempatLahirController.dispose();
    _alamatController.dispose();
    _noTeleponController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF26A69A)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _tanggalLahirController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedGender == null) {
        Fluttertoast.showToast(
          msg: "Pilih jenis kelamin",
          backgroundColor: Colors.red,
        );
        return;
      }

      // Membuat objek Pasien sesuai model
      final pasien = Pasien(
        nama: _namaController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        nik: _nikController.text.trim(),
        tanggalLahir: _tanggalLahirController.text,
        tempatLahir: _tempatLahirController.text.trim(),
        alamat: _alamatController.text.trim(),
        jenisKelamin: _selectedGender,
        noTelepon: _noTeleponController.text.trim(),
      );

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.register(pasien);

      if (success) {
        Fluttertoast.showToast(
          msg: "Registrasi berhasil! Silakan login",
          backgroundColor: Colors.green,
        );
        
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: authProvider.errorMessage ?? "Registrasi gagal",
          backgroundColor: Colors.red,
          toastLength: Toast.LENGTH_LONG,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF26A69A),
      resizeToAvoidBottomInset: true, // Layar otomatis menyesuaikan saat keyboard muncul
      appBar: AppBar(
        backgroundColor: const Color(0xFF26A69A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Buat Akun',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            color: const Color(0xFF26A69A),
            child: const Text(
              'Masukkan Identitas Diri Anda',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          
          // Form Content
          Expanded( // Expanded agar sisa layar bisa diisi Container putih
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView( // Memungkinkan konten di-scroll
                physics: const AlwaysScrollableScrollPhysics(), // Scroll tetap aktif meski konten sedikit
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Data Akun',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      
                      _buildTextField('Nama Lengkap', 'Contoh: Megah Lun Kartikasari', _namaController),
                      _buildTextField('Email', 'Contoh: megah@gmail.com', _emailController, keyboardType: TextInputType.emailAddress),
                      _buildTextField('Password', 'Masukkan Minimal 6 Karakter', _passwordController, isPassword: true),
                      _buildTextField('Alamat Lengkap', 'Jalan, Kelurahan, Kecamatan', _alamatController, maxLines: 2),
                      _buildTextField('NIK', '16 digit NIK', _nikController, keyboardType: TextInputType.number),
                      _buildTextField('Tempat Lahir', 'Contoh: Medan', _tempatLahirController),
                      
                      _buildDateField(),
                      _buildTextField('No. Telepon', '08xxxxxxxxx', _noTeleponController, keyboardType: TextInputType.phone),
                      
                      const SizedBox(height: 8),
                      const Text('Jenis Kelamin',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 12),
                      
                      _buildGenderButtons(),
                      
                      const SizedBox(height: 32),
                      
                      // Auth Logic
                      Consumer<AuthProvider>(
                        builder: (context, authProvider, _) {
                          return Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: authProvider.isLoading ? null : _register,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF26A69A),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                  ),
                                  child: authProvider.isLoading
                                      ? const SizedBox(
                                          height: 20, width: 20,
                                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                        )
                                      : const Text(
                                          'Daftar Sekarang →',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                                        ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              OutlinedButton(
                                onPressed: () => Navigator.pop(context),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFF26A69A)),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                  minimumSize: const Size(double.infinity, 50),
                                ),
                                child: const Text(
                                  '← Kembali',
                                  style: TextStyle(fontSize: 16, color: Color(0xFF26A69A), fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(height: 30), // Padding bawah tambahan
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPERS ---

  Widget _buildTextField(String label, String hint, TextEditingController controller,
      {bool isPassword = false, TextInputType? keyboardType, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            obscureText: isPassword && _obscurePassword,
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    )
                  : null,
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF26A69A), width: 2)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            validator: (value) => value == null || value.isEmpty ? '$label wajib diisi' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildDateField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tanggal Lahir', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextFormField(
            controller: _tanggalLahirController,
            readOnly: true,
            decoration: InputDecoration(
              hintText: 'yyyy-mm-dd',
              suffixIcon: const Icon(Icons.calendar_today, color: Color(0xFF26A69A)),
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            onTap: () => _selectDate(context),
            validator: (value) => value == null || value.isEmpty ? 'Tanggal lahir wajib diisi' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildGenderButtons() {
    return Row(
      children: [
        Expanded(child: _genderButton('Laki-Laki', 'L', '👨')),
        const SizedBox(width: 16),
        Expanded(child: _genderButton('Perempuan', 'P', '👩')),
      ],
    );
  }

  Widget _genderButton(String label, String value, String emoji) {
    final isSelected = _selectedGender == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedGender = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF26A69A).withValues(alpha: 0.1) : Colors.white,
          border: Border.all(color: isSelected ? const Color(0xFF26A69A) : Colors.grey[300]!, width: isSelected ? 2 : 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 14, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal, color: isSelected ? const Color(0xFF26A69A) : Colors.grey[700])),
          ],
        ),
      ),
    );
  }
}