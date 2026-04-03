import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import '../models/jadwal_obat_model.dart';
import '../config/app_config.dart';
import './rutinitas_mandiri/jadwal_rutinitas_screen.dart';
import 'login_screen.dart';
import 'package:nauli_reminder/screens/obat_mandiri/riwayat_konsumsi_obat.dart';
import 'package:nauli_reminder/screens/obat_mandiri/info_obat.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedNav = 0;
  bool _isWeekView = true;
  DateTime _selectedDate = DateTime.now();
  final DateTime _focusedMonth = DateTime.now();

  final ApiService _api = ApiService();
  List<JadwalObatItem> _jadwalList = [];
  bool _isLoadingJadwal = true;
  int? _pasienId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _pasienId = prefs.getInt(AppConfig.userIdKey);

    if (_pasienId != null) {
      final data = await _api.getJadwalObatHariIni(_pasienId!);
      setState(() {
        _jadwalList = data;
        _isLoadingJadwal = false;
      });
    } else {
      setState(() => _isLoadingJadwal = false);
    }
  }

  Future<void> _toggleStatus(JadwalObatItem item) async {
    if (_pasienId == null) return;

    final newStatus = item.isDone ? 'pending' : 'done';
    final success = await _api.updateStatusTracking(
      jadwalObatId: item.jadwalObatId,
      pasienId: _pasienId!,
      nakesId: 1,
      status: newStatus,
    );

    if (success) {
      setState(() => item.status = newStatus);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.currentUser;
    final nama = user?.nama ?? 'Pengguna';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(nama),
                Expanded(
                  child: RefreshIndicator(
                    color: const Color(0xFF15BE77),
                    onRefresh: _loadData,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          _buildMenuUtama(),
                          const SizedBox(height: 20),
                          _buildKalender(),
                          const SizedBox(height: 16),
                          _buildJadwalSection(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: _buildBottomNav(context, auth),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ───────────────────────────────────────────────────────────────────
  Widget _buildHeader(String nama) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      color: const Color(0xFFE8F5F3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Selamat Pagi,',
                  style: TextStyle(fontSize: 13, color: Color(0xFF15BE77))),
              Row(
                children: [
                  Text(nama,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A))),
                  const SizedBox(width: 4),
                  const Text('👋', style: TextStyle(fontSize: 18)),
                ],
              ),
            ],
          ),
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
                color: Color(0xFFFFF9C4), shape: BoxShape.circle),
            child: const Icon(Icons.notifications_outlined,
                color: Color(0xFFFFB300), size: 22),
          ),
        ],
      ),
    );
  }

  // ── Menu Utama ───────────────────────────────────────────────────────────────
  Widget _buildMenuUtama() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Menu Utama',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                  child: _menuCard(
                      icon: Icons.alarm,
                      iconColor: const Color(0xFFE53935),
                      bgColor: const Color(0xFFFFF3F3),
                      title: 'Reminder & Alarm',
                      subtitle: 'Kelola Pengingat')),
              const SizedBox(width: 12),
              Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const InfoObatScreen(),
                      ),
                    ),
                    child: _menuCard(
                        icon: Icons.medical_information_outlined,
                        iconColor: const Color(0xFFFFB300),
                        bgColor: const Color(0xFFFFFDE7),
                        title: 'Info Obat',
                        subtitle: 'Detail & Panduan'),
                  )),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          RiwayatKonsumsiObatScreen(pasienId: _pasienId ?? 1),
                    ),
                  ),
                  child: _menuCard(
                      icon: Icons.bar_chart_rounded,
                      iconColor: const Color(0xFF1565C0),
                      bgColor: const Color(0xFFE3F2FD),
                      title: 'Riwayat',
                      subtitle: 'Kepatuhan Minum'),
                ),
              ),
              const SizedBox(width: 12),
              // ✅ DIPERBAIKI: mengarah ke RutinitasSehatScreen
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RutinitasSehatScreen(),
                      ),
                    );
                  },
                  child: _menuCard(
                    icon: Icons.fitness_center,
                    iconColor: const Color(0xFFE91E8C),
                    bgColor: const Color(0xFFFCE4EC),
                    title: 'Rutinitas Sehat',
                    subtitle: 'Jadwal Aktivitas',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _menuCard({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: bgColor, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 10),
          Text(title,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A))),
          const SizedBox(height: 2),
          Text(subtitle,
              style: TextStyle(fontSize: 11, color: Colors.grey[500])),
        ],
      ),
    );
  }

  // ── Kalender ─────────────────────────────────────────────────────────────────
  Widget _buildKalender() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_bulanTahun(_focusedMonth),
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold)),
              Container(
                decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    _toggleBtn('Minggu', _isWeekView,
                        () => setState(() => _isWeekView = true)),
                    _toggleBtn('Bulan', !_isWeekView,
                        () => setState(() => _isWeekView = false)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min']
                .map((d) => SizedBox(
                      width: 32,
                      child: Text(d,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w500)),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),
          _isWeekView ? _buildWeekRow() : _buildMonthGrid(),
        ],
      ),
    );
  }

  Widget _toggleBtn(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          boxShadow: active
              ? [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 1))
                ]
              : [],
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 12,
                fontWeight: active ? FontWeight.w600 : FontWeight.normal,
                color: active ? const Color(0xFF1A1A1A) : Colors.grey[500])),
      ),
    );
  }

  Widget _buildWeekRow() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: (now.weekday - 1) % 7));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(7, (i) {
        final day = weekStart.add(Duration(days: i));
        final isSelected =
            day.day == _selectedDate.day && day.month == _selectedDate.month;
        final isToday = day.day == now.day && day.month == now.month;
        return GestureDetector(
            onTap: () => setState(() => _selectedDate = day),
            child: _dayCell(day.day, isSelected, isToday));
      }),
    );
  }

  Widget _buildMonthGrid() {
    final firstDay = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final daysInMonth =
        DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0).day;
    final startOffset = (firstDay.weekday - 1) % 7;
    final now = DateTime.now();

    final cells = <Widget>[];
    for (int i = 0; i < startOffset; i++) {
      cells.add(const SizedBox(width: 32, height: 36));
    }
    for (int d = 1; d <= daysInMonth; d++) {
      final isSelected =
          d == _selectedDate.day && _focusedMonth.month == _selectedDate.month;
      final isToday = d == now.day &&
          _focusedMonth.month == now.month &&
          _focusedMonth.year == now.year;
      cells.add(GestureDetector(
          onTap: () => setState(() => _selectedDate =
              DateTime(_focusedMonth.year, _focusedMonth.month, d)),
          child: _dayCell(d, isSelected, isToday)));
    }

    final rows = <Widget>[];
    for (int i = 0; i < cells.length; i += 7) {
      final rowCells =
          cells.sublist(i, i + 7 > cells.length ? cells.length : i + 7);
      while (rowCells.length < 7) {
        rowCells.add(const SizedBox(width: 32, height: 36));
      }
      rows.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: rowCells));
      if (i + 7 < cells.length) rows.add(const SizedBox(height: 4));
    }
    return Column(children: rows);
  }

  Widget _dayCell(int day, bool isSelected, bool isToday) {
    return Container(
      width: 32,
      height: 36,
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF15BE77) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('$day',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected || isToday
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: isSelected
                      ? Colors.white
                      : isToday
                          ? const Color(0xFF15BE77)
                          : const Color(0xFF333333))),
          if (isToday && !isSelected)
            Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                    color: Color(0xFF15BE77), shape: BoxShape.circle)),
        ],
      ),
    );
  }

  String _bulanTahun(DateTime dt) {
    const bulan = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return '${bulan[dt.month]} ${dt.year}';
  }

  // ── Jadwal Obat dari API ──────────────────────────────────────────────────────
  Widget _buildJadwalSection() {
    if (_isLoadingJadwal) {
      return const Center(
          child: Padding(
        padding: EdgeInsets.all(32),
        child: CircularProgressIndicator(color: Color(0xFF15BE77)),
      ));
    }

    if (_jadwalList.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Center(
          child: Text('Tidak ada jadwal obat hari ini',
              style: TextStyle(color: Colors.grey[500], fontSize: 14)),
        ),
      );
    }

    return Column(
      children: _jadwalList.map((item) => _buildJadwalCard(item)).toList(),
    );
  }

  Widget _buildJadwalCard(JadwalObatItem item) {
    final jamParts = item.jamMinum.split(':');
    final jadwalDt = DateTime.now().copyWith(
      hour: int.tryParse(jamParts.isNotEmpty ? jamParts[0] : '0') ?? 0,
      minute: int.tryParse(jamParts.length > 1 ? jamParts[1] : '0') ?? 0,
    );
    final isLate = jadwalDt.isBefore(DateTime.now()) && !item.isDone;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isLate ? const Color(0xFFFFF3F3) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: isLate
            ? Border.all(color: const Color(0xFFFFCDD2), width: 1.5)
            : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 52,
            child: Text(
              item.jamMinum.substring(0, 5),
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isLate
                      ? const Color(0xFFE53935)
                      : const Color(0xFF1A1A1A)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.dosis,
                    style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                            color: Color(0xFF9C27B0), shape: BoxShape.circle)),
                    const SizedBox(width: 4),
                    Text(item.namaObat,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _toggleStatus(item),
            child: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: item.isDone ? const Color(0xFF15BE77) : Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color:
                      item.isDone ? const Color(0xFF15BE77) : Colors.grey[300]!,
                  width: 1.5,
                ),
              ),
              child: item.isDone
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  // ── Bottom Nav ───────────────────────────────────────────────────────────────
  Widget _buildBottomNav(BuildContext context, AuthProvider auth) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.home_rounded, 0),
          _navItem(Icons.list_alt_rounded, 1),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFF15BE77),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: Color(0x4015BE77),
                      blurRadius: 12,
                      offset: Offset(0, 4))
                ],
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            ),
          ),
          // ✅ DIPERBAIKI: mengarah ke RutinitasSehatScreen
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const RutinitasSehatScreen(),
                ),
              );
            },
            child: Icon(
              Icons.directions_run_rounded,
              color: _selectedNav == 2
                  ? const Color(0xFF15BE77)
                  : Colors.grey[400],
              size: 26,
            ),
          ),
          GestureDetector(
            onTap: () async {
              await auth.logout();
              if (context.mounted) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()));
              }
            },
            child: Icon(Icons.settings_outlined,
                color: _selectedNav == 3
                    ? const Color(0xFF15BE77)
                    : Colors.grey[400],
                size: 26),
          ),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, int index) {
    return GestureDetector(
      onTap: () => setState(() => _selectedNav = index),
      child: Icon(icon,
          color: _selectedNav == index
              ? const Color(0xFF15BE77)
              : Colors.grey[400],
          size: 26),
    );
  }
}
