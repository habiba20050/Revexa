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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  String _gender = 'male';

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _ageCtrl.dispose();
    _addressCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

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
              content: Text(state.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back, size: 26, color: AppColors.primary),
                      ),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.createAccount,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          const AppLogoGrid(),
                          const SizedBox(height: 24),
                          Text(
                            AppLocalizations.of(context)!.joinRevexa,
                            style: GoogleFonts.inter(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                              color: AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            AppLocalizations.of(context)!.premiumCarManagement,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // First & Last name row
                          Row(
                            children: [
                              Expanded(
                                child: _RegField(
                                  label: AppLocalizations.of(context)!.firstName,
                                  placeholder: 'Ahmed',
                                  controller: _firstNameCtrl,
                                  validator: (v) => (v == null || v.trim().length < 2)
                                      ? AppLocalizations.of(context)!.minCharacters(2) : null,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _RegField(
                                  label: AppLocalizations.of(context)!.lastName,
                                  placeholder: 'Mohamed',
                                  controller: _lastNameCtrl,
                                  validator: (v) => (v == null || v.trim().length < 2)
                                      ? AppLocalizations.of(context)!.minCharacters(2) : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _RegField(
                            label: AppLocalizations.of(context)!.emailAddress,
                            placeholder: 'name@example.com',
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) return AppLocalizations.of(context)!.emailRequired;
                              if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,}$').hasMatch(v.trim())) {
                                return AppLocalizations.of(context)!.emailInvalid;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          _RegField(
                            label: AppLocalizations.of(context)!.phoneNumber,
                            placeholder: '+1 (555) 000-0000',
                            controller: _phoneCtrl,
                            keyboardType: TextInputType.phone,
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? AppLocalizations.of(context)!.phoneNumber : null,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _RegField(
                                  label: AppLocalizations.of(context)!.age,
                                  placeholder: '25',
                                  controller: _ageCtrl,
                                  keyboardType: TextInputType.number,
                                  validator: (v) {
                                    final age = int.tryParse(v ?? '');
                                    if (age == null || age < 18) return AppLocalizations.of(context)!.minAge;
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4, bottom: 6),
                                      child: Text(
                                        AppLocalizations.of(context)!.gender,
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF475569),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 48,
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      decoration: BoxDecoration(
                                        color: AppColors.surface,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: AppColors.outline),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: _gender,
                                          isExpanded: true,
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            color: AppColors.onSurface,
                                          ),
                                          items: [
                                            DropdownMenuItem(value: 'male', child: Text(AppLocalizations.of(context)!.male)),
                                            DropdownMenuItem(value: 'female', child: Text(AppLocalizations.of(context)!.female)),
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
                          const SizedBox(height: 12),
                          _RegField(
                            label: AppLocalizations.of(context)!.address,
                            placeholder: 'City, Country',
                            controller: _addressCtrl,
                            validator: (v) => (v == null || v.trim().length < 3)
                                ? AppLocalizations.of(context)!.minCharacters(3) : null,
                          ),
                          const SizedBox(height: 12),
                          // Password
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 4, bottom: 6),
                                child: Text(
                                  AppLocalizations.of(context)!.password,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF475569),
                                  ),
                                ),
                              ),
                              TextFormField(
                                controller: _passwordCtrl,
                                obscureText: _obscurePassword,
                                validator: (v) => (v == null || v.length < 6)
                                    ? AppLocalizations.of(context)!.passwordMinLength : null,
                                decoration: InputDecoration(
                                  hintText: '••••••••',
                                  hintStyle: GoogleFonts.inter(color: const Color(0xFF94A3B8)),
                                  filled: true,
                                  fillColor: AppColors.surface,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                  suffixIcon: GestureDetector(
                                    onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                                    child: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: const Color(0xFF94A3B8),
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: AppColors.outline),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: AppColors.outline),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        color: AppColors.primary.withValues(alpha: 0.5), width: 2),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: AppColors.error),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : PrimaryButton(
                                  label: AppLocalizations.of(context)!.createMyAccount,
                                  trailing: const Icon(Icons.arrow_forward,
                                      color: Colors.white, size: 20),
                                  onPressed: () => _onRegister(context),
                                ),
                          const SizedBox(height: 24),
                          Text.rich(
                            TextSpan(
                              text: AppLocalizations.of(context)!.alreadyHaveAccount,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: AppColors.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                              children: [
                                WidgetSpan(
                                  child: GestureDetector(
                                    onTap: () => Navigator.pushReplacementNamed(
                                        context, AppRoutes.signIn),
                                    child: Text(
                                      AppLocalizations.of(context)!.signIn,
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Text.rich(
                            TextSpan(
                              text: AppLocalizations.of(context)!.agreeToTerms,
                              style: GoogleFonts.inter(
                                  fontSize: 11, color: const Color(0xFF94A3B8), height: 1.5),
                              children: [
                                TextSpan(
                                  text: AppLocalizations.of(context)!.termsOfService,
                                  style: GoogleFonts.inter(
                                      fontSize: 11,
                                      decoration: TextDecoration.underline,
                                      color: const Color(0xFF94A3B8)),
                                ),
                                TextSpan(text: AppLocalizations.of(context)!.and),
                                TextSpan(
                                  text: AppLocalizations.of(context)!.privacyPolicy,
                                  style: GoogleFonts.inter(
                                      fontSize: 11,
                                      decoration: TextDecoration.underline,
                                      color: const Color(0xFF94A3B8)),
                                ),
                                const TextSpan(text: '.'),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RegField extends StatelessWidget {
  final String label;
  final String placeholder;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const _RegField({
    required this.label,
    required this.placeholder,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
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
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF475569),
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: GoogleFonts.inter(color: const Color(0xFF94A3B8)),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.5), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.error),
            ),
          ),
        ),
      ],
    );
  }
}
