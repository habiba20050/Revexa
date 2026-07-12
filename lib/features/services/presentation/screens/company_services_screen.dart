import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revexa/core/theme/app_colors.dart';
import 'package:revexa/core/constants/app_routes.dart';
import 'package:revexa/core/constants/app_constants.dart';
import 'package:revexa/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:revexa/features/auth/presentation/cubit/auth_state.dart';
import 'package:revexa/features/home/presentation/screens/company_dashboard_cubit.dart';
import 'package:revexa/features/home/presentation/screens/company_dashboard_state.dart';
import 'package:revexa/core/network/user_management_repository.dart';
import 'package:revexa/core/network/user_management_remote_datasource.dart';
import 'package:revexa/features/products/data/repositories/products_repository_impl.dart';
import 'package:revexa/features/products/data/datasources/products_remote_datasource.dart';
import 'package:revexa/features/products/presentation/cubit/products_cubit.dart';
import 'package:revexa/features/home/presentation/screens/edit_service_screen.dart';
import 'package:revexa/shared/widgets/app_image.dart';
import 'package:revexa/shared/widgets/shimmer_widgets.dart';

class CompanyServicesScreen extends StatelessWidget {
  const CompanyServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // We instantiate the cubit locally with its repository and datasource
    return BlocProvider(
      create: (context) {
        final cubit = CompanyDashboardCubit(
          UserManagementRepositoryImpl(
            UserManagementRemoteDataSourceImpl(),
          ),
          // ProductsRepositoryImpl expects a ProductsRemoteDataSource implementation
          // so we provide it here to satisfy the cubit's constructor.
          ProductsRepositoryImpl(ProductsRemoteDataSourceImpl()),
        );
        final authState = context.read<AuthCubit>().state;
        if (authState is AuthAuthenticated) {
          cubit.loadCompanyServices(authState.user.id);
        }
        return cubit;
      },
      child: const _CompanyServicesView(),
    );
  }
}

