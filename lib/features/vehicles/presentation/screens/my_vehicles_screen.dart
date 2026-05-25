import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revexa/core/theme/app_colors.dart';

class MyVehiclesScreen extends StatelessWidget {
  const MyVehiclesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('My Vehicles', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700)),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manage your premium fleet with real-time health diagnostics.',
              style: GoogleFonts.inter(fontSize: 13, color: AppColors.onSurfaceVariant, height: 1.5),
            ),
            const SizedBox(height: 20),

            // Vehicle 1
            const _VehicleCard(
              plate: 'B-MW 005',
              make: 'BMW M5 Competition',
              color: 'Marina Bay Blue Metallic',
              status: 'OK',
              statusIcon: Icons.check_circle_outline,
              statusColor: Color(0xFF22C55E),
              statusLabel: 'Engine OK',
              metrics: [
                _Metric(icon: Icons.settings_suggest, label: 'Diagnostics', value: 'Stock'),
              ],
              imageGradient: [Color(0xFF1D3C87), Color(0xFF2563EB)],
            ),
            const SizedBox(height: 16),

            // Vehicle 2
            const _VehicleCard(
              plate: '911-LUX',
              make: 'Porsche 911 Carrera S',
              color: 'GT Silver Metallic',
              status: 'Warning',
              statusIcon: Icons.warning_amber_rounded,
              statusColor: Color(0xFFF59E0B),
              statusLabel: 'Service Soon',
              metrics: [
                _Metric(icon: Icons.tire_repair, label: 'Tire PSI', value: '32 / 34'),
                _Metric(icon: Icons.local_gas_station, label: 'Fuel', value: '82%'),
              ],
              imageGradient: [Color(0xFF334155), Color(0xFF64748B)],
            ),
            const SizedBox(height: 20),

            // Fleet analytics
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.outline),
                boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Icon(Icons.analytics_outlined, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Text('Fleet Analytics', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: Text('View Reports', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
                    ),
                  ]),
                  const SizedBox(height: 16),
                  const Row(children: [
                    _AnalyticChip(label: 'Efficiency', value: '14.2 L/100km'),
                    SizedBox(width: 12),
                    _AnalyticChip(label: 'Active Plans', value: '02'),
                    SizedBox(width: 12),
                    _AnalyticChip(label: 'Global Sync', value: '2 mins ago'),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Add new vehicle
            GestureDetector(
              onTap: () => _showAddVehicleDialog(context),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.20), style: BorderStyle.solid),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.10), shape: BoxShape.circle),
                      child: Icon(Icons.add_circle_outline, color: AppColors.primary, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Add New Vehicle', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary)),
                          Text('Expand your digital garage and unlock premium services.',
                              style: GoogleFonts.inter(fontSize: 12, color: AppColors.onSurfaceVariant, height: 1.4)),
                        ],
                      ),
                    ),
                    Text('Register Now', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddVehicleDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => const _AddVehicleSheet(),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  final String plate;
  final String make;
  final String color;
  final String status;
  final IconData statusIcon;
  final Color statusColor;
  final String statusLabel;
  final List<_Metric> metrics;
  final List<Color> imageGradient;

  const _VehicleCard({
    required this.plate,
    required this.make,
    required this.color,
    required this.status,
    required this.statusIcon,
    required this.statusColor,
    required this.statusLabel,
    required this.metrics,
    required this.imageGradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 12, offset: Offset(0, 4))],
      ),
      child: Column(
        children: [
          // Image / gradient header
          Container(
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: imageGradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Stack(
              children: [
                Positioned(top: -20, right: -20,
                  child: Container(width: 120, height: 120,
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.06), shape: BoxShape.circle))),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
                              child: Text(plate, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 1.0)),
                            ),
                            const SizedBox(height: 8),
                            Text(make, style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white)),
                            Text(color, style: GoogleFonts.inter(fontSize: 12, color: Colors.white70)),
                          ],
                        ),
                      ),
                      const Icon(Icons.directions_car, color: Colors.white24, size: 56),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Status & metrics
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(children: [
                        Icon(statusIcon, color: statusColor, size: 14),
                        const SizedBox(width: 4),
                        Text(statusLabel, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: statusColor)),
                      ]),
                    ),
                    const Spacer(),
                    ...metrics.map((m) => Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: _MetricChip(metric: m),
                    )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Metric {
  final IconData icon;
  final String label;
  final String value;
  const _Metric({required this.icon, required this.label, required this.value});
}

class _MetricChip extends StatelessWidget {
  final _Metric metric;
  const _MetricChip({required this.metric});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(8)),
      child: Row(children: [
        Icon(metric.icon, size: 12, color: AppColors.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(metric.value, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.onSurface)),
      ]),
    );
  }
}

class _AnalyticChip extends StatelessWidget {
  final String label;
  final String value;
  const _AnalyticChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Text(value, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
            Text(label, style: GoogleFonts.inter(fontSize: 10, color: AppColors.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}

class _AddVehicleSheet extends StatelessWidget {
  const _AddVehicleSheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.outline, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 20),
            Text('Register Vehicle', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
            const SizedBox(height: 4),
            Text('Add your vehicle to unlock premium services', style: GoogleFonts.inter(fontSize: 13, color: AppColors.onSurfaceVariant)),
            const SizedBox(height: 24),
            const _SheetField(label: 'Car Model', placeholder: 'e.g. BMW M5 2023'),
            const SizedBox(height: 12),
            const _SheetField(label: 'Plate Number', placeholder: 'e.g. ABC-1234'),
            const SizedBox(height: 12),
            const _SheetField(label: 'Color', placeholder: 'e.g. Marina Bay Blue'),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Add Vehicle', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetField extends StatelessWidget {
  final String label;
  final String placeholder;
  const _SheetField({required this.label, required this.placeholder});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        hintText: placeholder,
        filled: true,
        fillColor: AppColors.surfaceContainerLow,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.outline)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.outline)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.5), width: 2)),
      ),
    );
  }
}
