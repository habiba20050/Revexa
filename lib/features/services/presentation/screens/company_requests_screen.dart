import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:revexa/core/theme/app_colors.dart';
import 'package:revexa/features/orders/data/models/order_model.dart';
import 'package:revexa/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:revexa/shared/widgets/shimmer_widgets.dart';

enum BookingTimeFilter { day, week, year }

class CompanyRequestsScreen extends StatefulWidget {
  const CompanyRequestsScreen({super.key});

  @override
  State<CompanyRequestsScreen> createState() => _CompanyRequestsScreenState();
}

class _CompanyRequestsScreenState extends State<CompanyRequestsScreen> {
  BookingTimeFilter _activeFilter = BookingTimeFilter.day;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrdersCubit>().loadOrders();
    });
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
          isArabic ? 'طلبات الحجوزات' : 'Booking Requests',
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
      body: Column(
        children: [
          // Filter Row
          _buildFilterTabs(isArabic),

          // Content
          Expanded(
            child: BlocBuilder<OrdersCubit, OrdersState>(
              builder: (context, state) {
                if (state is OrdersLoading || state is OrdersInitial) {
                  return _buildShimmerList();
                }

                if (state is OrdersError) {
                  return _buildErrorState(state.message, isArabic);
                }

                if (state is OrdersLoaded) {
                  final filteredOrders = _filterOrders(state.orders);

                  if (filteredOrders.isEmpty) {
                    return _buildEmptyState(isArabic);
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      await context.read<OrdersCubit>().loadOrders();
                    },
                    color: AppColors.primary,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      itemCount: filteredOrders.length,
                      itemBuilder: (context, index) {
                        final order = filteredOrders[index];
                        return _buildRequestCard(context, order, isArabic);
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
    );
  }

  Widget _buildFilterTabs(bool isArabic) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            _buildTabButton(
              filter: BookingTimeFilter.day,
              label: isArabic ? 'اليوم' : 'Day',
            ),
            _buildTabButton(
              filter: BookingTimeFilter.week,
              label: isArabic ? 'هذا الأسبوع' : 'Week',
            ),
            _buildTabButton(
              filter: BookingTimeFilter.year,
              label: isArabic ? 'هذه السنة' : 'Year',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton({required BookingTimeFilter filter, required String label}) {
    final isActive = _activeFilter == filter;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _activeFilter = filter;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? AppColors.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isActive
                ? [const BoxShadow(color: Color(0x05000000), blurRadius: 8, offset: Offset(0, 2))]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.urbanist(
              fontSize: 13,
              fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
              color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }

  List<Order> _filterOrders(List<Order> orders) {
    final now = DateTime.now();

    // Sort newest first
    final sorted = List<Order>.from(orders)
      ..sort((a, b) => b.appointmentDate.compareTo(a.appointmentDate));

    return sorted.where((order) {
      final date = order.appointmentDate;
      switch (_activeFilter) {
        case BookingTimeFilter.day:
          return date.year == now.year && date.month == now.month && date.day == now.day;
        case BookingTimeFilter.week:
          // Find standard week bounds (Sunday to Saturday)
          final startOfWeek = now.subtract(Duration(days: now.weekday % 7));
          final endOfWeek = startOfWeek.add(const Duration(days: 7));
          return date.isAfter(startOfWeek.subtract(const Duration(seconds: 1))) &&
              date.isBefore(endOfWeek.add(const Duration(seconds: 1)));
        case BookingTimeFilter.year:
          return date.year == now.year;
      }
    }).toList();
  }

  Widget _buildRequestCard(BuildContext context, Order order, bool isArabic) {
    final dateStr = DateFormat('MMM dd, yyyy').format(order.appointmentDate);
    final timeStr = DateFormat('hh:mm a').format(order.appointmentDate);

    // Style according to status
    Color badgeColor = Colors.grey;
    String statusTextEn = 'Pending';
    String statusTextAr = 'معلق';

    if (order.isConfirmed) {
      badgeColor = Colors.blue;
      statusTextEn = 'Confirmed';
      statusTextAr = 'مؤكد';
    } else if (order.isCompleted) {
      badgeColor = Colors.green;
      statusTextEn = 'Completed';
      statusTextAr = 'مكتمل';
    } else if (order.isCancelled) {
      badgeColor = Colors.red;
      statusTextEn = 'Cancelled';
      statusTextAr = 'ملغي';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outline),
        boxShadow: const [
          BoxShadow(color: Color(0x03000000), blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.service?.title ?? (isArabic ? 'خدمة مخصصة' : 'Custom Service'),
                        style: GoogleFonts.urbanist(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.calendar_today_rounded, size: 13, color: AppColors.onSurfaceVariant),
                          const SizedBox(width: 6),
                          Text(
                            '$dateStr | $timeStr',
                            style: GoogleFonts.urbanist(
                              fontSize: 12,
                              color: AppColors.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  '${order.totalAmount.toStringAsFixed(0)} ${isArabic ? 'ج.م' : 'EGP'}',
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Card Body (Car Details & Status)
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isArabic ? 'بيانات السيارة:' : 'Vehicle details:',
                      style: GoogleFonts.urbanist(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: badgeColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isArabic ? statusTextAr : statusTextEn,
                        style: GoogleFonts.urbanist(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: badgeColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${isArabic ? 'الموديل:' : 'Model:'} ${order.carDetails.model}',
                  style: GoogleFonts.urbanist(fontSize: 13, color: AppColors.onSurface, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  '${isArabic ? 'رقم اللوحة:' : 'Plate:'} ${order.carDetails.plateNumber}',
                  style: GoogleFonts.urbanist(fontSize: 13, color: AppColors.onSurface, fontWeight: FontWeight.w600),
                ),
                if (order.carDetails.color != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${isArabic ? 'اللون:' : 'Color:'} ${order.carDetails.color}',
                    style: GoogleFonts.urbanist(fontSize: 13, color: AppColors.onSurface, fontWeight: FontWeight.w600),
                  ),
                ],
              ],
            ),
          ),

          // Accept / Cancel actions
          if (order.isPending || order.isConfirmed) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  if (order.isPending) ...[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _updateStatus(context, order.id, 'confirmed', isArabic),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          isArabic ? 'قبول الطلب' : 'Accept Request',
                          style: GoogleFonts.urbanist(fontSize: 13, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _updateStatus(context, order.id, 'cancelled', isArabic),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        isArabic ? 'إلغاء الطلب' : 'Cancel Request',
                        style: GoogleFonts.urbanist(fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _updateStatus(BuildContext context, String orderId, String newStatus, bool isArabic) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      await context.read<OrdersCubit>().updateOrderStatus(orderId, newStatus);
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(
            isArabic
                ? (newStatus == 'confirmed' ? 'تم قبول الحجز بنجاح' : 'تم إلغاء الحجز بنجاح')
                : (newStatus == 'confirmed' ? 'Booking accepted' : 'Booking cancelled'),
          ),
          backgroundColor: newStatus == 'confirmed' ? Colors.green : Colors.red,
        ),
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error),
      );
    }
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          height: 180,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.outline),
          ),
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShimmerBox(width: 140, height: 18, radius: 4),
                    ShimmerBox(width: 60, height: 18, radius: 4),
                  ],
                ),
                SizedBox(height: 8),
                ShimmerBox(width: 120, height: 12, radius: 4),
                Spacer(),
                Divider(),
                Spacer(),
                ShimmerBox(width: 80, height: 14, radius: 4),
                SizedBox(height: 8),
                ShimmerBox(width: 180, height: 12, radius: 4),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(String message, bool isArabic) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              isArabic ? 'فشل تحميل الطلبات' : 'Failed to load requests',
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
              onPressed: () => context.read<OrdersCubit>().loadOrders(),
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
              child: Icon(Icons.event_busy_rounded, size: 36, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(
              isArabic ? 'لا توجد طلبات' : 'No requests found',
              style: GoogleFonts.urbanist(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.onSurface),
            ),
            const SizedBox(height: 8),
            Text(
              isArabic
                  ? 'لا توجد حجوزات مقررة في هذه الفترة الزمنية.'
                  : 'There are no bookings scheduled in this time frame.',
              textAlign: TextAlign.center,
              style: GoogleFonts.urbanist(fontSize: 13, color: AppColors.onSurfaceVariant, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
