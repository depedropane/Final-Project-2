import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/api_service.dart';
import '../../config/app_config.dart';

class RiwayatKonsumsiObatScreen extends StatefulWidget {
  const RiwayatKonsumsiObatScreen({super.key});

  @override
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

  @override
  void initState() {
    super.initState();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgPage,
      body: SafeArea(
        child: Column(
          children: [
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
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────
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
              'Riwayat',
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
}
