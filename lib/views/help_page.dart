import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // BAGIAN ATAS PUTIH
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ada yang bisa kami bantu?',
                    style: TextStyle(
                      color: Color(0xFF1E2A47),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Temukan jawaban dan informasi seputar aplikasi.',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            // BAGIAN BAWAH PUTIH
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const _HelpTile(
                      title: 'Bagaimana cara menggunakan kalkulator?',
                      icon: Icons.calculate_outlined,
                      answer: 'Buka menu Kalkulator dari halaman utama, lalu masukkan angka yang ingin dihitung sesuai fitur yang tersedia.',
                    ),

                    const SizedBox(height: 12),

                    const _HelpTile(
                      title: 'Bagaimana cara melihat riwayat perhitungan?',
                      icon: Icons.history_rounded,
                      answer: 'Riwayat perhitungan bisa dilihat di menu History yang ada di halaman utama aplikasi.',
                    ),

                    const SizedBox(height: 12),

                    const _HelpTile(
                      title: 'Bagaimana cara menggunakan Pivot Points?',
                      icon: Icons.analytics_outlined,
                      answer: 'Pivot Points digunakan untuk menganalisis titik support dan resistance harga. Buka menu Chart untuk melihat fitur ini.',
                    ),

                    const SizedBox(height: 12),

                    const _HelpTile(
                      title: 'Bagaimana cara mengubah informasi akun saya?',
                      icon: Icons.person_outline_rounded,
                      answer: 'Buka menu Settings, lalu pilih Account Information untuk mengubah nama, email, atau nomor telepon kamu.',
                    ),

                    const SizedBox(height: 12),

                    const _HelpTile(
                      title: 'Bagaimana cara mengubah bahasa aplikasi?',
                      icon: Icons.language_rounded,
                      answer: 'Buka menu Settings, lalu pilih Language dan pilih bahasa yang kamu inginkan.',
                    ),

                    const SizedBox(height: 28),

                    // CONTACT SUPPORT
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCEBFF),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFE5C2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.support_agent_rounded,
                              color: Color(0xFFFF8A00),
                            ),
                          ),

                          const SizedBox(width: 14),

                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Masih butuh bantuan?',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E2A47),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Hubungi tim support kami untuk bantuan lebih lanjut.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                            color: Color(0xFF138EEC),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HelpTile extends StatefulWidget {
  final String title;
  final IconData icon;
  final String answer;

  const _HelpTile({
    required this.title,
    required this.icon,
    required this.answer,
  });

  @override
  State<_HelpTile> createState() => _HelpTileState();
}

class _HelpTileState extends State<_HelpTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFDCEBFF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  Icon(widget.icon, color: const Color(0xFFFF8A00), size: 22),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        color: Color(0xFF1E2A47),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity, height: 0),
            secondChild: Padding(
              padding: const EdgeInsets.only(bottom: 14, right: 4),
              child: Text(
                widget.answer,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ),
            crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}