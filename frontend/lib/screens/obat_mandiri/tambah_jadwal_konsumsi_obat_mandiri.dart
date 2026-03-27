import 'package:flutter/material.dart';

class TambahJadwalPage extends StatefulWidget {
  const TambahJadwalPage({Key? key}) : super(key: key);

  @override
  State<TambahJadwalPage> createState() => _TambahJadwalPageState();
}

class _TambahJadwalPageState extends State<TambahJadwalPage>
    with SingleTickerProviderStateMixin {

  late TabController _tabController;

  final TextEditingController namaController = TextEditingController();
  final TextEditingController targetController = TextEditingController();

  List<String> selectedTimes = [];

  String selectedFrekuensi = "Setiap Hari";
  String selectedDurasi = "7 Hari";

  final List<String> waktuList = ["Pagi", "Siang", "Sore", "Malam"];

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = 1; // default ke Rutinitas
    super.initState();
  }

  void toggleWaktu(String waktu) {
    setState(() {
      if (selectedTimes.contains(waktu)) {
        selectedTimes.remove(waktu);
      } else {
        selectedTimes.add(waktu);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Tambah Jadwal",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xff22C55E),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xff22C55E),
          tabs: const [
            Tab(text: "Obat"),
            Tab(text: "Rutinitas"),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 20),

            /// Nama Rutinitas
            const Text("Nama Rutinitas"),
            const SizedBox(height: 8),
            _buildInputField(
              controller: namaController,
              hint: "Contoh: Minum Air",
            ),

            const SizedBox(height: 20),

            /// Target
            const Text("Target"),
            const SizedBox(height: 8),
            _buildInputField(
              controller: targetController,
              hint: "Contoh: 2 Liter",
            ),

            const SizedBox(height: 20),

            /// Waktu Pengingat
            const Text("Waktu Pengingat"),
            const SizedBox(height: 10),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: waktuList.map((waktu) {
                final isSelected = selectedTimes.contains(waktu);

                return GestureDetector(
                  onTap: () => toggleWaktu(waktu),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 20),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xffDCFCE7)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xff22C55E)
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Text(
                      waktu,
                      style: TextStyle(
                        color: isSelected
                            ? const Color(0xff16A34A)
                            : Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            /// Frekuensi & Durasi
            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    label: "Frekuensi",
                    value: selectedFrekuensi,
                    items: const [
                      "Setiap Hari",
                      "Senin-Jumat",
                      "3x Seminggu"
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedFrekuensi = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildDropdown(
                    label: "Durasi",
                    value: selectedDurasi,
                    items: const [
                      "7 Hari",
                      "30 Hari",
                      "90 Hari"
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedDurasi = value!;
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            /// Button Simpan
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff22C55E),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  print("Nama: ${namaController.text}");
                  print("Target: ${targetController.text}");
                  print("Waktu: $selectedTimes");
                  print("Frekuensi: $selectedFrekuensi");
                  print("Durasi: $selectedDurasi");
                },
                child: const Text(
                  "Simpan Jadwal",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            items: items
                .map((item) => DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    ))
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}