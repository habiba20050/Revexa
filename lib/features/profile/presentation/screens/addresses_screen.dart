import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:revexa/core/error/error_handler.dart';
import 'package:revexa/core/network/api_endpoints.dart';
import 'package:revexa/core/network/dio_client.dart';
import 'package:revexa/core/theme/app_colors.dart';
import 'package:revexa/features/profile/data/models/saved_address_model.dart';
import 'package:revexa/shared/extensions/context_extensions.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  final _titleCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final List<SavedAddress> _savedAddresses = [];
  LatLng? _selectedLocation;
  bool _loading = false;
  bool _fetching = false;

  dynamic _extractResponseData(Response<dynamic> response) {
    final responseData = response.data;
    if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
      return responseData['data'];
    }
    return responseData;
  }

  @override
  void initState() {
    super.initState();
    _loadSavedAddresses();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadSavedAddresses() async {
    setState(() => _fetching = true);
    try {
      final response = await DioClient.instance.dio.get(ApiEndpoints.addresses);
      final rawData = _extractResponseData(response);
      final data = rawData is List<dynamic> ? rawData : <dynamic>[];
      if (!mounted) return;
      setState(() {
        _savedAddresses
          ..clear()
          ..addAll(data.map((e) => SavedAddress.fromJson(e as Map<String, dynamic>)));
      });
    } on DioException catch (e) {
      final failure = ErrorHandler.toFailure(e);
      if (mounted) {
        context.showAppSnackBar(failure.message, isError: true);
      }
    } finally {
      if (mounted) setState(() => _fetching = false);
    }
  }

  Future<void> _addAddress() async {
    if (_titleCtrl.text.trim().isEmpty || _addressCtrl.text.trim().isEmpty || _selectedLocation == null) {
      context.showAppSnackBar(
        'Please enter title, address and select a location on the map.',
        isError: true,
      );
      return;
    }

    setState(() => _loading = true);
    try {
      final response = await DioClient.instance.dio.post(
        ApiEndpoints.addresses,
        data: {
          'title': _titleCtrl.text.trim(),
          'address': _addressCtrl.text.trim(),
          'latitude': _selectedLocation!.latitude,
          'longitude': _selectedLocation!.longitude,
        },
      );
      final rawData = _extractResponseData(response);
      final data = rawData is Map<String, dynamic>
          ? rawData
          : (rawData is List<dynamic> && rawData.isNotEmpty ? rawData.first as Map<String, dynamic> : <String, dynamic>{});
      if (!mounted) return;
      setState(() {
        _savedAddresses.insert(0, SavedAddress.fromJson(data));
        _titleCtrl.clear();
        _addressCtrl.clear();
        _selectedLocation = null;
      });
    } on DioException catch (e) {
      final failure = ErrorHandler.toFailure(e);
      if (mounted) {
        context.showAppSnackBar(failure.message, isError: true);
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openInGoogleMaps(SavedAddress address) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=${address.latitude},${address.longitude}';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        context.showAppSnackBar('Cannot open Google Maps.', isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Saved Locations', style: GoogleFonts.urbanist(fontSize: 18, fontWeight: FontWeight.w700)),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mark a place for the company to visit', style: GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.onSurface)),
            const SizedBox(height: 12),
            Container(
              height: 280,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 4))],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: const LatLng(24.7136, 46.6753),
                    initialZoom: 10,
                    onTap: (tapPosition, point) {
                      setState(() => _selectedLocation = point);
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    ),
                    if (_selectedLocation != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            width: 54,
                            height: 54,
                            point: _selectedLocation!,
                            child: const Icon(Icons.location_on, size: 44, color: Colors.red),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text('Tap the map to select a point', style: GoogleFonts.urbanist(fontSize: 12, color: AppColors.onSurfaceVariant)),
            const SizedBox(height: 24),
            _InputField(label: 'Location title', controller: _titleCtrl),
            const SizedBox(height: 12),
            _InputField(label: 'Address details', controller: _addressCtrl, maxLines: 2),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _loading ? null : _addAddress,
                child: _loading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator.adaptive(valueColor: AlwaysStoppedAnimation(Colors.white), strokeWidth: 2))
                    : Text('Save location', style: GoogleFonts.urbanist(fontSize: 15, fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: 24),
            Text('Saved locations', style: GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.onSurface)),
            const SizedBox(height: 12),
            if (_fetching)
              const Center(child: CircularProgressIndicator.adaptive())
            else if (_savedAddresses.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
                child: Text('No saved locations yet. Add one by selecting a point on the map.', style: GoogleFonts.urbanist(fontSize: 12, color: AppColors.onSurfaceVariant)),
              )
            else
              Column(
                children: _savedAddresses.map((address) => _SavedAddressCard(address: address, onOpen: () => _openInGoogleMaps(address))).toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int maxLines;

  const _InputField({required this.label, required this.controller, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(label, style: GoogleFonts.urbanist(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.secondary)),
        ),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: AppColors.outline)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: AppColors.outline)),
          ),
        ),
      ],
    );
  }
}

class _SavedAddressCard extends StatelessWidget {
  final SavedAddress address;
  final VoidCallback onOpen;

  const _SavedAddressCard({required this.address, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 3))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.place, color: Color(0xFF174EA6), size: 20),
              const SizedBox(width: 8),
              Expanded(child: Text(address.title, style: GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.onSurface))),
            ],
          ),
          const SizedBox(height: 8),
          Text(address.address, style: GoogleFonts.urbanist(fontSize: 12, color: AppColors.onSurfaceVariant, height: 1.4)),
          const SizedBox(height: 12),
          Row(
            children: [
              Text('Lat: ${address.latitude.toStringAsFixed(5)}', style: GoogleFonts.urbanist(fontSize: 11, color: AppColors.onSurfaceVariant)),
              const SizedBox(width: 12),
              Text('Lng: ${address.longitude.toStringAsFixed(5)}', style: GoogleFonts.urbanist(fontSize: 11, color: AppColors.onSurfaceVariant)),
              const Spacer(),
              GestureDetector(
                onTap: onOpen,
                child: Row(
                  children: [
                    Text('Open in Maps', style: GoogleFonts.urbanist(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                    const SizedBox(width: 4),
                    Icon(Icons.launch, size: 16, color: AppColors.primary),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
