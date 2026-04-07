import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/api_service.dart';
import '../../config/app_config.dart';

class RiwayatKonsumsiObatScreen extends StatefulWidget {
  const RiwayatKonsumsiObatScreen({super.key});

  @override
<<<<<<< Updated upstream
  State<RiwayatKonsumsiObatScreen> createState() =>
      _RiwayatKonsumsiObatScreenState();
}

class _RiwayatKonsumsiObatScreenState extends State<RiwayatKonsumsiObatScreen> {
  // ── Warna utama ────────────────────────────────────────────────────────────
  static const Color _bgPage = Color(0xFFF8FAF9);
  static const Color _cyan = Color(0xFF00D4D4);
  static const Color _textPrimary = Color(0xFF0F172A);
  static const Color _textSecondary = Color(0xFF64748B);
  static const Color _cardBg = Color(0xFFF6F8F7);
  static const Color _cardBorder = Color(0xFFF1F5F9);
  // ─────────────────────────────────────────────────────────────────────────

  final ApiService _api = ApiService();
  int? _pasienId;
  String _selectedPeriod = '7 Hari';
  
  // Data dari backend
  double _compliancePercentage = 0.0;
  int _takenDoses = 0;
  int _totalDoses = 0;
  List<Map<String, dynamic>> _trackingData = [];
  bool _isLoading = true;
=======
  State<RiwayatKonsumsiObatScreen> createState() => _RiwayatKonsumsiObatScreenState();
}

class _RiwayatKonsumsiObatScreenState extends State<RiwayatKonsumsiObatScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // KONFIGURASI WARNA
  static const Color _bgPage = Color(0xFFF8FAF9);
  static const Color _streakBg = Color(0xFF10221C);
  static const Color _streakTeal = Color(0xFF13ECA4);
  static const Color _tabActive = Color(0xFF0F172A);
  static const Color _tabInactive = Color(0xFF64748B);
  static const Color _cardBg = Color(0xFFF6F8F7);
  static const Color _cardBorder = Color(0xFFF1F5F9);

  final int _streakHari = 12;

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
>>>>>>> Stashed changes

  @override
  void initState() {
    super.initState();
<<<<<<< Updated upstream
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _pasienId = prefs.getInt(AppConfig.userIdKey);

    if (_pasienId != null) {
      await Future.wait([
        _loadComplianceStats(),
        _loadTrackingData(),
      ]);
    }

    setState(() => _isLoading = false);
  }

  Future<void> _loadComplianceStats() async {
    if (_pasienId == null) return;

    final stats = await _api.getComplianceStats(_pasienId!);
    setState(() {
      _compliancePercentage = (stats['percentage'] as num?)?.toDouble() ?? 0.0;
      _takenDoses = stats['takenDoses'] as int? ?? 0;
      _totalDoses = stats['totalDoses'] as int? ?? 0;
    });
  }

  Future<void> _loadTrackingData() async {
    if (_pasienId == null) return;

    final days = int.parse(_selectedPeriod.split(' ')[0]);
    final endDate = DateTime.now();
    final startDate = endDate.subtract(Duration(days: days));

    final data =
        await _api.getTrackingByDateRange(
          pasienId: _pasienId!,
          startDate: startDate,
          endDate: endDate,
        );

    setState(() => _trackingData = data);
  }

  Future<void> _refreshData() async {
    setState(() => _isLoading = true);
    await _loadData();
=======
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    await SharedPreferences.getInstance();
  }

  Future<void> _refresh() async {
    await _loadData();
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) setState(() {});
  }

  String _hariIni() {
    const hari = ['', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    const bulan = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    final now = DateTime.now();
    return '${hari[now.weekday]}, ${now.day} ${bulan[now.month]}';
>>>>>>> Stashed changes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgPage,
      body: SafeArea(
        child: Column(
          children: [
<<<<<<< Updated upstream
            // ── Header ────────────────────────────────────────────────────
            _buildHeader(),
            // ── Content ───────────────────────────────────────────────────
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: _cyan),
                    )
                  : RefreshIndicator(
                      color: _cyan,
                      onRefresh: _refreshData,
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                        children: [
                          // Compliance Card
                          _buildComplianceCard(),
                          const SizedBox(height: 20),
                          // Period Buttons
                          _buildPeriodButtons(),
                          const SizedBox(height: 24),
                          // Today's Medicines
                          _buildTodayHeader(),
                          const SizedBox(height: 12),
                          if (_trackingData.isEmpty)
                            _buildEmptyState()
                          else
                            ..._trackingData.map(_buildObatItem),
                        ],
                      ),
                    ),
=======
            _header(),
            _tabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _obatTab(),
                  _rutinitasTab(),
                ],
              ),
>>>>>>> Stashed changes
            ),
          ],
        ),
      ),
<<<<<<< Updated upstream
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────
  Widget _buildHeader() {
=======
      floatingActionButton: _fab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _header() {
>>>>>>> Stashed changes
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back),
          ),
          const Expanded(
            child: Text(
<<<<<<< Updated upstream
              'Riwayat',
=======
              'Riwayat Kesehatan',
>>>>>>> Stashed changes
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 24),
        ],
      ),
    );
  }

