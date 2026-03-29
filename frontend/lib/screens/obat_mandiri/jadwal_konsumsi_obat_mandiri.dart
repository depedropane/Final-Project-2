import 'package:flutter/material.dart';
import 'tambah_jadwal_konsumsi_obat_mandiri.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Rutinitas Sehat"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),

          // CARD
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(Icons.emoji_events, color: Colors.orange, size: 40),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Strik Kamu!", style: TextStyle(color: Colors.white)),
                    Text("12 Hari",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold))
                  ],
                )
              ],
            ),
          ),

          // LIST
          Expanded(
            child: ListView(
              children: const [
                JadwalItem("Captopril", "06.30 - 07.00"),
                JadwalItem("Atorvastatin", "12.00 - 13.00"),
                JadwalItem("Vitamin D", "18.00 - 19.00"),
              ],
            ),
          ),

          // BUTTON
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const TambahJadwalKonsumsi()),
                );
              },
              child: const Text("Tambah Rutinitas"),
            ),
          )
        ],
      ),
    );
  }
}

class JadwalItem extends StatelessWidget {
  final String nama;
  final String waktu;

  const JadwalItem(this.nama, this.waktu, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(nama),
        subtitle: Text(waktu),
        trailing: const Icon(Icons.check, color: Colors.green),
      ),
    );
  }
}