import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/jadwal_rutinitas_model.dart';

class RutinitasSehatScreen extends StatefulWidget {
  const RutinitasSehatScreen({super.key});

  @override
  State<RutinitasSehatScreen> createState() => _RutinitasSehatScreenState();
}

class _RutinitasSehatScreenState extends State<RutinitasSehatScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // ── Warna utama dari Figma spec ──────────────────────────────────────────
  static const Color _bgPage        = Color(0xFFF8FAF9);
  static const Color _streakBg      = Color(0xFF10221C);
  static const Color _streakTeal    = Color(0xFF13ECA4);
  static const Color _green         = Color(0xFF13EC5B);
  static const Color _tabActive     = Color(0xFF0F172A);
  static const Color _tabInactive   = Color(0xFF64748B);
  static const Color _cardBg        = Color(0xFFF6F8F7);
  static const Color _cardBorder    = Color(0xFFF1F5F9);
  static const Color _textPrimary   = Color(0xFF0F172A);
  static const Color _textSecondary = Color(0xFF64748B);
  // ─────────────────────────────────────────────────────────────────────────

  final List<JadwalRutinitasItem> _jadwalList = [
    JadwalRutinitasItem(
      jadwalRutinitasId: 1,
      namaAktivitas: 'Lari Pagi',
      jamMulai: '06:30',
      jamSelesai: '07:00',
      pengulangan: ['Sen', 'Sel', 'Rab', 'Kam', 'Jum'],
      status: 'done',
    ),
    JadwalRutinitasItem(
      jadwalRutinitasId: 2,
      namaAktivitas: 'Minum Air Putih',
      jamMulai: '19:00',
      jamSelesai: '20:00',
      pengulangan: ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'],
      status: 'done',
    ),
    JadwalRutinitasItem(
      jadwalRutinitasId: 3,
      namaAktivitas: 'Makan Malam',
      jamMulai: '08:00',
      jamSelesai: '09:00',
      pengulangan: ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'],
      status: 'done',
    ),
    JadwalRutinitasItem(
      jadwalRutinitasId: 4,
      namaAktivitas: 'Sedekah',
      jamMulai: '21:00',
      jamSelesai: '22:00',
      pengulangan: ['Sen', 'Sel', 'Rab', 'Kam', 'Jum'],
      status: 'terlewat',
    ),
  ];

  final int _streakHari = 12;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
    _loadPasienId();
  }

  Future<void> _loadPasienId() async {
    await SharedPreferences.getInstance();
  }

  Future<void> _refresh() async {
    await _loadPasienId();
    await Future.delayed(const Duration(milliseconds: 500));
  }

  String _hariIni() {
    const hari  = ['', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    const bulan = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    final now = DateTime.now();
    return '${hari[now.weekday]}, ${now.day} ${bulan[now.month]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgPage,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildObatTab(),
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

  // ── Header ────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.chevron_left_rounded,
                color: _textPrimary,
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'Rutinitas Sehat',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: _textPrimary,
                fontFamily: 'Roboto',
              ),
            ),
          ),
          const SizedBox(width: 36),
        ],
      ),
    );
  }

  // ── Streak Card ───────────────────────────────────────────────────────────
  Widget _buildStreakCard() {
    return Container(
      decoration: BoxDecoration(
        color: _streakBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // radial gradient overlay (teal subtle)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: RadialGradient(
                  center: const Alignment(-0.8, -0.8),
                  radius: 1.5,
                  colors: [
                    _streakTeal.withOpacity(0.15),
                    _streakTeal.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Text('🏆', style: TextStyle(fontSize: 18)),
                    SizedBox(width: 8),
                    Text(
                      'STREAK KAMU!',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _streakTeal,
                        letterSpacing: 0.7,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '$_streakHari Hari',
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontFamily: 'Roboto',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Tab Bar ───────────────────────────────────────────────────────────────
  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: _tabActive,
        unselectedLabelColor: _tabInactive,
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
          letterSpacing: 0.35,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
          letterSpacing: 0.35,
        ),
        indicatorColor: _streakTeal,
        indicatorWeight: 2.5,
        tabs: const [
          Tab(text: 'Obat'),
          Tab(text: 'Rutinitas'),
        ],
      ),
    );
  }

  // ── Obat Tab ─────────────────────────────────────────────────────────────
  Widget _buildObatTab() {
    return RefreshIndicator(
      color: _green,
      onRefresh: _refresh,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          // Info card obat (pengganti streak)
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0F2744),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: RadialGradient(
                        center: const Alignment(-0.8, -0.8),
                        radius: 1.5,
                        colors: [
                          const Color(0xFF3B82F6).withOpacity(0.2),
                          const Color(0xFF3B82F6).withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Row(
                        children: [
                          Text('💊', style: TextStyle(fontSize: 18)),
                          SizedBox(width: 8),
                          Text(
                            'JADWAL OBAT',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF60A5FA),
                              letterSpacing: 0.7,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Minum obat tepat waktu',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Jangan sampai terlewat ya!',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF93C5FD),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Section header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Daftar Jadwal Obat',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: _textPrimary,
                  fontFamily: 'Roboto',
                  letterSpacing: -0.45,
                ),
              ),
              Text(
                _hariIni(),
                style: const TextStyle(
                  fontSize: 12,
                  color: _textSecondary,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Empty state obat
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Column(
                children: const [
                  Text('💊', style: TextStyle(fontSize: 48)),
                  SizedBox(height: 12),
                  Text(
                    'Belum ada jadwal obat',
                    style: TextStyle(
                      fontSize: 14,
                      color: _tabInactive,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Rutinitas Tab ─────────────────────────────────────────────────────────
  Widget _buildRutinitasTab() {
    return RefreshIndicator(
      color: _green,
      onRefresh: _refresh,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: [
          // Streak card hanya di tab rutinitas
          _buildStreakCard(),
          const SizedBox(height: 16),
          // Section header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Daftar Jadwal Hari Ini',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: _textPrimary,
                  fontFamily: 'Roboto',
                  letterSpacing: -0.45,
                ),
              ),
              Text(
                _hariIni(),
                style: const TextStyle(
                  fontSize: 12,
                  color: _textSecondary,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ..._jadwalList.map(_buildJadwalCard),
        ],
      ),
    );
  }

  // ── Jadwal Card ───────────────────────────────────────────────────────────
  Widget _buildJadwalCard(JadwalRutinitasItem item) {
    final isDone = item.isDone;
    final isLate = item.isTerlewat;

    // Badge warna sesuai Figma
    final Color badgeBg = isDone
        ? const Color(0xFF13EC5B).withOpacity(0.5)
        : isLate
            ? const Color(0xFFEC1E13).withOpacity(0.95)
            : Colors.orange.withOpacity(0.3);

    final String badgeText = isDone
        ? 'Selesai'
        : isLate
            ? 'Terlewat'
            : 'Pending';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _cardBorder, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kiri: nama + waktu + aksi
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.namaAktivitas,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: _textPrimary,
                  fontFamily: 'Roboto',
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.access_time_rounded,
                      size: 12, color: _textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    '${item.jamMulai} - ${item.jamSelesai}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: _textSecondary,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Tombol edit & hapus
              Row(
                children: [
                  _actionButton(
                    icon: Icons.edit_rounded,
                    color: const Color(0xFF0061FF),
                    bg: const Color(0xFFDBEAFE),
                    onTap: () {/* TODO: edit */},
                  ),
                  const SizedBox(width: 6),
                  _actionButton(
                    icon: Icons.delete_rounded,
                    color: const Color(0xFFFF0303),
                    bg: const Color(0xFFFEE2E2),
                    onTap: () {/* TODO: delete */},
                  ),
                ],
              ),
            ],
          ),
          // Kanan: badge status
          Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(9999),
            ),
            alignment: Alignment.center,
            child: Text(
              badgeText,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF10221C),
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Action button (edit / delete) ─────────────────────────────────────────
  Widget _actionButton({
    required IconData icon,
    required Color color,
    required Color bg,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Icon(icon, size: 15, color: color),
      ),
    );
  }

  // ── FAB ───────────────────────────────────────────────────────────────────
  Widget _buildFAB() {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 88,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: () {/* TODO: navigate to TambahJadwal */},
        style: ElevatedButton.styleFrom(
          backgroundColor: _green,
          foregroundColor: _textPrimary,
          elevation: 4,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        icon: const Icon(Icons.add_rounded, size: 22, color: _textPrimary),
        label: const Text(
          'Tambah Rutinitas',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: _textPrimary,
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }
}