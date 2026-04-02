import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './tambah_jadwal_konsumsi_obat_mandiri.dart';


class JadwalKonsumsiObatMandiri extends StatefulWidget {
  const JadwalKonsumsiObatMandiri({super.key});

  @override
  State<JadwalKonsumsiObatMandiri> createState() =>
      _JadwalKonsumsiObatMandiriState();
}

class _JadwalKonsumsiObatMandiriState
    extends State<JadwalKonsumsiObatMandiri> {
  List<dynamic> jadwalList = [];
  bool isLoading = true;

  // 🔥 GANTI BASE URL
  final String baseUrl = "http://10.0.2.2:8080/jadwal";

  @override
  void initState() {
    super.initState();
    fetchJadwal();
  }

  // ================= GET =================
  Future<void> fetchJadwal() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          jadwalList = data['data'];
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() => isLoading = false);
    }
  }

  // ================= DELETE =================
  Future<void> deleteJadwal(int id) async {
    try {
      final response =
          await http.delete(Uri.parse("$baseUrl/$id"));

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Jadwal berhasil dihapus")),
        );
        fetchJadwal(); // refresh
      }
    } catch (e) {
      print(e);
    }
  }

  // ================= UI =================
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
                Icon(Icons.emoji_events,
                    color: Colors.orange, size: 40),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Strik Kamu!",
                        style: TextStyle(color: Colors.white)),
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

          // ================= LIST =================
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : jadwalList.isEmpty
                    ? const Center(child: Text("Belum ada jadwal"))
                    : ListView.builder(
                        itemCount: jadwalList.length,
                        itemBuilder: (context, index) {
                          final item = jadwalList[index];

                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: ListTile(
                              title:
                                  Text(item['nama_jadwal'] ?? '-'),
                              subtitle:
                                  Text(item['dosis'] ?? '-'),

                              // 🔥 BUTTON EDIT + DELETE
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // EDIT
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.blue),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              TambahJadwalKonsumsi(
                                            data: item,
                                          ),
                                        ),
                                      ).then((_) => fetchJadwal());
                                    },
                                  ),

                                  // DELETE
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title: const Text("Hapus"),
                                          content: const Text(
                                              "Yakin ingin menghapus jadwal ini?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text("Batal"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                deleteJadwal(
                                                    item['jadwal_id']);
                                              },
                                              child: const Text("Hapus"),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),

          // ================= BUTTON TAMBAH =================
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize:
                    const Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const TambahJadwalKonsumsi(),
                  ),
                ).then((_) => fetchJadwal());
              },
              child: const Text("Tambah Rutinitas"),
            ),
          )
        ],
      ),
    );
  }
}