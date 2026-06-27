import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revexa/core/theme/app_colors.dart';
import 'package:revexa/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:revexa/features/auth/presentation/cubit/auth_state.dart';
import 'package:revexa/shared/widgets/app_image.dart';

class AppAppBarAvatar extends StatelessWidget {
  final double size;

  const AppAppBarAvatar({super.key, this.size = 36});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final user = state is AuthAuthenticated ? state.user : null;
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withValues(alpha: 0.10),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.20),
              width: 2,
            ),
          ),
          child: AppCircleAvatar(
            imageUrl: user?.imageUrl,
            radius: size / 2,
            backgroundColor: Colors.transparent,
            fallback: Icon(
              Icons.person_outline,
              color: AppColors.primary,
              size: size * 0.5,
            ),
          ),
        );
      },
    );
  }
}
