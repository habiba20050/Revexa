import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revexa/core/theme/app_colors.dart';
import 'package:revexa/core/constants/app_constants.dart';
import 'package:revexa/features/services/data/models/service_model.dart';
import 'package:revexa/features/services/presentation/cubit/services_cubit.dart';
import 'package:revexa/features/services/presentation/cubit/services_state.dart';
import 'package:revexa/core/utils/booking_navigation.dart';
import 'package:revexa/shared/widgets/app_image.dart';
import 'package:revexa/shared/widgets/shimmer_widgets.dart';
import 'package:revexa/shared/widgets/primary_button.dart';
import 'package:revexa/core/network/dio_client.dart';
import 'package:revexa/features/categories/categories.dart';
import 'package:revexa/core/constants/app_routes.dart';

class FilteredServicesScreen extends StatefulWidget {
  const FilteredServicesScreen({super.key});

  @override
  State<FilteredServicesScreen> createState() => _FilteredServicesScreenState();
}

class _FilteredServicesScreenState extends State<FilteredServicesScreen> {
  // Mobile Wash default Category ID
  static const String _mobileWashCategoryId = '6a3e75112afb6104bb2b27c8';

  // Egyptian Governorates List (English & Arabic)
  static const List<Map<String, String>> _governorates = [
    {'en': 'All', 'ar': 'الكل'},
    {'en': 'Cairo', 'ar': 'القاهرة'},
    {'en': 'Giza', 'ar': 'الجيزة'},
    {'en': 'Alexandria', 'ar': 'الإسكندرية'},
    {'en': 'Assiut', 'ar': 'أسيوط'},
    {'en': 'Sohag', 'ar': 'سوهاج'},
    {'en': 'Qena', 'ar': 'قنا'},
    {'en': 'Aswan', 'ar': 'أسوان'},
    {'en': 'Minya', 'ar': 'المنيا'},
    {'en': 'Fayoum', 'ar': 'الفيوم'},
    {'en': 'Beni Suef', 'ar': 'بني سويف'},
    {'en': 'Qalyubia', 'ar': 'القليوبية'},
    {'en': 'Monufia', 'ar': 'المنوفية'},
    {'en': 'Gharbia', 'ar': 'الغربية'},
    {'en': 'Dakahlia', 'ar': 'الدقهلية'},
    {'en': 'Sharqia', 'ar': 'الشرقية'},
    {'en': 'Beheira', 'ar': 'البحيرة'},
    {'en': 'Damietta', 'ar': 'دمياط'},
    {'en': 'Kafr El-Sheikh', 'ar': 'كفر الشيخ'},
    {'en': 'Port Said', 'ar': 'بورسعيد'},
    {'en': 'Suez', 'ar': 'السويس'},
    {'en': 'Ismailia', 'ar': 'الإسماعيلية'},
    {'en': 'Red Sea', 'ar': 'البحر الأحمر'},
    {'en': 'Matrouh', 'ar': 'مطروح'},
    {'en': 'New Valley', 'ar': 'الوادي الجديد'},
    {'en': 'North Sinai', 'ar': 'شمال سيناء'},
    {'en': 'South Sinai', 'ar': 'جنوب سيناء'},
    {'en': 'Luxor', 'ar': 'الأقصر'},
  ];

  Map<String, String> _selectedGov = _governorates[0]; // Default is All
  final Map<String, String> _companyNames = {};

  bool _initialized = false;
  String _categoryName = '';
  String? _categoryId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final routeName = ModalRoute.of(context)?.settings.name;
      final isArabic = Localizations.localeOf(context).languageCode == 'ar';

      if (routeName == AppRoutes.maintenanceDetail) {
        _categoryName = isArabic ? 'صيانة السيارات' : 'Car Maintenance';
      } else if (routeName == AppRoutes.oilServiceDetail) {
        _categoryName = isArabic ? 'تغيير الزيت' : 'Oil Service';
      } else if (routeName == AppRoutes.tiresDetail) {
        _categoryName = isArabic ? 'إطارات السيارات' : 'Car Tires';
      } else if (routeName == AppRoutes.batteryDetail) {
        _categoryName = isArabic ? 'بطاريات السيارات' : 'Car Batteries';
      } else {
        _categoryName = isArabic ? 'غسيل السيارات' : 'Car Washing';
        _categoryId = '6a3e75112afb6104bb2b27c8'; // Default mobile wash category ID
      }

      // Load categories if not already loaded to dynamically resolve IDs
      final categoriesCubit = context.read<CategoriesCubit>();
      if (categoriesCubit.state is! CategoriesLoaded) {
        categoriesCubit.loadCategories();
      }

