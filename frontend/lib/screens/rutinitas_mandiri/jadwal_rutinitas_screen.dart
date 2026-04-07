import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../models/jadwal_rutinitas_model.dart';
import 'tambah_rutinitas_screen.dart';
import 'edit_rutinitas_screen.dart';

class JadwalRutinitasScreen extends StatefulWidget {
<<<<<<< Updated upstream
  // Hapus 'const' di sini biar gak error di Home Screen
  JadwalRutinitasScreen({super.key});
=======
  const JadwalRutinitasScreen({super.key});
>>>>>>> Stashed changes

  @override
  State<JadwalRutinitasScreen> createState() => _JadwalRutinitasScreenState();
}

class _JadwalRutinitasScreenState extends State<JadwalRutinitasScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Timer? _realtimeTimer; 
  bool _isLoading = true;

<<<<<<< Updated upstream
  // Style Guide Warna
  final Color _bgPage = const Color(0xFFF8FAF9);
  final Color _streakBg = const Color(0xFF10221C);
  final Color _streakTeal = const Color(0xFF13ECA4);
  final Color _green = const Color(0xFF13EC5B);
  final Color _textPrimary = const Color(0xFF0F172A);
  final Color _textSecondary = const Color(0xFF64748B);

  List<JadwalRutinitasItem> _jadwalList = [];
  final int _streakHari = 12;

=======
  static const Color _bgPage = Color(0xFFF8FAF9);
  static const Color _primaryGreen = Color(0xFF13ECA4); 
  static const Color _streakBg = Color(0xFF0F1B17);    
  static const Color _textPrimary = Color(0xFF1E293B);
  static const Color _textSecondary = Color(0xFF94A3B8);
  static const Color _cardBg = Colors.white;
  static const Color _statusGreen = Color(0xFF91F5C8);
  static const Color _statusRed = Color(0xFFFF4133);

  final int _streakHari = 12;

  // List Data
  final List<JadwalRutinitasItem> _jadwalList = [
    JadwalRutinitasItem(
      jadwalRutinitasId: 1,
      namaAktivitas: 'Lari Pagi',
      jamMulai: '06:30',
      jamSelesai: '07:00',
      pengulangan: ['Sen', 'Sel'],
      status: 'done',
    ),
    JadwalRutinitasItem(
      jadwalRutinitasId: 2,
      namaAktivitas: 'Minum Air Putih',
      jamMulai: '19:00',
      jamSelesai: '20:00',
      pengulangan: ['Setiap Hari'],
      status: 'done',
    ),
    JadwalRutinitasItem(
      jadwalRutinitasId: 3,
      namaAktivitas: 'Makan malam',
      jamMulai: '08:00',
      jamSelesai: '09:00',
      pengulangan: ['Setiap Hari'],
      status: 'done',
    ),
    JadwalRutinitasItem(
      jadwalRutinitasId: 4,
      namaAktivitas: 'Sedekah',
      jamMulai: '21:00',
      jamSelesai: '22:00',
      pengulangan: ['Jum'],
      status: 'terlewat',
    ),
  ];

>>>>>>> Stashed changes
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
<<<<<<< Updated upstream
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
=======
  }

  // FUNGSI NAVIGASI TAMBAH
  Future<void> _navTambah() async {
    final result = await Navigator.push<JadwalRutinitasItem>(
      context,
      MaterialPageRoute(builder: (_) => const TambahRutinitasScreen()),
    );
    if (result != null) {
      setState(() => _jadwalList.add(result));
    }
  }

  // FUNGSI NAVIGASI EDIT
  Future<void> _navEdit(JadwalRutinitasItem item) async {
    final result = await Navigator.push<JadwalRutinitasItem>(
      context,
      MaterialPageRoute(builder: (_) => EditRutinitasScreen(item: item)),
    );
    if (result != null) {
      final index = _jadwalList.indexWhere((e) => e.jadwalRutinitasId == result.jadwalRutinitasId);
      if (index != -1) {
        setState(() => _jadwalList[index] = result);
      }
    }
  }

  // FUNGSI HAPUS
  Future<void> _confirmHapus(JadwalRutinitasItem item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Hapus Rutinitas"),
        content: Text("Yakin ingin menghapus '${item.namaAktivitas}'?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal", style: TextStyle(color: Colors.grey))),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Hapus", style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _jadwalList.removeWhere((e) => e.jadwalRutinitasId == item.jadwalRutinitasId);
      });
    }
>>>>>>> Stashed changes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgPage,
<<<<<<< Updated upstream
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
=======
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: _textPrimary, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Rutinitas Sehat', style: TextStyle(color: _textPrimary, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildStreakCard(),
          _buildCustomTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                const Center(child: Text("Halaman Jadwal Obat")),
                _buildRutinitasTab(),
              ],
            ),
          ),
>>>>>>> Stashed changes
        ],
      ),
      floatingActionButton: _buildFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

<<<<<<< Updated upstream
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
=======
  Widget _buildCustomTabBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.centerLeft,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: _textPrimary,
        unselectedLabelColor: _textSecondary,
        indicatorColor: _primaryGreen,
        indicatorWeight: 3,
        tabs: const [Tab(text: 'Obat'), Tab(text: 'Rutinitas')],
      ),
    );
  }

  Widget _buildStreakCard() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      decoration: BoxDecoration(color: _streakBg, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
>>>>>>> Stashed changes
        children: [
          Row(
            children: [
<<<<<<< Updated upstream
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
=======
              const Icon(Icons.emoji_events_outlined, color: Colors.orange, size: 20),
              const SizedBox(width: 8),
              Text("STREAK KAMU!", style: TextStyle(color: _primaryGreen.withOpacity(0.9), fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Text("$_streakHari Hari", style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildRutinitasTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 100),
      children: [
        const Text('Daftar Jadwal Hari Ini', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: _textPrimary)),
        const SizedBox(height: 16),
        ..._jadwalList.map((item) => _buildJadwalCard(item)),
      ],
    );
  }

  Widget _buildJadwalCard(JadwalRutinitasItem item) {
    bool isDone = item.status == 'done';
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: _cardBg, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)]),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.namaAktivitas, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 6),
                Text("${item.jamMulai} - ${item.jamSelesai}", style: const TextStyle(color: _textSecondary, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(color: isDone ? _statusGreen : _statusRed, borderRadius: BorderRadius.circular(15)),
                child: Text(isDone ? "Selesai" : "Terlewat", style: TextStyle(color: isDone ? const Color(0xFF065F46) : Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _navEdit(item), // SEKARANG BISA DITEKAN
                    child: const Icon(Icons.edit_note_rounded, color: Colors.blue, size: 26),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => _confirmHapus(item), // SEKARANG BISA DITEKAN
                    child: const Icon(Icons.delete_rounded, color: Colors.red, size: 22),
                  ),
                ],
              )
            ],
          ),
>>>>>>> Stashed changes
        ],
      ),
    );
  }

<<<<<<< Updated upstream
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
=======
  Widget _buildFab() {
    return Container(
      height: 52,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 50),
      child: ElevatedButton(
        onPressed: _navTambah, // SEKARANG BISA DITEKAN
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryGreen,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: _textPrimary, size: 24),
            SizedBox(width: 6),
            Text("Tambah Rutinitas", style: TextStyle(color: _textPrimary, fontWeight: FontWeight.bold, fontSize: 15)),
          ],
>>>>>>> Stashed changes
        ),
      ),
    );
  }
}