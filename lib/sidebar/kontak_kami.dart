import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'custom_appbar.dart';

class KontakKamiPage extends StatefulWidget {
  const KontakKamiPage({super.key});

  @override
  State<KontakKamiPage> createState() => _KontakKamiPageState();
}

class _KontakKamiPageState extends State<KontakKamiPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Gagal membuka link")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            SlideTransition(
              position: _slideAnimation,
              child: const CustomAppBar(title: "Kontak Kami"),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Jika ada pertanyaan atau masukan, silakan hubungi kami:",
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 20),

                  _buildContactCard(
                    icon: Icons.email,
                    iconColor: Colors.redAccent,
                    label: "Email",
                    value: "diskominfo@bandaacehkota.go.id",
                    onTap: () async {
                      final Uri emailUri = Uri(
                        scheme: 'mailto',
                        path: 'diskominfo@bandaacehkota.go.id',
                      );
                      await _launchUrl(emailUri);
                    },
                  ),

                  _buildContactCard(
                    icon: Icons.phone,
                    iconColor: Colors.green,
                    label: "WhatsApp",
                    value: "+62 821-6544-5643",
                    onTap: () async {
                      final Uri whatsappUri = Uri.parse(
                        "https://wa.me/6282165445643",
                      );
                      await _launchUrl(whatsappUri);
                    },
                  ),

                  _buildContactCard(
                    icon: Icons.language,
                    iconColor: Colors.blue,
                    label: "Website",
                    value: "cctv.bandaacehkota.go.id",
                    onTap: () async {
                      final Uri url = Uri.parse(
                        "https://cctv.bandaacehkota.go.id",
                      );
                      await _launchUrl(url);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(value, style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
