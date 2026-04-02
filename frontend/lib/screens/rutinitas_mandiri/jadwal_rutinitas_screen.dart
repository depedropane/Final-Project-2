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
      namaAktivitas: 'Makan malam',
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
    const hari = [
      '',
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu'
    ];
    const bulan = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des'
    ];
    final now = DateTime.now();
    return '${hari[now.weekday]}, ${now.day} ${bulan[now.month]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildStreakCard(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  const Center(child: Text('Tab Obat')),
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
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(Icons.chevron_left_rounded),
            ),
          ),
          const Expanded(
            child: Text(
              'Rutinitas Sehat',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 36),
        ],
      ),
    );
  }

  Widget _buildStreakCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0f3d2e), Color(0xFF14532d)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("🏆 STREAK KAMU!",
              style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 6),
          Text(
            "$_streakHari Hari",
            style: const TextStyle(
                fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      labelColor: const Color(0xFF16A34A),
      unselectedLabelColor: Colors.grey,
      indicatorColor: const Color(0xFF22C55E),
      tabs: const [
        Tab(text: 'Obat'),
        Tab(text: 'Rutinitas'),
      ],
    );
  }

  Widget _buildRutinitasTab() {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 120),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Daftar Jadwal Hari Ini',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(_hariIni(), style: const TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 10),
          ..._jadwalList.map(_buildJadwalCard),
        ],
      ),
    );
  }

  Widget _buildJadwalCard(JadwalRutinitasItem item) {
    final isDone = item.isDone;
    final isLate = item.isTerlewat;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(item.namaAktivitas,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('${item.jamMulai} - ${item.jamSelesai}',
                style: TextStyle(color: Colors.grey[500])),
          ]),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isDone
                  ? Colors.green.shade100
                  : isLate
                      ? Colors.red.shade100
                      : Colors.orange.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isDone
                  ? "Selesai"
                  : isLate
                      ? "Terlewat"
                      : "Pending",
              style: TextStyle(
                color: isDone
                    ? Colors.green
                    : isLate
                        ? Colors.red
                        : Colors.orange,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAB() {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 40,
      height: 55,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF22C55E),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: const Text("+ Tambah Rutinitas"),
      ),
    );
  }
}
