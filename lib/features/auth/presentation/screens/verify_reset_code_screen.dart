import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revexa/core/constants/app_routes.dart';
import 'package:revexa/core/theme/app_colors.dart';
import 'package:revexa/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:revexa/features/auth/presentation/cubit/auth_state.dart';
import 'package:revexa/shared/widgets/primary_button.dart';

class VerifyResetCodeScreen extends StatefulWidget {
  final String email;
  const VerifyResetCodeScreen({super.key, required this.email});

  @override
  State<VerifyResetCodeScreen> createState() => _VerifyResetCodeScreenState();
}

class _VerifyResetCodeScreenState extends State<VerifyResetCodeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeCtrl = TextEditingController();

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  void _onSubmit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().verifyResetCode(
          email: widget.email,
          code: _codeCtrl.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is VerifyResetCodeSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Code verified! Set your new password.'),
              backgroundColor: Color(0xFF22C55E),
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.resetPassword,
            arguments: state.resetToken,
          );
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
          body: Stack(
            children: [
              Positioned(
                top: -40,
                right: -40,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withValues(alpha: 0.05),
                  ),
                ),
              ),
              Positioned(
                bottom: -20,
                left: -20,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withValues(alpha: 0.05),
                  ),
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    // Top bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(Icons.arrow_back,
                                color: Color(0xFF64748B), size: 24),
                          ),
                          const SizedBox(width: 16),
                          Row(
                            children: [
                              SizedBox(
                                width: 22,
                                height: 22,
                                child: GridView.count(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 1.5,
                                  mainAxisSpacing: 1.5,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius: BorderRadius.circular(2))),
                                    Container(
                                        decoration: BoxDecoration(
                                            color: AppColors.primary.withValues(alpha: 0.6),
                                            borderRadius: BorderRadius.circular(2))),
                                    Container(
                                        decoration: BoxDecoration(
                                            color: AppColors.primary.withValues(alpha: 0.6),
                                            borderRadius: BorderRadius.circular(2))),
                                    Container(
                                        decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius: BorderRadius.circular(2))),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'REVEXA',
                                style: GoogleFonts.urbanist(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.5,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              const SizedBox(height: 40),
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.10),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.mark_email_read_outlined,
                                    color: AppColors.primary, size: 36),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Verify OTP Code',
                                style: GoogleFonts.urbanist(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.3,
                                  color: AppColors.onSurface,
                                ),
                              ),
                              const SizedBox(height: 16),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: GoogleFonts.urbanist(
                                    fontSize: 14,
                                    color: AppColors.onSurfaceVariant,
                                    height: 1.6,
                                  ),
                                  children: [
                                    const TextSpan(text: 'Enter the OTP code sent to '),
                                    TextSpan(
                                      text: widget.email.isEmpty
                                          ? 'your email'
                                          : widget.email,
                                      style: GoogleFonts.urbanist(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 32),
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(alpha: 0.06),
                                      blurRadius: 24,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'OTP Code',
                                      style: GoogleFonts.urbanist(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.secondary,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      controller: _codeCtrl,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(6),
                                      ],
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.urbanist(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 8,
                                        color: AppColors.onSurface,
                                      ),
                                      validator: (v) {
                                        if (v == null || v.trim().isEmpty) {
                                          return 'Code is required';
                                        }
                                        if (v.trim().length < 4) {
                                          return 'Enter the full OTP code';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        hintText: '• • • • • •',
                                        hintStyle: GoogleFonts.urbanist(
                                          color: AppColors.onSurfaceVariant.withValues(alpha: 0.4),
                                          fontSize: 22,
                                          letterSpacing: 6,
                                        ),
                                        filled: true,
                                        fillColor: AppColors.surface,
                                        contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 18),
                                        prefixIcon: const Icon(Icons.pin_outlined,
                                            color: Color(0xFF94A3B8), size: 22),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(16),
                                          borderSide: BorderSide(color: AppColors.outline),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(16),
                                          borderSide: BorderSide(color: AppColors.outline),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(16),
                                          borderSide: BorderSide(
                                              color: AppColors.primary.withValues(alpha: 0.5),
                                              width: 2),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(16),
                                          borderSide: BorderSide(color: AppColors.error),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    isLoading
                                        ? const Center(
                                            child: CircularProgressIndicator.adaptive())
                                        : PrimaryButton(
                                            label: 'Verify Code',
                                            trailing: const Icon(Icons.verified_user_outlined,
                                                color: Colors.white, size: 18),
                                            onPressed: () => _onSubmit(context),
                                          ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Resend hint
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.surface,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: const [
                                          BoxShadow(
                                              color: Color(0x0F000000),
                                              blurRadius: 4,
                                              offset: Offset(0, 1)),
                                        ],
                                      ),
                                      child: Icon(Icons.info_outline,
                                          color: AppColors.primary, size: 20),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        "Didn't receive the code? Go back and request a new one.",
                                        style: GoogleFonts.urbanist(
                                          fontSize: 12,
                                          color: AppColors.onSurfaceVariant,
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.arrow_back_ios,
                                        color: AppColors.primary, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Back to Forgot Password',
                                      style: GoogleFonts.urbanist(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
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
            ],
          ),
        );
      },
    );
  }
}
