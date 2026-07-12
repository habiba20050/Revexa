import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revexa/core/theme/app_colors.dart';
import 'package:revexa/core/constants/app_constants.dart';
import 'package:revexa/core/network/dio_client.dart';
import 'package:revexa/core/utils/booking_navigation.dart';
import 'package:revexa/features/services/data/models/service_model.dart';
import 'package:revexa/shared/widgets/app_image.dart';
import 'package:revexa/shared/widgets/primary_button.dart';

class ServiceDetailSheet extends StatefulWidget {
  final Service service;
  final String? initialCompanyName;

  const ServiceDetailSheet({
    super.key,
    required this.service,
    this.initialCompanyName,
  });

  @override
  State<ServiceDetailSheet> createState() => _ServiceDetailSheetState();
}

class _ServiceDetailSheetState extends State<ServiceDetailSheet> {
  String? _companyName;

  @override
  void initState() {
    super.initState();
    _companyName = widget.initialCompanyName;
    if (_companyName == null) {
      _resolveCompanyName();
    }
  }

  Future<void> _resolveCompanyName() async {
    final companyId = widget.service.companyId;
    if (companyId == null || companyId.isEmpty) {
      return;
    }

    try {
      final dio = DioClient.instance.dio;
      final response = await dio.get('/users/$companyId');
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
      if (mounted) {
        setState(() {
          _companyName = resolvedName.isNotEmpty ? resolvedName : null;
        });
      }
    } catch (e) {
      final shortId = companyId.length > 4 ? companyId.substring(companyId.length - 4) : companyId;
      if (mounted) {
        final isArabic = Localizations.localeOf(context).languageCode == 'ar';
        setState(() {
          _companyName = isArabic
              ? 'شركة خدمات سيارات #$shortId'
              : 'Service Provider #$shortId';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final String resolvedCompanyName = _companyName ??
        (isArabic ? 'جاري التحميل...' : 'Loading...');

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
                      child: widget.service.firstImageUrl.isNotEmpty
                          ? AppImage(
                              source: widget.service.firstImageUrl,
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
                                  resolvedCompanyName,
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
                          if (widget.service.location != null)
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
                                    widget.service.location!,
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
                        widget.service.title,
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
                                  ? 'الوقت المقدر: ${widget.service.duration} دقيقة'
                                  : 'Estimated ${widget.service.duration} mins',
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
                        widget.service.description,
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
                        '${widget.service.price.toStringAsFixed(0)} ${isArabic ? 'ج.م' : 'EGP'}',
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
                          id: widget.service.id,
                          title: widget.service.title,
                          price: widget.service.price,
                          description: widget.service.description,
                          category: widget.service.category,
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
