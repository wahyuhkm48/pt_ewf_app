// views/register_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../widgets/password_field.dart';
import 'login_page.dart';
import 'main_shell.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final namaCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  String? _localError;

  @override
  void dispose() {
    namaCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit(AuthViewModel vm) async {
    setState(() => _localError = null);

    if (namaCtrl.text.trim().isEmpty || emailCtrl.text.trim().isEmpty || passCtrl.text.isEmpty) {
      setState(() => _localError = 'Semua field wajib diisi');
      return;
    }
    if (passCtrl.text.length < 8) {
      setState(() => _localError = 'Password minimal 8 karakter');
      return;
    }
    if (passCtrl.text != confirmCtrl.text) {
      setState(() => _localError = 'Konfirmasi password tidak sama');
      return;
    }

    final sukses = await vm.register(
      namaLengkap: namaCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      password: passCtrl.text,
    );

    if (sukses && mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainShell()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();
    final errorText = _localError ?? vm.errorMessage;

    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Stack(
            children: [
              Positioned(
                top: -40, left: -60,
                child: Container(width: 220, height: 220, decoration: const BoxDecoration(color: AppColors.primarySoft, shape: BoxShape.circle)),
              ),
              Positioned(
                top: 30, left: 150,
                child: Container(width: 44, height: 44, decoration: const BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle)),
              ),
              Positioned(
                bottom: -40, right: -50,
                child: Container(width: 140, height: 140, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
              ),
              Positioned(
                bottom: 40, right: 70,
                child: Container(width: 50, height: 50, decoration: const BoxDecoration(color: AppColors.secondarySoft, shape: BoxShape.circle)),
              ),

              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    const SizedBox(height: 150),
                    const Text('Sign Up', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    const SizedBox(height: 6),
                    const Text('Create an account', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                    const SizedBox(height: 32),

                    TextField(
                      controller: namaCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        labelStyle: TextStyle(color: AppColors.textSecondary),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.divider)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
                      ),
                    ),
                    const SizedBox(height: 20),

                    TextField(
                      controller: emailCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: AppColors.textSecondary),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.divider)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
                      ),
                    ),
                    const SizedBox(height: 20),

                    PasswordField(controller: passCtrl),
                    const SizedBox(height: 20),

                    PasswordField(controller: confirmCtrl, label: 'Confirm Password'),

                    if (errorText != null) ...[
                      const SizedBox(height: 12),
                      Text(errorText, style: const TextStyle(color: AppColors.danger)),
                    ],

                    const SizedBox(height: 40),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: vm.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.secondary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                elevation: 0,
                              ),
                              onPressed: () => _submit(vm),
                              child: const Text('Sign Up', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            ),
                    ),
                    const SizedBox(height: 16),

                    GestureDetector(
                      onTap: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      ),
                      child: RichText(
                        text: const TextSpan(
                          text: 'Already have an account? ',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                          children: [
                            TextSpan(text: 'Login', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}