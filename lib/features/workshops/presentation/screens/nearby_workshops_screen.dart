import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:revexa/core/theme/app_colors.dart';
import 'package:revexa/shared/extensions/context_extensions.dart';

/// Standalone screen to pick an area and open Google Maps for nearby workshops.
class NearbyWorkshopsScreen extends StatefulWidget {
  const NearbyWorkshopsScreen({super.key});

  @override
  State<NearbyWorkshopsScreen> createState() => _NearbyWorkshopsScreenState();
}

class _NearbyWorkshopsScreenState extends State<NearbyWorkshopsScreen> {
  static const _defaultCenter = LatLng(30.0444, 31.2357);

  LatLng? _selectedPoint;
  String _searchType = 'car repair';

  static const _searchOptions = <String, ({String label, IconData icon})>{
    'car repair': (label: 'Repair Shop', icon: Icons.build_rounded),
    'car wash': (label: 'Car Wash', icon: Icons.local_car_wash_rounded),
    'tire shop': (label: 'Tires', icon: Icons.tire_repair),
    'auto parts': (label: 'Parts', icon: Icons.settings_outlined),
    'oil change': (label: 'Oil Change', icon: Icons.water_drop_outlined),
  };

  Future<void> _openOnMaps() async {
    final point = _selectedPoint;
    if (point == null) {
      context.showAppSnackBar(
        'Tap the map to choose your area first.',
        isError: true,
      );
      return;
    }
    final query = Uri.encodeComponent(_searchType);
    final url =
        'https://www.google.com/maps/search/$query/@${point.latitude},${point.longitude},14z';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final point = _selectedPoint;
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
          'Nearby Workshops',
          style: GoogleFonts.urbanist(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.outline),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero descriptor
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.map_rounded, color: AppColors.primary, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Find Nearby Workshops',
                          style: GoogleFonts.urbanist(
                            fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Tap the map to select your area, then open in Google Maps.',
                          style: GoogleFonts.urbanist(
                            fontSize: 12, color: AppColors.onSurfaceVariant, height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Map section header
            Text(
              'Select your area',
              style: GoogleFonts.urbanist(
                fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 10),

            // Map container
            Container(
              height: 260,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.outline),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: point ?? _defaultCenter,
                    initialZoom: point != null ? 14 : 11,
                    onTap: (_, latLng) => setState(() => _selectedPoint = latLng),
                  ),
                  children: [
                    TileLayer(
                      // Single canonical OSM tile URL — no subdomain rotation.
                      // Subdomain rotation is deprecated per OSM operations
                      // issue #737 and generates console warnings in flutter_map.
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.revexa.app',
                    ),
                    if (point != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: point,
                            width: 48,
                            height: 48,
                            child: Icon(
                              Icons.location_on,
                              color: AppColors.error,
                              size: 40,
                              shadows: [
                                Shadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 8),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),

            // Selected point status
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              child: point != null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 14),
                          const SizedBox(width: 6),
                          Text(
                            'Area selected: ${point.latitude.toStringAsFixed(4)}, ${point.longitude.toStringAsFixed(4)}',
                            style: GoogleFonts.urbanist(
                              fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Icon(Icons.touch_app_rounded, color: AppColors.onSurfaceVariant, size: 14),
                          const SizedBox(width: 6),
                          Text(
                            'Tap anywhere on the map to pin your location',
                            style: GoogleFonts.urbanist(
                              fontSize: 11, color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),

            const SizedBox(height: 28),

            // Service type section
            Text(
              'What are you looking for?',
              style: GoogleFonts.urbanist(
                fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _searchOptions.entries.map((e) {
                final selected = _searchType == e.key;
                return GestureDetector(
                  onTap: () => setState(() => _searchType = e.key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected ? AppColors.primary : AppColors.outline,
                        width: selected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          e.value.icon,
                          size: 15,
                          color: selected ? Colors.white : AppColors.onSurfaceVariant,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          e.value.label,
                          style: GoogleFonts.urbanist(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: selected ? Colors.white : AppColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            // CTA button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: _openOnMaps,
                icon: const Icon(Icons.map_outlined, size: 20),
                label: Text(
                  'Open on Google Maps',
                  style: GoogleFonts.urbanist(fontSize: 15, fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                'Google Maps will show places near the point you selected.',
                textAlign: TextAlign.center,
                style: GoogleFonts.urbanist(
                  fontSize: 12, color: AppColors.onSurfaceVariant, height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

