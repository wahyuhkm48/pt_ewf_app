import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String _selectedLanguage = 'id';

  final List<_LanguageOption> _languages = [
    _LanguageOption(
      code: 'id',
      flag: '🇮🇩',
      name: 'Bahasa Indonesia',
      subtitle: 'Bahasa default aplikasi',
    ),
    _LanguageOption(
      code: 'en',
      flag: '🇬🇧',
      name: 'English',
      subtitle: 'Use English language',
    ),
    _LanguageOption(
      code: 'zh',
      flag: '🇨🇳',
      name: '中文',
      subtitle: '使用简体中文',
    ),
    _LanguageOption(
      code: 'ms',
      flag: '🇲🇾',
      name: 'Bahasa Melayu',
      subtitle: 'Gunakan Bahasa Melayu',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),

      appBar: AppBar(
        title: const Text('Bahasa'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
      ),

      // ================= BODY =================
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ================= HEADER =================
                    const Text(
                      'Pilih Bahasa',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1F2937),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      'Pilih bahasa yang ingin kamu gunakan di aplikasi.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ================= LANGUAGE LIST =================
                    ..._languages.map(
                      (language) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _LanguageTile(
                          option: language,
                          selected: _selectedLanguage == language.code,
                          onTap: () {
                            setState(() {
                              _selectedLanguage = language.code;
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ================= ILLUSTRATION =================
                    const Center(
                      child: _GlobeIllustration(),
                    ),

                    const SizedBox(height: 16),

                    Center(
                      child: Text(
                        'Perubahan bahasa akan diterapkan ke seluruh aplikasi.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ================= SAVE BUTTON =================
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Color(0xFFE5E7EB),
                    width: 1,
                  ),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF7A00),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Simpan Perubahan',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// LANGUAGE OPTION
// ======================================================

class _LanguageOption {
  final String code;
  final String flag;
  final String name;
  final String subtitle;

  _LanguageOption({
    required this.code,
    required this.flag,
    required this.name,
    required this.subtitle,
  });
}

// ======================================================
// LANGUAGE TILE
// ======================================================

class _LanguageTile extends StatelessWidget {
  final _LanguageOption option;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 15,
          ),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFFFFF4EA)
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected
                  ? const Color(0xFFFF7A00)
                  : const Color(0xFFE5E7EB),
              width: selected ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha:0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // FLAG
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected
                      ? Colors.white
                      : const Color(0xFFF5F6F8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  option.flag,
                  style: const TextStyle(fontSize: 25),
                ),
              ),

              const SizedBox(width: 14),

              // NAME + SUBTITLE
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      option.subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // CHECK
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected
                      ? const Color(0xFFFF7A00)
                      : Colors.transparent,
                  border: Border.all(
                    color: selected
                        ? const Color(0xFFFF7A00)
                        : const Color(0xFFD1D5DB),
                    width: 2,
                  ),
                ),
                child: selected
                    ? const Icon(
                        Icons.check,
                        size: 14,
                        color: Colors.white,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ======================================================
// GLOBE ILLUSTRATION
// ======================================================

class _GlobeIllustration extends StatelessWidget {
  const _GlobeIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // GLOBE
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Color(0xFF64C7F0),
                  Color(0xFF4389D8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(
              Icons.public,
              color: Colors.white,
              size: 58,
            ),
          ),

          // ID
          Positioned(
            left: 5,
            top: 8,
            child: _LanguageBubble(
              text: 'ID',
              color: Color(0xFFFF7A00),
            ),
          ),

          // EN
          Positioned(
            right: 5,
            bottom: 8,
            child: _LanguageBubble(
              text: 'EN',
              color: Color(0xFF4389D8),
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================
// LANGUAGE BUBBLE
// ======================================================

class _LanguageBubble extends StatelessWidget {
  final String text;
  final Color color;

  const _LanguageBubble({
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.12),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}