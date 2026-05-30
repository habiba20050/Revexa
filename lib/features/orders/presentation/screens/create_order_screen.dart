import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:revexa/core/theme/app_colors.dart';
import 'package:revexa/core/constants/app_routes.dart';
import 'package:revexa/features/products/data/models/product_model.dart';
import 'package:revexa/features/services/data/models/service_model.dart';
import 'package:latlong2/latlong.dart';
import 'package:revexa/features/orders/data/models/order_model.dart';
import 'package:revexa/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:revexa/shared/widgets/booking_location_section.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _modelCtrl = TextEditingController();
  final _plateCtrl = TextEditingController();
  final _colorCtrl = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  LatLng? _serviceLocation;
  String _locationAddress = '';

  @override
  void dispose() {
    _modelCtrl.dispose();
    _plateCtrl.dispose();
    _colorCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 60)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  void _submit(BuildContext context, Service service) {
    if (!_formKey.currentState!.validate()) return;
    if (_serviceLocation == null || _locationAddress.trim().length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select your car location on the map and enter the parking address.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select appointment date and time'), behavior: SnackBarBehavior.floating),
      );
      return;
    }
    final appointment = DateTime(
      _selectedDate!.year, _selectedDate!.month, _selectedDate!.day,
      _selectedTime!.hour, _selectedTime!.minute,
    );
    context.read<OrdersCubit>().createOrder(
      productId: service.id,
      serviceName: service.name,
      carDetails: CarDetails(
        model: _modelCtrl.text.trim(),
        plateNumber: _plateCtrl.text.trim(),
        color: _colorCtrl.text.trim().isEmpty ? null : _colorCtrl.text.trim(),
      ),
      appointmentDate: appointment,
      location: BookingLocation(
        title: 'Service location',
        address: _locationAddress.trim(),
        latitude: _serviceLocation!.latitude,
        longitude: _serviceLocation!.longitude,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rawArgs = ModalRoute.of(context)!.settings.arguments;
    final item = rawArgs is Map ? (rawArgs['service'] ?? rawArgs['product'] ?? rawArgs['item']) : rawArgs;
    final serviceTitle = item is Product
        ? item.title
        : item is Service
            ? item.title
            : 'Service';
    final servicePrice = item is Product
        ? item.price
        : item is Service
            ? item.price
            : 0.0;
    final bookingService = item is Service
        ? item
        : item is Product
            ? Service(
                id: item.id,
                name: item.title,
                description: item.description,
                price: item.price,
                category: 'product',
              )
            : Service(
                id: 'local-booking',
                name: serviceTitle,
                description: '',
                price: servicePrice,
                category: 'general',
              );

    return BlocListener<OrdersCubit, OrdersState>(
      listener: (context, state) {
        if (state is OrderCreated) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => _ConfirmationDialog(order: state.order, serviceTitle: serviceTitle),
          );
        } else if (state is OrdersError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text('Book Service', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700)),
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.onSurface,
          elevation: 0,
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Service summary card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48, height: 48,
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.build_circle_outlined, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(serviceTitle, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                            Text('\$${servicePrice.toStringAsFixed(0)}',
                                style: GoogleFonts.inter(fontSize: 13, color: AppColors.neon, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Car details
                Text('Car Details', style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
                const SizedBox(height: 16),
                _OrderField(label: 'Car Model', placeholder: 'e.g. BMW M5 Competition 2023', controller: _modelCtrl,
                    validator: (v) => v == null || v.trim().length < 2 ? 'Required' : null),
                const SizedBox(height: 12),
                _OrderField(label: 'Plate Number', placeholder: 'e.g. ABC-1234', controller: _plateCtrl,
                    validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
                const SizedBox(height: 12),
                _OrderField(label: 'Color (Optional)', placeholder: 'e.g. Marina Bay Blue', controller: _colorCtrl),
                const SizedBox(height: 28),

                BookingLocationSection(
                  selectedPoint: _serviceLocation,
                  addressText: _locationAddress,
                  onPointSelected: (p) => setState(() => _serviceLocation = p),
                  onAddressChanged: (v) => _locationAddress = v,
                ),
                const SizedBox(height: 28),

                // Appointment
                Text('Appointment', style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _DateTimeSelector(
                        label: 'Date',
                        icon: Icons.calendar_today_outlined,
                        value: _selectedDate != null ? DateFormat('MMM dd, yyyy').format(_selectedDate!) : null,
                        placeholder: 'Select date',
                        onTap: _pickDate,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _DateTimeSelector(
                        label: 'Time',
                        icon: Icons.access_time,
                        value: _selectedTime?.format(context),
                        placeholder: 'Select time',
                        onTap: _pickTime,
                      ),
                    ),
                  ],
                ),

                // Quick time slots
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ['9:00 AM', '11:00 AM', '2:00 PM', '4:30 PM'].map((t) {
                    return GestureDetector(
                      onTap: () {
                        final parts = t.split(':');
                        var h = int.parse(parts[0]);
                        final m = int.parse(parts[1].split(' ')[0]);
                        if (t.contains('PM') && h != 12) h += 12;
                        setState(() => _selectedTime = TimeOfDay(hour: h, minute: m));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: _selectedTime?.format(context) == t ? AppColors.primary : AppColors.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.outline),
                        ),
                        child: Text(t, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600,
                            color: _selectedTime?.format(context) == t ? Colors.white : AppColors.onSurface)),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BlocBuilder<OrdersCubit, OrdersState>(
          builder: (context, state) {
            final isLoading = state is OrdersLoading;
            return Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              color: AppColors.surface,
              child: SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: isLoading ? null : () => _submit(context, bookingService),
                  child: isLoading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          const Icon(Icons.event_available_outlined, size: 20),
                          const SizedBox(width: 8),
                          Text('Confirm Booking', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
                        ]),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _OrderField extends StatelessWidget {
  final String label;
  final String placeholder;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const _OrderField({required this.label, required this.placeholder, required this.controller, this.validator});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(label, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.secondary)),
        ),
        TextFormField(
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: GoogleFonts.inter(color: AppColors.onSurfaceVariant.withValues(alpha: 0.5), fontSize: 14),
            filled: true, fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.outline)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.outline)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.5), width: 2)),
            errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.error)),
          ),
        ),
      ],
    );
  }
}

