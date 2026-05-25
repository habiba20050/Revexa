import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:revexa/core/theme/app_colors.dart';
import 'package:revexa/features/orders/data/models/order_model.dart';
import 'package:revexa/features/orders/presentation/cubit/orders_cubit.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final order = ModalRoute.of(context)!.settings.arguments as Order;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Order Details',
            style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700)),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero status card
            _OrderStatusCard(order: order),
            const SizedBox(height: 24),

            // Status timeline
            Text('Progress',
                style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface)),
            const SizedBox(height: 16),
            _StatusTimeline(currentStatus: order.status),
            const SizedBox(height: 24),

            // Car details
            Text('Vehicle Details',
                style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface)),
            const SizedBox(height: 12),
            _DetailCard(rows: [
              _Row('Model', order.carDetails.model),
              _Row('Plate', order.carDetails.plateNumber),
              if (order.carDetails.color != null)
                _Row('Color', order.carDetails.color!),
            ]),
            const SizedBox(height: 24),

            // Appointment details
            Text('Appointment',
                style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface)),
            const SizedBox(height: 12),
            _DetailCard(rows: [
              _Row('Date',
                  DateFormat('EEEE, MMMM dd yyyy').format(order.appointmentDate)),
              _Row('Time', DateFormat('hh:mm a').format(order.appointmentDate)),
              if (order.service != null) _Row('Service', order.service!.title),
              _Row('Amount', '\$${order.totalAmount.toStringAsFixed(2)}'),
              _Row('Status', order.status.toUpperCase()),
            ]),
            const SizedBox(height: 32),

            // Cancel button (only if pending)
            if (order.isPending)
              BlocBuilder<OrdersCubit, OrdersState>(
                builder: (context, state) {
                  final loading = state is OrdersLoading;
                  return SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.error),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: loading
                          ? null
                          : () => _confirmCancel(context, order),
                      child: loading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  color: AppColors.error, strokeWidth: 2))
                          : Text('Cancel Booking',
                              style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.error)),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  void _confirmCancel(BuildContext context, Order order) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Cancel Booking',
            style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
        content: Text('Are you sure you want to cancel this service appointment?',
            style: GoogleFonts.inter()),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Keep it')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(context);
              context
                  .read<OrdersCubit>()
                  .updateOrderStatus(order.id, 'cancelled');
              Navigator.pop(context);
            },
            child: const Text('Cancel Booking'),
          ),
        ],
      ),
    );
  }
}

class _OrderStatusCard extends StatelessWidget {
  final Order order;
  const _OrderStatusCard({required this.order});

  Color get _statusColor {
    switch (order.status) {
      case 'confirmed':
        return const Color(0xFF22C55E);
      case 'in-progress':
        return const Color(0xFF3B82F6);
      case 'completed':
        return AppColors.primary;
      case 'cancelled':
        return AppColors.error;
      default:
        return const Color(0xFFF59E0B);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8))
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(order.service?.title ?? 'Service',
                    style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                const SizedBox(height: 4),
                Text(
                    DateFormat('MMM dd, yyyy • hh:mm a')
                        .format(order.appointmentDate),
                    style:
                        GoogleFonts.inter(fontSize: 13, color: Colors.white70)),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _statusColor.withValues(alpha: 0.20),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _statusColor.withValues(alpha: 0.40)),
            ),
            child: Text(
              order.status.toUpperCase(),
              style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusTimeline extends StatelessWidget {
  final String currentStatus;
  const _StatusTimeline({required this.currentStatus});

  static const _steps = [
    _Step('Pending', Icons.pending_outlined),
    _Step('Confirmed', Icons.check_circle_outline),
    _Step('In Progress', Icons.build_circle_outlined),
    _Step('Completed', Icons.verified_outlined),
  ];

  static const _order = ['pending', 'confirmed', 'in-progress', 'completed'];

  @override
  Widget build(BuildContext context) {
    final idx = _order.indexOf(currentStatus);
    return Row(
      children: List.generate(_steps.length, (i) {
        final done = i <= idx;
        final active = i == idx;
        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: done
                            ? AppColors.primary
                            : AppColors.surfaceContainerHigh,
                        shape: BoxShape.circle,
                        border: active
                            ? Border.all(
                                color: AppColors.primary, width: 2)
                            : null,
                      ),
                      child: Icon(
                        _steps[i].icon,
                        size: 18,
                        color: done ? Colors.white : AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _steps[i].label,
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        fontWeight:
                            active ? FontWeight.w700 : FontWeight.w500,
                        color: done
                            ? AppColors.primary
                            : AppColors.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              if (i < _steps.length - 1)
                Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.only(bottom: 24),
                    color: i < idx
                        ? AppColors.primary
                        : AppColors.surfaceContainerHigh,
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}

class _Step {
  final String label;
  final IconData icon;
  const _Step(this.label, this.icon);
}

class _Row {
  final String label;
  final String value;
  const _Row(this.label, this.value);
}

class _DetailCard extends StatelessWidget {
  final List<_Row> rows;
  const _DetailCard({required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        children: rows.map((r) {
          final isLast = r == rows.last;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(r.label,
                        style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppColors.onSurfaceVariant)),
                    Text(r.value,
                        style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurface)),
                  ],
                ),
              ),
              if (!isLast)
                Divider(height: 1, color: AppColors.outline),
            ],
          );
        }).toList(),
      ),
    );
  }
}
