import 'package:flutter/material.dart';
import 'custom_appbar.dart';

class TentangKamiPage extends StatelessWidget {
  const TentangKamiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CustomAppBar(title: "Tentang Kami"),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    "Proyek ini merupakan hasil kolaborasi antara Diskominfotik Kota Banda Aceh dan mahasiswa Prodi Sistem Informasi Universitas Abulyatama. Tujuannya adalah membangun sistem pemantauan CCTV yang terintegrasi untuk mendukung keamanan kota, transparansi publik, dan pengelolaan lalu lintas secara real-time.",
                    style: TextStyle(fontSize: 16, height: 1.5),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Divider(color: Colors.grey[400], thickness: 1),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Icon(Icons.security, color: Colors.blue),
                      ),
                      Expanded(
                        child: Divider(color: Colors.grey[400], thickness: 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  _buildGoalCard(
                    icon: Icons.dashboard,
                    iconColor: Colors.purple,
                    text:
                        "Mengembangkan dashboard CCTV yang terhubung dengan titik-titik strategis di Banda Aceh",
                  ),
                  _buildGoalCard(
                    icon: Icons.flash_on,
                    iconColor: Colors.blue,
                    text:
                        "Memberikan akses informasi yang cepat bagi instansi terkait",
                  ),
                  _buildGoalCard(
                    icon: Icons.shield,
                    iconColor: Colors.green,
                    text:
                        "Meningkatkan rasa aman bagi masyarakat melalui teknologi",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalCard({
    required IconData icon,
    required Color iconColor,
    required String text,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