class _CompanyServicesView extends StatelessWidget {
  const _CompanyServicesView();

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: AppColors.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isArabic ? 'خدماتي الحالية' : 'My Services',
          style: GoogleFonts.urbanist(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.onSurface,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.outline),
        ),
      ),
      body: BlocBuilder<CompanyDashboardCubit, CompanyDashboardState>(
        builder: (context, state) {
          if (state is CompanyDashboardLoading || state is CompanyDashboardInitial) {
            return _buildShimmers();
          }

          if (state is CompanyDashboardError) {
            return _buildErrorState(context, state.message, isArabic);
          }

          if (state is CompanyDashboardLoaded) {
            final products = state.products;

            if (products.isEmpty) {
              return _buildEmptyState(context, isArabic);
            }

            return RefreshIndicator(
              onRefresh: () async {
                final authState = context.read<AuthCubit>().state;
                if (authState is AuthAuthenticated) {
                  await context.read<CompanyDashboardCubit>().loadCompanyServices(authState.user.id);
                }
              },
              color: AppColors.primary,
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.80,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.outline),
                      boxShadow: const [
                        BoxShadow(color: Color(0x05000000), blurRadius: 10, offset: Offset(0, 4)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Service Cover Image with Edit & Delete overlay buttons
                        Expanded(
                          flex: 11,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                  child: product.firstImageUrl.isNotEmpty
                                      ? AppImage(
                                          source: product.firstImageUrl,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        )
                                      : Image.asset(
                                          AppConstants.imgMobileWashDetail1,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: isArabic ? null : 8,
                                left: isArabic ? 8 : null,
                                child: Row(
                                  children: [
                                    // Edit Button
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.surface.withValues(alpha: 0.9),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.1),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: IconButton(
                                        icon: Icon(Icons.edit_outlined, color: AppColors.primary, size: 15),
                                        padding: const EdgeInsets.all(5),
                                        constraints: const BoxConstraints(),
                                        onPressed: () async {
                                          final didUpdate = await Navigator.of(context).push<bool>(
                                            MaterialPageRoute(
                                              builder: (ctx) => BlocProvider.value(
                                                value: context.read<ProductsCubit>(),
                                                child: EditServiceScreen(product: product),
                                              ),
                                            ),
                                          );
                                          if (didUpdate == true) {
                                            final authState = context.read<AuthCubit>().state;
                                            if (authState is AuthAuthenticated) {
                                              await context.read<CompanyDashboardCubit>().loadCompanyServices(authState.user.id);
                                            }
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    // Delete Button
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.surface.withValues(alpha: 0.9),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.1),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: IconButton(
                                        icon: Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 15),
                                        padding: const EdgeInsets.all(5),
                                        constraints: const BoxConstraints(),
                                        onPressed: () async {
                                          final confirmed = await showDialog<bool>(
                                            context: context,
                                            builder: (dialogContext) {
                                              return AlertDialog(
                                                title: Text(isArabic ? 'حذف الخدمة' : 'Delete Service'),
                                                content: Text(isArabic
                                                    ? 'هل أنت متأكد من حذف هذه الخدمة؟'
                                                    : 'Are you sure you want to delete this service?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(dialogContext, false),
                                                    child: Text(isArabic ? 'إلغاء' : 'Cancel'),
                                                  ),
                                                  ElevatedButton(
                                                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                                                    onPressed: () => Navigator.pop(dialogContext, true),
                                                    child: Text(isArabic ? 'حذف' : 'Delete'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                          if (confirmed == true) {
                                            final result = await context.read<CompanyDashboardCubit>().deleteProduct(product.id);
                                            if (!result) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text(isArabic ? 'فشل حذف الخدمة' : 'Failed to delete service'),
                                                  backgroundColor: AppColors.error,
                                                ),
                                              );
                                            }
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Details Section
                        Expanded(
                          flex: 9,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.urbanist(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      product.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.urbanist(
                                        fontSize: 10.5,
                                        color: AppColors.onSurfaceVariant,
                                        height: 1.25,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${product.price.toStringAsFixed(0)} ${isArabic ? 'ج.م' : 'EGP'}',
                                      style: GoogleFonts.urbanist(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    if (product.location != null && product.location!.isNotEmpty)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.surfaceContainerLow,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          product.location!,
                                          style: GoogleFonts.urbanist(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.onSurfaceVariant,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildShimmers() {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.80,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.outline),
          ),
          child: const Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 11,
                  child: ShimmerBox(width: double.infinity, height: double.infinity, radius: 12),
                ),
                SizedBox(height: 8),
                Expanded(
                  flex: 9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerBox(width: 80, height: 14, radius: 4),
                      SizedBox(height: 6),
                      ShimmerBox(width: 120, height: 10, radius: 4),
                      SizedBox(height: 4),
                      ShimmerBox(width: 100, height: 10, radius: 4),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ShimmerBox(width: 50, height: 12, radius: 4),
                          ShimmerBox(width: 40, height: 12, radius: 4),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(BuildContext context, String message, bool isArabic) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              isArabic ? 'حدث خطأ أثناء تحميل الخدمات' : 'Failed to load services',
              style: GoogleFonts.urbanist(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.onSurface),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.urbanist(fontSize: 13, color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final authState = context.read<AuthCubit>().state;
                if (authState is AuthAuthenticated) {
                  context.read<CompanyDashboardCubit>().loadCompanyServices(authState.user.id);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(isArabic ? 'إعادة المحاولة' : 'Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isArabic) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.design_services_outlined, size: 36, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(
              isArabic ? 'لا توجد خدمات مضافة' : 'No services added',
              style: GoogleFonts.urbanist(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.onSurface),
            ),
            const SizedBox(height: 8),
            Text(
              isArabic
                  ? 'لم تقم بإضافة أي خدمات بعد. ابدأ بإضافة خدمتك الأولى الآن.'
                  : 'You have not added any services yet. Start by adding your first service now.',
              textAlign: TextAlign.center,
              style: GoogleFonts.urbanist(fontSize: 13, color: AppColors.onSurfaceVariant, height: 1.4),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.addService);
              },
              icon: const Icon(Icons.add_rounded, size: 18),
              label: Text(isArabic ? 'إضافة خدمة' : 'Add Service'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
