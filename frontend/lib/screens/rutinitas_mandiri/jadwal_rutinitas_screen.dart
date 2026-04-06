import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/jadwal_rutinitas_model.dart';
import 'tambah_rutinitas_screen.dart';
import 'edit_rutinitas_screen.dart';

class JadwalRutinitasScreen extends StatefulWidget {
  // Hapus 'const' di sini biar gak error di Home Screen
  JadwalRutinitasScreen({super.key});

  @override
  State<JadwalRutinitasScreen> createState() => _JadwalRutinitasScreenState();
}

class _JadwalRutinitasScreenState extends State<JadwalRutinitasScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Timer? _realtimeTimer; 
  bool _isLoading = true;

  // Style Guide Warna
  final Color _bgPage = const Color(0xFFF8FAF9);
  final Color _streakBg = const Color(0xFF10221C);
  final Color _streakTeal = const Color(0xFF13ECA4);
  final Color _green = const Color(0xFF13EC5B);
  final Color _textPrimary = const Color(0xFF0F172A);
  final Color _textSecondary = const Color(0xFF64748B);

  List<JadwalRutinitasItem> _jadwalList = [];
  final int _streakHari = 12;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
    _loadData();

    // Timer: Update UI tiap 1 menit buat cek jam sekarang
    _realtimeTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) {
        setState(() {}); 
      }
    });
  }

  @override
  void dispose() {
    _realtimeTimer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  // --- FUNGSI SAVE & LOAD ---

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> items = _jadwalList.map((e) => e.toJson()).toList();
    await prefs.setString('saved_rutinitas', jsonEncode(items));
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('saved_rutinitas');
    if (data != null) {
      final List<dynamic> decoded = jsonDecode(data);
      setState(() {
        _jadwalList = decoded.map((e) => JadwalRutinitasItem.fromJson(e)).toList();
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  // --- NAVIGASI ---

  Future<void> _navTambah() async {
    final result = await Navigator.push<JadwalRutinitasItem>(
      context,
      MaterialPageRoute(builder: (_) => TambahRutinitasScreen()),
    );
    if (result != null) {
      setState(() => _jadwalList.add(result));
      _saveData();
    }
  }

  Future<void> _navEdit(JadwalRutinitasItem item) async {
    final result = await Navigator.push<JadwalRutinitasItem>(
      context,
      MaterialPageRoute(builder: (_) => EditRutinitasScreen(item: item)),
    );
    if (result != null) {
      final idx = _jadwalList.indexWhere((e) => e.jadwalRutinitasId == result.jadwalRutinitasId);
      if (idx != -1) {
        setState(() => _jadwalList[idx] = result);
        _saveData();
      }
    }
  }

  void _hapusData(JadwalRutinitasItem item) {
    setState(() => _jadwalList.removeWhere((e) => e.jadwalRutinitasId == item.jadwalRutinitasId));
    _saveData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgPage,
      body: SafeArea(
        child: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildHeader(),
                _buildTabBar(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      const Center(child: Text("Halaman Obat")),
                      _buildRutinitasTab(),
                    ],
                  ),
                ),
              ],
            ),
      ),
      floatingActionButton: _buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.chevron_left)),
          const Expanded(
            child: Text('Rutinitas Sehat', textAlign: TextAlign.center, 
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        indicatorColor: _streakTeal,
        labelColor: _textPrimary,
        tabs: const [Tab(text: 'Obat'), Tab(text: 'Rutinitas')],
      ),
    );
  }

  Widget _buildRutinitasTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildStreakCard(),
        const SizedBox(height: 20),
        const Text('Daftar Jadwal Hari Ini', 
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        if (_jadwalList.isEmpty)
          const Center(child: Text("\nBelum ada jadwal"))
        else
          ..._jadwalList.map(_buildCard),
      ],
    );
  }

  Widget _buildStreakCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: _streakBg, borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('🏆 STREAK KAMU!', style: TextStyle(color: _streakTeal, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text('$_streakHari Hari', style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildCard(JadwalRutinitasItem item) {
    // LOGIKA STATUS REAL-TIME
    final now = DateTime.now();
    final parts = item.jamSelesai.split(':');
    final deadline = DateTime(now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]));

    String statusText = "Pending";
    Color badgeColor = Colors.orange.withOpacity(0.15);
    Color textColor = Colors.orange[900]!;

    if (item.status == 'done') {
      statusText = "Selesai";
      badgeColor = _green.withOpacity(0.15);
      textColor = Colors.green[900]!;
    } else if (now.isAfter(deadline)) {
      statusText = "Terlewat";
      badgeColor = Colors.red.withOpacity(0.1);
      textColor = Colors.red[900]!;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(12), 
        border: Border.all(color: const Color(0xFFF1F5F9))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.namaAktivitas, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text("${item.jamMulai} - ${item.jamSelesai}", style: TextStyle(color: _textSecondary, fontSize: 12)),
              const SizedBox(height: 10),
              Row(
                children: [
                  _actionIcon(Icons.edit, Colors.blue, () => _navEdit(item)),
                  const SizedBox(width: 15),
                  _actionIcon(Icons.delete, Colors.red, () => _hapusData(item)),
                ],
              )
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(20)),
            child: Text(statusText, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 11)),
          )
        ],
      ),
    );
  }

  Widget _actionIcon(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: color, size: 16),
      ),
    );
  }

  Widget _buildFAB() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: _navTambah,
        icon: const Icon(Icons.add),
        label: const Text("Tambah Rutinitas", style: TextStyle(fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: _green, 
          foregroundColor: _textPrimary, 
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
        ),
      ),
    );
  }
}