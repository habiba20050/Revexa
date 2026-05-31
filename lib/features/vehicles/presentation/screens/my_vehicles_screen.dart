import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revexa/core/theme/app_colors.dart';
import 'package:revexa/core/constants/app_constants.dart';

class MyVehiclesScreen extends StatelessWidget {
  const MyVehiclesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _VehiclesAppBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    'Manage your premium fleet with real-time health diagnostics and maintenance tracking.',
                    style: GoogleFonts.inter(fontSize: 13, color: AppColors.onSurfaceVariant, height: 1.5),
                  ),
                  const SizedBox(height: 20),

                const  _VehicleCard(
                    plate: 'B-MW 005',
                    make: 'BMW M5 Competition',
                    color: 'Marina Bay Blue Metallic',
                    engineStatus: 'ENGINE OK',
                    engineColor:  Color(0xFF22C55E),
                    diagnosticsLabel: 'STOCK DIAGNOSTICS',
                    imageUrl: AppConstants.imgMyVehicles1,
                    gradientColors:  [Color(0xFF1A2540), Color(0xFF243060)],
                    warningLabel: null,
                    metrics:  [],
                  ),
                  const SizedBox(height: 16),

                  _AddVehicleCard(),
                  const SizedBox(height: 16),

               const   _VehicleCard(
                    plate: '911-LUX',
                    make: 'Porsche 911 Carrera S',
                    color: 'GT Silver Metallic',
                    engineStatus: null,
                    engineColor: null,
                    diagnosticsLabel: null,
                    imageUrl: AppConstants.imgMyVehicles2,
                    gradientColors:  [Color(0xFF2C3E50), Color(0xFF4A5568)],
                    warningLabel: 'SERVICE IN 500KM',
                    metrics:  [
                      _MetricData(label: 'TIRE PRESSURE', value: '32 PSI / 34 PSI', hasIndicator: true),
                      _MetricData(label: 'FUEL LEVEL', value: '82%', hasIndicator: true),
                    ],
                  ),
                  const SizedBox(height: 20),

                  _FleetAnalyticsCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VehiclesAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 20,
        right: 20,
        bottom: 14,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.arrow_back, color: AppColors.onSurface, size: 20),
            ),
          ),
          const SizedBox(width: 12),
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: const Icon(Icons.grid_view_rounded, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 8),
              Text(
                'Revexa',
                style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
            ],
          ),
          const Spacer(),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.10),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.20), width: 2),
            ),
            child: Center(
              child: Text(
                'U',
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricData {
  final String label;
  final String value;
  final bool hasIndicator;
  const _MetricData({required this.label, required this.value, required this.hasIndicator});
}

class _VehicleCard extends StatelessWidget {
  final String plate;
  final String make;
  final String color;
  final String? engineStatus;
  final Color? engineColor;
  final String? diagnosticsLabel;
  final String? imageUrl;
  final List<Color> gradientColors;
  final String? warningLabel;
  final List<_MetricData> metrics;

  const _VehicleCard({
    required this.plate,
    required this.make,
    required this.color,
    required this.engineStatus,
    required this.engineColor,
    required this.diagnosticsLabel,
    required this.imageUrl,
    required this.gradientColors,
    required this.warningLabel,
    required this.metrics,
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
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: SizedBox(
              height: 150,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (imageUrl != null)
                    Image.asset(imageUrl!, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: gradientColors, begin: Alignment.topLeft, end: Alignment.bottomRight),
                          ),
                        ))
                  else
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: gradientColors, begin: Alignment.topLeft, end: Alignment.bottomRight),
                      ),
                    ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x44000000), Color(0xCC000000)],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.45),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        plate,
                        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 1.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(make, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
                          const SizedBox(height: 2),
                          Text(color, style: GoogleFonts.inter(fontSize: 12, color: AppColors.onSurfaceVariant)),
                        ],
                      ),
                    ),
                    if (warningLabel != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF7ED),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.warning_amber_rounded, color: Color(0xFFF59E0B), size: 12),
                            const SizedBox(width: 4),
                            Text(
                              warningLabel!,
                              style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFFF59E0B)),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),

                if (engineStatus != null || diagnosticsLabel != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (engineStatus != null)
                        _StatusBadge(
                          label: engineStatus!,
                          color: engineColor ?? const Color(0xFF22C55E),
                          icon: Icons.check_circle_outline,
                        ),
                      if (engineStatus != null && diagnosticsLabel != null)
                        const SizedBox(width: 8),
                      if (diagnosticsLabel != null)
                        _StatusBadge(
                          label: diagnosticsLabel!,
                          color: AppColors.primary,
                          icon: Icons.settings_suggest_outlined,
                        ),
                    ],
                  ),
                ],

                if (metrics.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Row(
                    children: metrics.map((m) => Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: metrics.last == m ? 0 : 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(m.label, style: GoogleFonts.inter(fontSize: 10, color: AppColors.onSurfaceVariant, letterSpacing: 0.3)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(m.value, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
                                if (m.hasIndicator) ...[
                                  const SizedBox(width: 6),
                                  Container(width: 7, height: 7, decoration: const BoxDecoration(color: Color(0xFF22C55E), shape: BoxShape.circle)),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    )).toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;

  const _StatusBadge({required this.label, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 13),
          const SizedBox(width: 4),
          Text(label, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }
}

class _AddVehicleCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: AppColors.primary.withValues(alpha: 0.30), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 26),
          ),
          const SizedBox(height: 14),
          Text(
            'Add New Vehicle',
            style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white),
          ),
          const SizedBox(height: 6),
          Text(
            'Expand your digital garage and unlock premium concierge services for your new car.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 12, color: Colors.white.withValues(alpha: 0.75), height: 1.5),
          ),
          const SizedBox(height: 18),
          GestureDetector(
            onTap: () => _showAddVehicleSheet(context),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  'Register Now',
                  style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddVehicleSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => const _AddVehicleSheet(),
    );
  }
}

class _FleetAnalyticsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.analytics_outlined, color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: 10),
              Text('Fleet Analytics', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
            ],
          ),
          const SizedBox(height: 16),
          const _AnalyticRow(label: 'Average Fleet Efficiency', value: '14.2 L/100km'),
          Divider(color: AppColors.outline, height: 20),
          const _AnalyticRow(label: 'Last Global Sync', value: '2 mins ago'),
          Divider(color: AppColors.outline, height: 20),
          const _AnalyticRow(label: 'Active Maintenance Plans', value: '02'),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.outline),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bar_chart_rounded, color: AppColors.primary, size: 18),
                  const SizedBox(width: 8),
                  Text('View Detailed Reports', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnalyticRow extends StatelessWidget {
  final String label;
  final String value;
  const _AnalyticRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 13, color: AppColors.onSurfaceVariant)),
        Text(value, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
      ],
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
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(color: AppColors.outline, borderRadius: BorderRadius.circular(2)),
              ),
            ),
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
