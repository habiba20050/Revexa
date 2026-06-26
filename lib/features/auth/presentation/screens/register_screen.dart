import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revexa/core/theme/app_colors.dart';
import 'package:revexa/core/constants/app_routes.dart';
import 'package:revexa/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:revexa/features/auth/presentation/cubit/auth_state.dart';
import 'package:revexa/shared/widgets/primary_button.dart';
import 'package:revexa/shared/widgets/app_logo.dart';
import 'package:revexa/l10n/app_localizations.dart';

/// شاشة إنشاء حساب جديد (Registration Screen).
/// تمكن المستخدم من إدخال بياناته الشخصية (الاسم، البريد الإلكتروني، الهاتف، العمر، الجنس، العنوان، وكلمة المرور) وإنشاء حساب.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  /// مفتاح التحقق من صحة مدخلات النموذج (Form validation key).
  final _formKey = GlobalKey<FormState>();
  
  /// حالة إخفاء/إظهار كلمة المرور.
  bool _obscurePassword = true;

  /// متحكمات حقول النص لإدخال البيانات الشخصية.
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  
  /// الجنس المختار (male كقيمة افتراضية).
  String _gender = 'male';

  @override
  void dispose() {
    // تنظيف المتحكمات عند التخلص من الـ Widget لتفادي تسريبات الذاكرة.
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _ageCtrl.dispose();
    _addressCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  /// دالة معالجة حدث الضغط على زر "إنشاء الحساب".
  /// تقوم بالتحقق من المدخلات ثم استدعاء [AuthCubit.register].
  void _onRegister(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    final age = int.tryParse(_ageCtrl.text.trim()) ?? 0;
    context.read<AuthCubit>().register(
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text,
          firstName: _firstNameCtrl.text.trim(),
          lastName: _lastNameCtrl.text.trim(),
          phone: _phoneCtrl.text.trim(),
          age: age,
          gender: _gender,
          address: _addressCtrl.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: GoogleFonts.urbanist(fontSize: 13, fontWeight: FontWeight.w500),
              ),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        final l10n = AppLocalizations.of(context)!;
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.onSurface, size: 20),
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  Navigator.pushReplacementNamed(context, AppRoutes.signIn);
                }
              },
            ),
            title: Text(
              l10n.createAccount,
              style: GoogleFonts.urbanist(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: Column(
                      children: [
                        // Compact header
                        const SizedBox(height: 4),
                        AppLogo.mini(),
                        const SizedBox(height: 14),
                        Text(
                          l10n.joinRevexa,
                          style: GoogleFonts.urbanist(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.4,
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.premiumCarManagement,
                          style: GoogleFonts.urbanist(
                            fontSize: 13,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // First & Last name row
                        Row(
                          children: [
                            Expanded(
                              child: _RegField(
                                label: l10n.firstName,
                                placeholder: 'Ahmed',
                                controller: _firstNameCtrl,
                                prefixIcon: Icons.person_outline,
                                validator: (v) =>
                                    (v == null || v.trim().length < 2)
                                        ? l10n.minCharacters(2)
                                        : null,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _RegField(
                                label: l10n.lastName,
                                placeholder: 'Mohamed',
                                controller: _lastNameCtrl,
                                prefixIcon: Icons.person_outline,
                                validator: (v) =>
                                    (v == null || v.trim().length < 2)
                                        ? l10n.minCharacters(2)
                                        : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _RegField(
                          label: l10n.emailAddress,
                          placeholder: 'name@example.com',
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.mail_outline,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return l10n.emailRequired;
                            if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,}$').hasMatch(v.trim())) {
                              return l10n.emailInvalid;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        _RegField(
                          label: l10n.phoneNumber,
                          placeholder: '+1 (555) 000-0000',
                          controller: _phoneCtrl,
                          keyboardType: TextInputType.phone,
                          prefixIcon: Icons.phone_outlined,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? l10n.phoneNumber
                              : null,
                        ),
                        const SizedBox(height: 12),
                        // Age & Gender row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _RegField(
                                label: l10n.age,
                                placeholder: '25',
                                controller: _ageCtrl,
                                keyboardType: TextInputType.number,
                                prefixIcon: Icons.cake_outlined,
                                validator: (v) {
                                  final age = int.tryParse(v ?? '');
                                  if (age == null || age < 18) return l10n.minAge;
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4, bottom: 6),
                                    child: Text(
                                      l10n.gender,
                                      style: GoogleFonts.urbanist(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.onSurface,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 52,
                                    padding: const EdgeInsets.symmetric(horizontal: 14),
                                    decoration: BoxDecoration(
                                      color: AppColors.surface,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.people_outline, color: Color(0xFF94A3B8), size: 20),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              value: _gender,
                                              isExpanded: true,
                                              icon: Icon(Icons.keyboard_arrow_down_rounded,
                                                  color: AppColors.onSurfaceVariant, size: 20),
                                              style: GoogleFonts.urbanist(
                                                fontSize: 14,
                                                color: AppColors.onSurface,
                                              ),
                                              dropdownColor: AppColors.surface,
                                              items: [
                                                DropdownMenuItem(
                                                    value: 'male', child: Text(l10n.male)),
                                                DropdownMenuItem(
                                                    value: 'female', child: Text(l10n.female)),
                                              ],
                                              onChanged: (v) => setState(() => _gender = v ?? 'male'),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _RegField(
                          label: l10n.address,
                          placeholder: 'City, Country',
                          controller: _addressCtrl,
                          prefixIcon: Icons.location_on_outlined,
                          validator: (v) => (v == null || v.trim().length < 3)
                              ? l10n.minCharacters(3)
                              : null,
                        ),
                        const SizedBox(height: 12),
                        _RegField(
                          label: l10n.password,
                          placeholder: '••••••••',
                          controller: _passwordCtrl,
                          obscureText: _obscurePassword,
                          prefixIcon: Icons.lock_outline,
                          suffixIcon: GestureDetector(
                            onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                            child: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
                              size: 20,
                            ),
                          ),
                          validator: (v) => (v == null || v.length < 6)
                              ? l10n.passwordMinLength
                              : null,
                        ),
                        const SizedBox(height: 24),

                        // Submit
                        isLoading
                            ? const Center(child: CircularProgressIndicator.adaptive())
                            : PrimaryButton(
                                label: l10n.createMyAccount,
                                trailing: const Icon(Icons.arrow_forward,
                                    color: Colors.white, size: 18),
                                onPressed: () => _onRegister(context),
                              ),
                        const SizedBox(height: 20),

                        // Sign in link
                        Text.rich(
                          TextSpan(
                            text: l10n.alreadyHaveAccount,
                            style: GoogleFonts.urbanist(
                              fontSize: 13,
                              color: AppColors.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              WidgetSpan(
                                child: GestureDetector(
                                  onTap: () => Navigator.pushReplacementNamed(
                                      context, AppRoutes.signIn),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 3),
                                    child: Text(
                                      l10n.signIn,
                                      style: GoogleFonts.urbanist(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 14),

                        // Terms
                        Text.rich(
                          TextSpan(
                            text: l10n.agreeToTerms,
                            style: GoogleFonts.urbanist(
                                fontSize: 11,
                                color: AppColors.onSurfaceVariant.withValues(alpha: 0.7),
                                height: 1.5),
                            children: [
                              TextSpan(
                                text: l10n.termsOfService,
                                style: GoogleFonts.urbanist(
                                    fontSize: 11,
                                    decoration: TextDecoration.underline,
                                    color: AppColors.onSurfaceVariant.withValues(alpha: 0.7)),
                              ),
                              TextSpan(text: l10n.and),
                              TextSpan(
                                  text: l10n.privacyPolicy,
                                  style: GoogleFonts.urbanist(
                                      fontSize: 11,
                                      decoration: TextDecoration.underline,
                                      color: AppColors.onSurfaceVariant.withValues(alpha: 0.7))),
                              const TextSpan(text: '.'),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// حقل إدخال مخصص لشاشة التسجيل (_RegField).
/// يعرض عنواناً للحقل (Label) فوق الـ TextFormField مع تخصيص الأيقونة الافتتاحية والمتحكم ونوع لوحة المفاتيح والتحقق.
class _RegField extends StatelessWidget {
  /// العنوان المعروض فوق الحقل (مثل: الاسم الأول).
  final String label;
  
  /// النص التلميحي (Placeholder/Hint Text) داخل الحقل.
  final String placeholder;
  
  /// المتحكم بالنص المكتوب داخل الحقل.
  final TextEditingController? controller;
  
  /// نوع لوحة المفاتيح المفتوحة عند التركيز على الحقل (مثلاً: phone, email).
  final TextInputType keyboardType;
  
  /// دالة التحقق من صحة المدخلات.
  final String? Function(String?)? validator;
  
  /// إخفاء أو إظهار النص (تستخدم لكلمة المرور).
  final bool obscureText;
  
  /// Widget يظهر في نهاية الحقل (مثل أيقونة إظهار كلمة المرور).
  final Widget? suffixIcon;
  
  /// أيقونة تظهر في بداية الحقل.
  final IconData? prefixIcon;

  const _RegField({
    required this.label,
    required this.placeholder,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            label,
            style: GoogleFonts.urbanist(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          style: GoogleFonts.urbanist(fontSize: 14, color: AppColors.onSurface),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: GoogleFonts.urbanist(
                fontSize: 14,
                color: AppColors.onSurfaceVariant.withValues(alpha: 0.45)),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: const Color(0xFF94A3B8), size: 20)
                : null,
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.25), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.error, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.error, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
