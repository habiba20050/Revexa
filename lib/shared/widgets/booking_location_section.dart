import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:revexa/core/network/api_endpoints.dart';
import 'package:revexa/core/network/dio_client.dart';
import 'package:revexa/core/theme/app_colors.dart';
import 'package:revexa/features/profile/data/models/saved_address_model.dart';

/// Map + address for where the car is parked during service booking.
class BookingLocationSection extends StatefulWidget {
  final LatLng? selectedPoint;
  final String? addressText;
  final ValueChanged<LatLng> onPointSelected;
  final ValueChanged<String> onAddressChanged;

  const BookingLocationSection({
    super.key,
    required this.selectedPoint,
    required this.addressText,
    required this.onPointSelected,
    required this.onAddressChanged,
  });

  @override
  State<BookingLocationSection> createState() => _BookingLocationSectionState();
}

class _BookingLocationSectionState extends State<BookingLocationSection> {
  final _addressCtrl = TextEditingController();
  List<SavedAddress> _saved = [];
  bool _loadingAddresses = false;

  @override
  void initState() {
    super.initState();
    _addressCtrl.text = widget.addressText ?? '';
    _loadAddresses();
  }

  @override
  void didUpdateWidget(BookingLocationSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.addressText != oldWidget.addressText &&
        widget.addressText != _addressCtrl.text) {
      _addressCtrl.text = widget.addressText ?? '';
    }
  }

  @override
  void dispose() {
    _addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadAddresses() async {
    setState(() => _loadingAddresses = true);
    try {
      final response = await DioClient.instance.dio.get(ApiEndpoints.addresses);
      final body = response.data;
      dynamic raw = body;
      if (body is Map && body['data'] != null) raw = body['data'];
      if (raw is List) {
        _saved = raw
            .map((e) => SavedAddress.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {
      _saved = [];
    } finally {
      if (mounted) setState(() => _loadingAddresses = false);
    }
  }

  void _selectSaved(SavedAddress address) {
    widget.onPointSelected(LatLng(address.latitude, address.longitude));
    _addressCtrl.text = address.address;
    widget.onAddressChanged(address.address);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final point = widget.selectedPoint;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Car parking location',
          style: GoogleFonts.inter(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Tap the map where your car is parked, then enter the address.',
          style: GoogleFonts.inter(fontSize: 12, color: AppColors.onSurfaceVariant),
        ),
        const SizedBox(height: 12),
        Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.outline),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: FlutterMap(
              options: MapOptions(
                initialCenter: point ?? const LatLng(30.0444, 31.2357),
                initialZoom: point != null ? 14 : 10,
                onTap: (_, latLng) => widget.onPointSelected(latLng),
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
        const SizedBox(height: 12),
        TextField(
          controller: _addressCtrl,
          onChanged: widget.onAddressChanged,
          maxLines: 2,
          decoration: InputDecoration(
            labelText: 'Parking address',
            hintText: 'e.g. 90th Street, Building 5, Cairo',
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        if (_loadingAddresses)
          const Padding(
            padding: EdgeInsets.only(top: 12),
            child: LinearProgressIndicator(),
          )
        else if (_saved.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            'Saved locations',
            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _saved.map((a) {
              return ActionChip(
                label: Text(a.title),
                onPressed: () => _selectSaved(a),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
