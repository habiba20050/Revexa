
import 'package:dio/dio.dart';
import 'package:revexa/shared/extensions/context_extensions.dart';
import 'package:revexa/shared/widgets/app_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:revexa/core/theme/app_colors.dart';
import 'package:revexa/core/error/error_handler.dart';
import 'package:revexa/features/auth/data/models/auth_user_model.dart';
import 'package:revexa/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:revexa/features/auth/presentation/cubit/auth_state.dart';
import 'package:revexa/core/utils/image_url_utils.dart';
import 'package:revexa/features/profile/data/datasources/profile_remote_datasource.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _profileRemote = ProfileRemoteDataSourceImpl();
  final _picker = ImagePicker();

  bool _loading = false;
  bool _loadingProfile = true;
  XFile? _pickedImage;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final state = context.read<AuthCubit>().state;
    if (state is AuthAuthenticated) {
      _fillFromUser(state.user);
    }
    try {
      final user = await _profileRemote.getProfile();
      if (mounted) {
        _fillFromUser(user);
        await context.read<AuthCubit>().applyProfileUpdate(user);
      }
    } catch (_) {
      // Use cached user if API unavailable
    } finally {
      if (mounted) setState(() => _loadingProfile = false);
    }
  }

  void _fillFromUser(AuthUser user) {
    _firstNameCtrl.text = user.firstName;
    _lastNameCtrl.text = user.lastName;
    _phoneCtrl.text = user.phone ?? '';
    _addressCtrl.text = user.address ?? '';
    _imageUrl = user.imageUrl;
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 1000, // تحديد عرض أقصى لتجنب مشاكل الذاكرة
      maxHeight: 1000,
    );
    if (picked == null) return;
    setState(() => _pickedImage = picked);
  }

  Future<void> _save(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      var updated = await _profileRemote.updateProfile(
        firstName: _firstNameCtrl.text.trim(),
        lastName: _lastNameCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        address: _addressCtrl.text.trim(),
      );

      if (_pickedImage != null) {
        final file = _pickedImage!;
        final bytes = await file.readAsBytes();
        if (kIsWeb || file.path.isEmpty) {
          updated = await _profileRemote.uploadAvatarBytes(bytes, fileName: file.name);
        } else {
          updated = await _profileRemote.uploadAvatar(file.path, fileName: file.name);
        }
        updated = updated.copyWith(
          firstName: _firstNameCtrl.text.trim(),
          lastName: _lastNameCtrl.text.trim(),
          phone: _phoneCtrl.text.trim(),
          address: _addressCtrl.text.trim(),
        );
      }

      if (!context.mounted) return;
      await context.read<AuthCubit>().applyProfileUpdate(updated);
      if (!context.mounted) return;
      context.showAppSnackBar('Profile updated successfully');
      Navigator.pop(context);
    } catch (e) {
      final message = e is DioException ? ErrorHandler.toFailure(e).message : e.toString();
      if (context.mounted) {
        context.showAppSnackBar(message, isError: true);
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Edit Profile', style: GoogleFonts.urbanist(fontSize: 18, fontWeight: FontWeight.w700)),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
      ),
      body: _loadingProfile
          ? const Center(child: CircularProgressIndicator.adaptive())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: _loading ? null : _pickImage,
                        child: Stack(
                          children: [
                            _ProfileAvatar(picked: _pickedImage, imageUrl: _imageUrl),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap to change photo',
                      style: GoogleFonts.urbanist(fontSize: 12, color: AppColors.onSurfaceVariant),
                    ),
                    const SizedBox(height: 32),
                    _EditField(
                      label: 'First Name',
                      controller: _firstNameCtrl,
                      validator: (v) => v == null || v.trim().length < 2 ? 'Min 2 characters' : null,
                    ),
                    const SizedBox(height: 16),
                    _EditField(
                      label: 'Last Name',
                      controller: _lastNameCtrl,
                      validator: (v) => v == null || v.trim().length < 2 ? 'Min 2 characters' : null,
                    ),
                    const SizedBox(height: 16),
                    _EditField(label: 'Phone Number', controller: _phoneCtrl, keyboardType: TextInputType.phone),
                    const SizedBox(height: 16),
                    _EditField(label: 'Address', controller: _addressCtrl, maxLines: 2),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _loading ? null : () => _save(context),
                        child: _loading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator.adaptive(valueColor: AlwaysStoppedAnimation<Color>(Colors.white), strokeWidth: 2),
                              )
                            : Text('Save Changes', style: GoogleFonts.urbanist(fontSize: 16, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  final XFile? picked;
  final String? imageUrl;

  const _ProfileAvatar({required this.picked, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (picked != null) {
      return FutureBuilder<Uint8List>(
        future: picked!.readAsBytes(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircleAvatar(radius: 56, child: CircularProgressIndicator.adaptive(strokeWidth: 2));
          }
          return CircleAvatar(radius: 56, backgroundImage: MemoryImage(snapshot.data!));
        },
      );
    }
    final url = ImageUrlUtils.resolve(imageUrl);
    if (url != null && (ImageUrlUtils.isNetwork(url) || ImageUrlUtils.isAsset(url))) {
      return AppCircleAvatar(
        imageUrl: url,
        radius: 56,
        backgroundColor: AppColors.primary.withValues(alpha: 0.10),
        fallback: const SizedBox.shrink(),
      );
    }
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final user = state is AuthAuthenticated ? state.user : null;
        return CircleAvatar(
          radius: 56,
          backgroundColor: AppColors.primary.withValues(alpha: 0.10),
          child: Text(
            user?.firstName.isNotEmpty == true ? user!.firstName[0].toUpperCase() : 'U',
            style: GoogleFonts.urbanist(fontSize: 36, fontWeight: FontWeight.w700, color: AppColors.primary),
          ),
        );
      },
    );
  }
}

class _EditField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final int maxLines;
  final String? Function(String?)? validator;

  const _EditField({
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(label, style: GoogleFonts.urbanist(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.secondary)),
        ),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: AppColors.outline)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: AppColors.outline)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.5), width: 2),
            ),
            errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: AppColors.error)),
          ),
        ),
      ],
    );
  }
}