<<<<<<< Updated upstream
  // ── Compliance Card ─────────────────────────────────────────────────────
  Widget _buildComplianceCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _cardBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Riwayat Tingkat Kepatuhan',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _textSecondary,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Percentage Circle
              SizedBox(
                width: 80,
                height: 80,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: CircularProgressIndicator(
                        value: _compliancePercentage / 100,
                        strokeWidth: 6,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(_cyan),
                        backgroundColor: const Color(0xFFE0F2F1),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${_compliancePercentage.toStringAsFixed(0)}%',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: _cyan,
                            fontFamily: 'Roboto',
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$_totalDoses Dosis',
                          style: const TextStyle(
                            fontSize: 10,
                            color: _textSecondary,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              // Info text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kepatuhan Anda',
                      style: TextStyle(
                        fontSize: 12,
                        color: _textSecondary,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getComplianceMessage(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _textPrimary,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getComplianceMessage() {
    if (_compliancePercentage >= 80) {
      return 'Bagus sekali!';
    } else if (_compliancePercentage >= 60) {
      return 'Cukup baik!';
    } else if (_compliancePercentage >= 40) {
      return 'Perlu ditingkatkan';
    } else {
      return 'Harus lebih baik';
    }
  }

  // ── Period Buttons ──────────────────────────────────────────────────────
  Widget _buildPeriodButtons() {
    final periods = ['3 Hari', '7 Hari', '30 Hari', '3 Bulan'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: periods.map((period) {
        final isSelected = period == _selectedPeriod;
        return GestureDetector(
          onTap: () async {
            setState(() {
              _selectedPeriod = period;
              _isLoading = true;
            });
            await _loadTrackingData();
            setState(() => _isLoading = false);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? _cyan : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? _cyan : _cardBorder,
                width: 1,
              ),
            ),
            child: Text(
              period,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : _textSecondary,
                fontFamily: 'Inter',
=======
  Widget _tabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: _tabActive,
        unselectedLabelColor: _tabInactive,
        indicatorColor: _streakTeal,
        tabs: const [
          Tab(text: 'Obat'),
          Tab(text: 'Rutinitas'),
        ],
      ),
    );
  }

  Widget _obatTab() {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          SizedBox(height: 50),
          Text("Belum ada jadwal obat", textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _rutinitasTab() {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _streakCard(),
          const SizedBox(height: 24),
          Text(_hariIni(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          ..._jadwalList.map((item) => _jadwalCard(item)),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _streakCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _streakBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Streak Kamu", style: TextStyle(color: _streakTeal.withOpacity(0.7))),
              Text(
                "$_streakHari Hari",
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Icon(Icons.local_fire_department, color: _streakTeal, size: 40),
        ],
      ),
    );
  }

  Widget _jadwalCard(JadwalRutinitasItem item) {
    final bool isDone = item.status == 'done';
    final bool isLate = item.status == 'terlewat';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.namaAktivitas, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text("${item.jamMulai} - ${item.jamSelesai}", 
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isDone ? Colors.green.withOpacity(0.1) : isLate ? Colors.red.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isDone ? "Selesai" : isLate ? "Terlewat" : "Pending",
              style: TextStyle(
                fontSize: 12,
                color: isDone ? Colors.green : isLate ? Colors.red : Colors.orange,
>>>>>>> Stashed changes
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Today Header ────────────────────────────────────────────────────────
  Widget _buildTodayHeader() {
    return Text(
      'RIWAYAT ($_selectedPeriod)',
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: _textSecondary,
        letterSpacing: 0.5,
        fontFamily: 'Inter',
      ),
    );
  }

  // ── Empty State ─────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          children: const [
            Text('💊', style: TextStyle(fontSize: 48)),
            SizedBox(height: 12),
            Text(
              'Belum ada riwayat',
              style: TextStyle(
                fontSize: 14,
                color: _textSecondary,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Obat Item ────────────────────────────────────────────────────────────
  Widget _buildObatItem(Map<String, dynamic> tracking) {
    final status = tracking['status'] as String? ?? 'pending';
    final tanggal = tracking['tanggal'] as String? ?? '';
    final waktu = tracking['waktu'] as String? ?? '';
    final jadwalId = tracking['jadwal_id'];

    IconData iconData;
    Color iconColor;

    switch (status.toLowerCase()) {
      case 'taken':
      case 'done':
        iconData = Icons.check_circle;
        iconColor = const Color(0xFF13EC5B);
        break;
      case 'missed':
        iconData = Icons.cancel;
        iconColor = const Color(0xFFEC1E13);
        break;
      case 'pending':
      default:
        iconData = Icons.radio_button_unchecked;
        iconColor = const Color(0xFFCBD5E1);
        break;
    }

    // Parse tanggal
    String displayDate = '';
    try {
      if (tanggal.isNotEmpty) {
        final date = DateTime.parse(tanggal);
        displayDate =
            '${date.day}/${date.month}/${date.year}';
      }
    } catch (_) {
      displayDate = tanggal;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _cardBorder, width: 1),
      ),
      child: Row(
        children: [
          // Icon obat
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: const Text('💊', style: TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 12),
          // Nama & Jam
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jadwal #$jadwalId',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _textPrimary,
                    fontFamily: 'Roboto',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$displayDate $waktu',
                  style: const TextStyle(
                    fontSize: 12,
                    color: _textSecondary,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
          // Status Icon
          Icon(
            iconData,
            size: 24,
            color: iconColor,
          ),
        ],
      ),
    );
  }
<<<<<<< Updated upstream
}
=======

  Widget _fab() {
    return Container(
      width: MediaQuery.of(context).size.width - 80,
      height: 50,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: _tabActive,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          "Unduh Laporan (PDF)", 
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
>>>>>>> Stashed changes
