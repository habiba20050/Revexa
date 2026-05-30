import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:revexa/core/theme/app_colors.dart';

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

  static const _searchOptions = <String, String>{
    'car repair': 'Repair shops',
    'car wash': 'Car wash',
    'tire shop': 'Tires',
    'auto parts': 'Parts',
    'oil change': 'Oil change',
  };

  Future<void> _openOnMaps() async {
    final point = _selectedPoint;
    if (point == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tap the map to choose your area first.'),
          behavior: SnackBarBehavior.floating,
        ),
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
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Nearby Workshops',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Find repair shops & service centers',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.onSurfaceVariant,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Your area',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the map where you are looking for workshops.',
              style: GoogleFonts.inter(fontSize: 12, color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 12),
            Container(
              height: 280,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.outline),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: point ?? _defaultCenter,
                    initialZoom: point != null ? 14 : 11,
                    onTap: (_, latLng) => setState(() => _selectedPoint = latLng),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: const ['a', 'b', 'c'],
                    ),
                    if (point != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: point,
                            width: 48,
                            height: 48,
                            child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            if (point != null) ...[
              const SizedBox(height: 10),
              Text(
                '${point.latitude.toStringAsFixed(5)}, ${point.longitude.toStringAsFixed(5)}',
                style: GoogleFonts.inter(fontSize: 11, color: AppColors.onSurfaceVariant),
              ),
            ],
            const SizedBox(height: 24),
            Text(
              'What are you looking for?',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _searchOptions.entries.map((e) {
                final selected = _searchType == e.key;
                return FilterChip(
                  label: Text(e.value),
                  selected: selected,
                  onSelected: (_) => setState(() => _searchType = e.key),
                  selectedColor: AppColors.primary.withValues(alpha: 0.15),
                  checkmarkColor: AppColors.primary,
                );
              }).toList(),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _openOnMaps,
                icon: const Icon(Icons.map_outlined),
                label: const Text('Open on Google Maps'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Google Maps will show places near the point you selected.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 12, color: AppColors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
