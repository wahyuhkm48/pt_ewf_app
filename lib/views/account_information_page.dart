// views/account_information_page.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../widgets/avatar_ring.dart';

class AccountInformationPage extends StatefulWidget {
  const AccountInformationPage({super.key});

  @override
  State<AccountInformationPage> createState() => _AccountInformationPageState();
}

class _AccountInformationPageState extends State<AccountInformationPage> {
  bool _uploadingFoto = false;

  static const _months = ['Jan','Feb','Mar','Apr','Mei','Jun','Jul','Agu','Sep','Okt','Nov','Des'];

  String _formatJoinDate(DateTime? date) {
    if (date == null) return '-';
    return '${date.day} ${_months[date.month - 1]} ${date.year}';
  }

  Future<void> _editFullName(AuthViewModel auth) async {
    final controller = TextEditingController(text: auth.employee?.namaLengkap ?? '');
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Full Name'),
        content: TextField(controller: controller, autofocus: true),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, controller.text), child: const Text('Save')),
        ],
      ),
    );

    if (result != null && result.trim().isNotEmpty && mounted) {
      final ok = await auth.updateProfile(namaLengkap: result.trim());
      if (!ok && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(auth.errorMessage ?? 'Gagal menyimpan nama')),
        );
      }
    }
  }

  Future<void> _editPhoneNumber(AuthViewModel auth) async {
    final controller = TextEditingController(text: auth.employee?.noTelp ?? '');
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Phone Number'),
        content: TextField(controller: controller, autofocus: true, keyboardType: TextInputType.phone),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, controller.text), child: const Text('Save')),
        ],
      ),
    );

    if (result != null && result.trim().isNotEmpty && mounted) {
      final ok = await auth.updateProfile(noTelp: result.trim());
      if (!ok && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(auth.errorMessage ?? 'Gagal menyimpan nomor telepon')),
        );
      }
    }
  }

  Future<void> _pilihFoto(AuthViewModel auth) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80, maxWidth: 800);
    if (picked == null) return;

    setState(() => _uploadingFoto = true);
    try {
      final bytes = await picked.readAsBytes();
      final ok = await auth.updateFoto(bytes, picked.name);
      if (!ok && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(auth.errorMessage ?? 'Gagal upload foto')),
        );
      }
    } finally {
      if (mounted) setState(() => _uploadingFoto = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    final employee = auth.employee;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Information'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Stack(
              children: [
                AvatarRing(size: 110, fotoUrl: employee?.foto, nama: employee?.namaLengkap),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _uploadingFoto ? null : () => _pilihFoto(auth),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(color: Colors.black87, shape: BoxShape.circle),
                      child: _uploadingFoto
                          ? const SizedBox(
                              width: 18, height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _InfoField(
              label: 'Full Name',
              value: employee?.namaLengkap ?? '-',
              editable: true,
              onEdit: () => _editFullName(auth),
            ),
            const SizedBox(height: 12),
            _InfoField(label: 'Email', value: employee?.email ?? '-', editable: false),
            const SizedBox(height: 12),
            _InfoField(
              label: 'Phone Number',
              value: (employee?.noTelp?.isNotEmpty ?? false) ? employee!.noTelp! : '-',
              editable: true,
              onEdit: () => _editPhoneNumber(auth),
            ),
            const SizedBox(height: 12),
            _InfoField(label: 'Join Date', value: _formatJoinDate(employee?.createdAt), editable: false),
          ],
        ),
      ),
    );
  }
}

class _InfoField extends StatelessWidget {
  final String label;
  final String value;
  final bool editable;
  final VoidCallback? onEdit;

  const _InfoField({required this.label, required this.value, this.editable = false, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: editable ? onEdit : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.divider),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    const SizedBox(height: 4),
                    Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  ],
                ),
              ),
              if (editable) const Icon(Icons.edit, color: AppColors.primary, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}