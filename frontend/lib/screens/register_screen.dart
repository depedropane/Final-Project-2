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

  // ── Input decoration shared style ──────────────────────────────────────────
  InputDecoration _inputDec(String hint, {Widget? suffix, Widget? prefix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      suffixIcon: suffix,
      prefixIcon: prefix,
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF15BE77), width: 2),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF15BE77)),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        // Format: YYYY-MM-DD (sesuai backend requirement)
        _tanggalLahirController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedGender == null) {
      Fluttertoast.showToast(
        msg: 'Pilih jenis kelamin',
        backgroundColor: Colors.red,
      );
      return;
    }

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

    if (!mounted) return;

    if (success) {
      Fluttertoast.showToast(
        msg: 'Registrasi berhasil! Silakan login',
        backgroundColor: Colors.green,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      Fluttertoast.showToast(
        msg: authProvider.errorMessage ?? 'Registrasi gagal',
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  // ── Build ───────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 8),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      const Text(
                        'Daftar Akun',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Masukkan data identitas dirimu untuk mulai\nmenggunakan layanan kesehatan kami.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // ── Nama ──────────────────────────────────────────────
                      _label('Nama'),
                      TextFormField(
                        controller: _namaController,
                        decoration: _inputDec('Contoh: megah toruan'),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Nama wajib diisi' : null,
                      ),
                      const SizedBox(height: 16),

                      // ── Email ─────────────────────────────────────────────
                      _label('Email'),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _inputDec(
                          'Contoh: megahtoruan@gmail.com',
                          suffix: Icon(Icons.visibility_off_outlined,
                              color: Colors.grey[400]),
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Email wajib diisi' : null,
                      ),
                      const SizedBox(height: 16),

                      // ── Password ──────────────────────────────────────────
                      _label('Password'),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: _inputDec(
                          'Masukkan Minimal 8 Karakter',
                          suffix: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.grey[400],
                            ),
                            onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        validator: (v) => v == null || v.length < 8
                            ? 'Password minimal 8 karakter'
                            : null,
                      ),
                      const SizedBox(height: 16),

                      // ── NIK ───────────────────────────────────────────────
                      _label('NIK (16 Digit)'),
                      TextFormField(
                        controller: _nikController,
                        keyboardType: TextInputType.number,
                        maxLength: 16,
                        decoration: _inputDec('3201xxxxxxxxxx')
                            .copyWith(counterText: ''),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'NIK wajib diisi';
                          if (v.length != 16) return 'NIK harus tepat 16 digit';
                          if (!RegExp(r'^\d+$').hasMatch(v))
                            return 'NIK hanya boleh berisi angka';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // ── Tanggal Lahir + No Telepon ────────────────────────
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('Tanggal Lahir'),
                                TextFormField(
                                  controller: _tanggalLahirController,
                                  readOnly: true,
                                  decoration: _inputDec(
                                    'mm / dd / yyyy',
                                    prefix: Icon(Icons.calendar_month_outlined,
                                        color: Colors.grey[400], size: 20),
                                  ),
                                  onTap: () => _selectDate(context),
                                  validator: (v) => v == null || v.isEmpty
                                      ? 'Wajib diisi'
                                      : null,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('No Telepon'),
                                TextFormField(
                                  controller: _noTeleponController,
                                  keyboardType: TextInputType.phone,
                                  decoration: _inputDec(
                                    '08xx',
                                    prefix: Icon(Icons.phone_outlined,
                                        color: Colors.grey[400], size: 20),
                                  ),
                                  validator: (v) => v == null || v.isEmpty
                                      ? 'Wajib diisi'
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // ── Jenis Kelamin ─────────────────────────────────────
                      _label('Jenis Kelamin'),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _genderBtn('Laki-laki', 'L', Icons.male),
                          const SizedBox(width: 12),
                          _genderBtn('Perempuan', 'P', Icons.female),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // ── Tempat Lahir ──────────────────────────────────────
                      _label('Tempat Lahir'),
                      TextFormField(
                        controller: _tempatLahirController,
                        decoration: _inputDec('Contoh: Jakarta'),
                        validator: (v) => v == null || v.isEmpty
                            ? 'Tempat lahir wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 16),

                      // ── Alamat ────────────────────────────────────────────
                      _label('Alamat'),
                      TextFormField(
                        controller: _alamatController,
                        maxLines: 3,
                        decoration: _inputDec('Jalan, Kelurahan, Kecamatan'),
                        validator: (v) => v == null || v.isEmpty
                            ? 'Alamat wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 32),

                      // ── Tombol Daftar ─────────────────────────────────────
                      Consumer<AuthProvider>(
                        builder: (context, auth, _) => SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: auth.isLoading ? null : _register,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF15BE77),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: auth.isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Daftar Sekarang  →',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ── Link ke Login ─────────────────────────────────────
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Sudah punya akun? ',
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey[600]),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LoginScreen()),
                              ),
                              child: const Text(
                                'Masuk',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF15BE77),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          text,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      );

  Widget _genderBtn(String label, String value, IconData icon) {
    final selected = _selectedGender == value;
    final isPerempuan = value == 'P';
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedGender = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: selected ? const Color(0xFF15BE77) : Colors.grey[300]!,
              width: selected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: isPerempuan
                    ? const Color(0xFFE91E8C)
                    : const Color(0xFF15BE77),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  color: selected ? const Color(0xFF15BE77) : Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