class _DateTimeSelector extends StatelessWidget {
  final String label;
  final IconData icon;
  final String? value;
  final String placeholder;
  final VoidCallback onTap;

  const _DateTimeSelector({required this.label, required this.icon, required this.value, required this.placeholder, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(label, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.secondary)),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: value != null ? AppColors.primary.withValues(alpha: 0.4) : AppColors.outline),
            ),
            child: Row(
              children: [
                Icon(icon, size: 16, color: value != null ? AppColors.primary : AppColors.onSurfaceVariant),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    value ?? placeholder,
                    style: GoogleFonts.inter(fontSize: 13, color: value != null ? AppColors.onSurface : AppColors.onSurfaceVariant),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ConfirmationDialog extends StatelessWidget {
  final Order order;
  final String serviceTitle;
  const _ConfirmationDialog({required this.order, required this.serviceTitle});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72, height: 72,
              decoration: BoxDecoration(color: const Color(0xFF22C55E).withValues(alpha: 0.10), shape: BoxShape.circle),
              child: const Icon(Icons.check_circle_rounded, color: Color(0xFF22C55E), size: 40),
            ),
            const SizedBox(height: 20),
            Text('Booking Confirmed!', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
            const SizedBox(height: 8),
            Text(
              'Your $serviceTitle appointment has been booked successfully.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 14, color: AppColors.onSurfaceVariant, height: 1.5),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(12)),
              child: Column(children: [
                _ConfirmRow(label: 'Service', value: serviceTitle),
                const SizedBox(height: 8),
                _ConfirmRow(label: 'Date', value: DateFormat('MMM dd, yyyy hh:mm a').format(order.appointmentDate)),
                const SizedBox(height: 8),
                _ConfirmRow(label: 'Amount', value: '\$${order.totalAmount.toStringAsFixed(0)}'),
                const SizedBox(height: 8),
                const _ConfirmRow(label: 'Status', value: 'Pending'),
              ]),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).popUntil((r) => r.settings.name == AppRoutes.home);
                },
                child: Text('View My Bookings', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfirmRow extends StatelessWidget {
  final String label;
  final String value;
  const _ConfirmRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 13, color: AppColors.onSurfaceVariant)),
        Text(value, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.onSurface)),
      ],
    );
  }
}