      _loadCategoryServices();
    }
  }

  void _loadCategoryServices() {
    final categoriesState = context.read<CategoriesCubit>().state;
    if (_categoryId == null && categoriesState is CategoriesLoaded) {
      for (final cat in categoriesState.categories) {
        if (cat.name.toLowerCase().contains(_categoryName.toLowerCase()) ||
            _categoryName.toLowerCase().contains(cat.name.toLowerCase())) {
          _categoryId = cat.id;
          break;
        }
      }
    }

    // Load services for this category ID (fallback to default mobile wash ID if not resolved yet)
    final idToLoad = _categoryId ?? _mobileWashCategoryId;
    context.read<ServicesCubit>().loadServicesByCategory(idToLoad);
  }

  // Resolves company names from their IDs using the API, caching them locally
  Future<void> _resolveCompanyNames(List<Service> services) async {
    final uniqueCompanyIds = services
        .map((s) => s.companyId)
        .where((id) => id != null && id.isNotEmpty && !_companyNames.containsKey(id))
        .cast<String>()
        .toSet();

    if (uniqueCompanyIds.isEmpty) return;

    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final dio = DioClient.instance.dio;
    for (final id in uniqueCompanyIds) {
      try {
        final response = await dio.get('/users/$id');
        final data = response.data;
        String resolvedName = '';
        if (data is Map) {
          final userMap = data['data'] ?? data['user'] ?? data;
          if (userMap is Map) {
            final name = userMap['name']?.toString() ?? '';
            final first = userMap['firstName']?.toString() ?? '';
            final last = userMap['lastName']?.toString() ?? '';
            if (first.isNotEmpty || last.isNotEmpty) {
              resolvedName = '$first $last'.trim();
            } else if (name.isNotEmpty) {
              resolvedName = name.trim();
            }
          }
        }
        if (resolvedName.isNotEmpty) {
          if (mounted) {
            setState(() {
              _companyNames[id] = resolvedName;
            });
          }
        }
      } catch (e) {
        // Fallback name if API request fails (e.g. 403 Forbidden for non-admin)
        final shortId = id.length > 4 ? id.substring(id.length - 4) : id;
        final fallbackName = isArabic
            ? 'شركة خدمات غسيل سيارات #$shortId'
            : 'Car Wash Provider #$shortId';
        if (mounted) {
          setState(() {
            _companyNames[id] = fallbackName;
          });
        }
      }
    }
  }

  void _showGovernorateFilter() {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return _GovFilterSheet(
          governorates: _governorates,
          selectedGov: _selectedGov,
          isArabic: isArabic,
          onSelect: (gov) {
            setState(() {
              _selectedGov = gov;
            });
          },
        );
      },
    );
  }

  void _showServiceDetails(Service service, String companyName) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return _ServiceDetailSheet(
          service: service,
          companyName: companyName,
          isArabic: isArabic,
        );
      },
    );
  }

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
          _categoryName.isNotEmpty ? _categoryName : (isArabic ? 'خدمات الغسيل' : 'Washing Services'),
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
      body: BlocListener<CategoriesCubit, CategoriesState>(
        listener: (context, state) {
          if (state is CategoriesLoaded && _categoryId == null) {
            for (final cat in state.categories) {
              if (cat.name.toLowerCase().contains(_categoryName.toLowerCase()) ||
                  _categoryName.toLowerCase().contains(cat.name.toLowerCase())) {
                setState(() {
                  _categoryId = cat.id;
                });
                context.read<ServicesCubit>().loadServicesByCategory(cat.id);
                break;
              }
            }
          }
        },
        child: Column(
          children: [
          // Filter section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            color: AppColors.surface,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _showGovernorateFilter,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.outline),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.location_on_rounded, color: AppColors.primary, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isArabic ? 'المحافظة' : 'Governorate',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 11,
                                    color: AppColors.onSurfaceVariant,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _selectedGov[isArabic ? 'ar' : 'en']!,
                                  style: GoogleFonts.urbanist(
                                    fontSize: 14,
                                    color: AppColors.onSurface,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.onSurfaceVariant),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content body
          Expanded(
            child: BlocBuilder<ServicesCubit, ServicesState>(
              builder: (context, state) {
                if (state is ServicesLoading || state is ServicesInitial) {
                  return _buildShimmers();
                }

                if (state is ServicesError) {
                  return _buildErrorState(state.message);
                }

                if (state is ServicesByCategory) {
                  final services = state.services;

                  // Trigger name resolution in background
                  _resolveCompanyNames(services);

                  // Apply location filtering
                  final selectedGovEn = _selectedGov['en']!;
                  final filteredServices = services.where((s) {
                    if (selectedGovEn == 'All') return true;
                    if (s.location == null || s.location!.isEmpty) return false;
                    final locations = s.location!.split(',').map((l) => l.trim().toLowerCase());
                    return locations.contains(selectedGovEn.toLowerCase());
                  }).toList();

                  if (filteredServices.isEmpty) {
                    return _buildEmptyState(isArabic);
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      _loadCategoryServices();
                    },
                    color: AppColors.primary,
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                      itemCount: filteredServices.length,
                      itemBuilder: (context, index) {
                        final service = filteredServices[index];
                        final companyName = _companyNames[service.companyId ?? ''] ??
                            (isArabic ? 'جاري التحميل...' : 'Loading...');

                        return _ServiceCardItem(
                          service: service,
                          companyName: companyName,
                          isArabic: isArabic,
                          onDetailsTap: () => _showServiceDetails(service, companyName),
                        );
                      },
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
     ),
    );
  }

  Widget _buildShimmers() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          height: 160,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.outline),
          ),
          child: const Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                ShimmerBox(width: 110, height: double.infinity, radius: 12),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShimmerBox(width: 80, height: 16, radius: 4),
                      SizedBox(height: 8),
                      ShimmerBox(width: 130, height: 18, radius: 4),
                      SizedBox(height: 8),
                      ShimmerBox(width: 160, height: 14, radius: 4),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ShimmerBox(width: 50, height: 18, radius: 4),
                          ShimmerBox(width: 70, height: 32, radius: 8),
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

  Widget _buildErrorState(String message) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              isArabic ? 'حدث خطأ غير متوقع' : 'An error occurred',
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
                _loadCategoryServices();
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

  Widget _buildEmptyState(bool isArabic) {
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
              child: Icon(Icons.search_off_rounded, size: 36, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(
              isArabic ? 'لا توجد خدمات متاحة' : 'No services available',
              style: GoogleFonts.urbanist(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.onSurface),
            ),
            const SizedBox(height: 8),
            Text(
              isArabic
                  ? 'لا توجد شركات تقدم خدمات الغسيل في هذه المحافظة حالياً.'
                  : 'There are no companies offering washing services in this governorate yet.',
              textAlign: TextAlign.center,
              style: GoogleFonts.urbanist(fontSize: 13, color: AppColors.onSurfaceVariant, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Governorate Filter Sheet ──────────────────────────────────────────────

class _GovFilterSheet extends StatefulWidget {
  final List<Map<String, String>> governorates;
  final Map<String, String> selectedGov;
  final bool isArabic;
  final ValueChanged<Map<String, String>> onSelect;

  const _GovFilterSheet({
    required this.governorates,
    required this.selectedGov,
    required this.isArabic,
    required this.onSelect,
  });

  @override
  State<_GovFilterSheet> createState() => _GovFilterSheetState();
}

class _GovFilterSheetState extends State<_GovFilterSheet> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.governorates.where((gov) {
      final name = gov[widget.isArabic ? 'ar' : 'en']!.toLowerCase();
      return name.contains(_query.toLowerCase());
    }).toList();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 48,
              height: 4.5,
              decoration: BoxDecoration(
                color: AppColors.outline,
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.isArabic ? 'اختر المحافظة' : 'Select Governorate',
                    style: GoogleFonts.urbanist(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: AppColors.onSurfaceVariant),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            // Search Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.outline),
                ),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (v) {
                    setState(() {
                      _query = v;
                    });
                  },
                  style: GoogleFonts.urbanist(fontSize: 14, color: AppColors.onSurface),
                  decoration: InputDecoration(
                    hintText: widget.isArabic ? 'ابحث عن محافظة...' : 'Search governorate...',
                    hintStyle: GoogleFonts.urbanist(color: AppColors.onSurfaceVariant, fontSize: 14),
                    prefixIcon: Icon(Icons.search_rounded, color: AppColors.onSurfaceVariant, size: 20),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final gov = filtered[index];
                  final name = gov[widget.isArabic ? 'ar' : 'en']!;
                  final isSelected = gov['en'] == widget.selectedGov['en'];

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    title: Text(
                      name,
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? AppColors.primary : AppColors.onSurface,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20)
                        : null,
                    onTap: () {
                      widget.onSelect(gov);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Service Card Item ──────────────────────────────────────────────────────

class _ServiceCardItem extends StatelessWidget {
  final Service service;
  final String companyName;
  final bool isArabic;
  final VoidCallback onDetailsTap;

  const _ServiceCardItem({
    required this.service,
    required this.companyName,
    required this.isArabic,
    required this.onDetailsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outline),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left (or Right for RTL) - Cover image
            ClipRRect(
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(isArabic ? 0 : 20),
                right: Radius.circular(isArabic ? 20 : 0),
              ),
              child: SizedBox(
                width: 125,
                child: service.firstImageUrl.isNotEmpty
                    ? AppImage(
                        source: service.firstImageUrl,
                        fit: BoxFit.cover,
                        errorWidget: Image.asset(
                          AppConstants.imgMobileWashDetail1,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset(
                        AppConstants.imgMobileWashDetail1,
                        fit: BoxFit.cover,
                      ),
              ),
            ),

            // Content side
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Company Name
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.business_rounded, color: AppColors.primary, size: 12),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              companyName,
                              style: GoogleFonts.urbanist(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Service Title
                    Text(
                      service.title,
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Description
                    Expanded(
                      child: Text(
                        service.description,
                        style: GoogleFonts.urbanist(
                          fontSize: 11,
                          color: AppColors.onSurfaceVariant,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Price and Action Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isArabic ? 'السعر' : 'Price',
                              style: GoogleFonts.urbanist(fontSize: 10, color: AppColors.onSurfaceVariant),
                            ),
                            Text(
                              '${service.price.toStringAsFixed(0)} ${isArabic ? 'ج.م' : 'EGP'}',
                              style: GoogleFonts.urbanist(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: onDetailsTap,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              isArabic ? 'التفاصيل' : 'Details',
                              style: GoogleFonts.urbanist(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
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
      ),
    );
  }
}

// ─── Service Detail Sheet ──────────────────────────────────────────────────

class _ServiceDetailSheet extends StatelessWidget {
  final Service service;
  final String companyName;
  final bool isArabic;

  const _ServiceDetailSheet({
    required this.service,
    required this.companyName,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Cover image
                Stack(
                  children: [
                    SizedBox(
                      height: 220,
                      width: double.infinity,
                      child: service.firstImageUrl.isNotEmpty
                          ? AppImage(
                              source: service.firstImageUrl,
                              fit: BoxFit.cover,
                              errorWidget: Image.asset(
                                AppConstants.imgMobileWashDetail1,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Image.asset(
                              AppConstants.imgMobileWashDetail1,
                              fit: BoxFit.cover,
                            ),
                    ),
                    // Glassmorphic Close button overlay
                    Positioned(
                      top: 16,
                      right: isArabic ? null : 16,
                      left: isArabic ? 16 : null,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),

                // Details Content
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badges Row
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.business_rounded, color: AppColors.primary, size: 13),
                                const SizedBox(width: 5),
                                Text(
                                  companyName,
                                  style: GoogleFonts.urbanist(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (service.location != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerHigh,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.location_on_rounded, color: AppColors.onSurfaceVariant, size: 13),
                                  const SizedBox(width: 5),
                                  Text(
                                    service.location!,
                                    style: GoogleFonts.urbanist(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Service Title
                      Text(
                        service.title,
                        style: GoogleFonts.urbanist(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Duration info
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.timer_outlined, color: AppColors.primary, size: 14),
                            const SizedBox(width: 6),
                            Text(
                              isArabic
                                  ? 'الوقت المقدر: ${service.duration} دقيقة'
                                  : 'Estimated ${service.duration} mins',
                              style: GoogleFonts.urbanist(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Description header
                      Text(
                        isArabic ? 'عن الخدمة' : 'Description',
                        style: GoogleFonts.urbanist(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Description body
                      Text(
                        service.description,
                        style: GoogleFonts.urbanist(
                          fontSize: 13.5,
                          color: AppColors.onSurfaceVariant,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom sticky Booking bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.outline)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0a000000),
                    blurRadius: 16,
                    offset: Offset(0, -4),
                  )
                ],
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isArabic ? 'السعر الإجمالي' : 'Total Price',
                        style: GoogleFonts.urbanist(
                          fontSize: 11,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${service.price.toStringAsFixed(0)} ${isArabic ? 'ج.م' : 'EGP'}',
                        style: GoogleFonts.urbanist(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: PrimaryButton(
                      label: isArabic ? 'احجز الآن' : 'Book Now',
                      onPressed: () {
                        // Pop sheet and launch booking
                        Navigator.pop(context);
                        openServiceBooking(
                          context,
                          id: service.id,
                          title: service.title,
                          price: service.price,
                          description: service.description,
                          category: service.category,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
