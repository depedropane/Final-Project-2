import 'package:flutter/material.dart';
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
      pengulangan: ['Sen', 'Sel', 'Rab'],
      status: 'done',
    ),
  ];

  int _streakHari = 12;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            _streak(),
            _tabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  const Center(child: Text("Obat")),
                  _rutinitasTab(),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: _fab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // ================= HEADER =================
  Widget _header() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: const Center(
        child: Text(
          "Rutinitas Sehat",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // ================= STREAK =================
  Widget _streak() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF16A34A), Color(0xFF22C55E)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("🔥 Streak Kamu",
              style: TextStyle(color: Colors.white)),
          Text("$_streakHari Hari",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // ================= TAB =================
  Widget _tabBar() {
    return TabBar(
      controller: _tabController,
      labelColor: Colors.green,
      unselectedLabelColor: Colors.grey,
      tabs: const [
        Tab(text: "Obat"),
        Tab(text: "Rutinitas"),
      ],
    );
  }

  // ================= LIST =================
  Widget _rutinitasTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 120),
      children: _jadwalList.map(_card).toList(),
    );
  }

  // ================= CARD =================
  Widget _card(JadwalRutinitasItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.namaAktivitas,
                  style: const TextStyle(fontWeight: FontWeight.bold)),

              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _edit(item),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _hapus(item),
                  ),
                ],
              )
            ],
          ),

          Text("${item.jamMulai} - ${item.jamSelesai}"),

          const SizedBox(height: 6),

          _status(item),
        ],
      ),
    );
  }

  // ================= STATUS =================
  Widget _status(JadwalRutinitasItem item) {
    Color warna;
    String text;

    if (item.isDone) {
      warna = Colors.green;
      text = "Selesai";
    } else if (item.isTerlewat) {
      warna = Colors.red;
      text = "Terlewat";
    } else {
      warna = Colors.orange;
      text = "Pending";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: warna.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: TextStyle(color: warna)),
    );
  }

  // ================= TAMBAH =================
  Widget _fab() {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 40,
      height: 55,
      child: ElevatedButton(
        onPressed: _tambah,
        child: const Text("+ Tambah Rutinitas"),
      ),
    );
  }

  // ================= FUNCTION =================

  void _hapus(JadwalRutinitasItem item) {
    setState(() => _jadwalList.remove(item));
  }

  void _tambah() {
    final nama = TextEditingController();
    final mulai = TextEditingController();
    final selesai = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Tambah"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nama),
            TextField(controller: mulai),
            TextField(controller: selesai),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _jadwalList.add(JadwalRutinitasItem(
                  jadwalRutinitasId: DateTime.now().millisecondsSinceEpoch,
                  namaAktivitas: nama.text,
                  jamMulai: mulai.text,
                  jamSelesai: selesai.text,
                  pengulangan: [],
                  status: 'pending',
                ));
              });
              Navigator.pop(context);
            },
            child: const Text("Simpan"),
          )
        ],
      ),
    );
  }

  void _edit(JadwalRutinitasItem item) {
    final nama = TextEditingController(text: item.namaAktivitas);
    final mulai = TextEditingController(text: item.jamMulai);
    final selesai = TextEditingController(text: item.jamSelesai);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nama),
            TextField(controller: mulai),
            TextField(controller: selesai),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                item.namaAktivitas = nama.text;
                item.jamMulai = mulai.text;
                item.jamSelesai = selesai.text;
              });
              Navigator.pop(context);
            },
            child: const Text("Update"),
          )
        ],
      ),
    );
  }
}