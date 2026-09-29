import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_package/shared_package.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../request_form_controller.dart';
import '../../../../core/theme/customer_theme.dart';

class LocationStep extends ConsumerStatefulWidget {
  const LocationStep({super.key});

  @override
  ConsumerState<LocationStep> createState() => _LocationStepState();
}

class _LocationStepState extends ConsumerState<LocationStep> {
  final MapController _mapController = MapController();
  LatLng _pickupCenter = const LatLng(22.2587, 71.1924);
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(requestFormControllerProvider);
      if (state.pickupLocation != null) {
        setState(() {
          _pickupCenter = LatLng(state.pickupLocation!.latitude, state.pickupLocation!.longitude);
        });
      } else {
        ref.read(requestFormControllerProvider.notifier)
           .setPickupLocation(GeoPoint(_pickupCenter.latitude, _pickupCenter.longitude));
      }
    });
  }

  Future<void> _requestLocation() async {
    setState(() => _isLoadingLocation = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location services are disabled.')));
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permissions are denied.')));
          return;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permissions are permanently denied.')));
        return;
      } 

      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _pickupCenter = LatLng(position.latitude, position.longitude);
        _mapController.move(_pickupCenter, 15.0);
      });
      ref.read(requestFormControllerProvider.notifier).setPickupLocation(GeoPoint(position.latitude, position.longitude));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoadingLocation = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.stepPickupTitle, style: CustomerTextStyles.headlineLg),
        const SizedBox(height: GhTokens.spaceMd),
        
        // Premium Map Preview
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(GhTokens.radiusLg),
              border: Border.all(color: CustomerColors.outlineVariant),
              boxShadow: GhTokens.shadowCardCustomer,
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _pickupCenter,
                    initialZoom: 14.0,
                    onPositionChanged: (position, hasGesture) {
                      if (hasGesture) {
                        ref.read(requestFormControllerProvider.notifier)
                           .setPickupLocation(GeoPoint(position.center.latitude, position.center.longitude));
                      }
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.gaamhaul.customer',
                    ),
                  ],
                ),
                const Center(
                  child: Icon(Icons.location_pin, size: 48, color: CustomerColors.error),
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton(
                    backgroundColor: CustomerColors.surfaceContainerLowest,
                    foregroundColor: CustomerColors.primaryContainer,
                    onPressed: _isLoadingLocation ? null : _requestLocation,
                    child: _isLoadingLocation 
                        ? const CircularProgressIndicator() 
                        : const Icon(Icons.my_location),
                  ),
                )
              ],
            ),
          ),
        ),
        
        const SizedBox(height: GhTokens.spaceLg),
        
        // Location Actions
        Container(
          padding: const EdgeInsets.all(GhTokens.spaceMd),
          decoration: BoxDecoration(
            color: CustomerColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(GhTokens.radiusMd),
            border: Border.all(color: CustomerColors.outlineVariant),
          ),
          child: Row(
            children: [
              const Icon(Icons.my_location, color: CustomerColors.secondary),
              const SizedBox(width: GhTokens.spaceMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Current Location', style: CustomerTextStyles.titleMd),
                    Text('Drag map to adjust', style: CustomerTextStyles.bodySm),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: GhTokens.spaceMd),
        
        Text(l10n.stepDropTitle, style: CustomerTextStyles.headlineSm),
        const SizedBox(height: GhTokens.spaceSm),
        Container(
          padding: const EdgeInsets.all(GhTokens.spaceMd),
          decoration: BoxDecoration(
            color: CustomerColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(GhTokens.radiusMd),
            border: Border.all(color: CustomerColors.outlineVariant),
          ),
          child: Row(
            children: [
              const Icon(Icons.add_location_alt_outlined, color: CustomerColors.onSurfaceVariant),
              const SizedBox(width: GhTokens.spaceMd),
              Expanded(
                child: Text(
                  'Skip for local hire (Optional)', 
                  style: CustomerTextStyles.bodyMd.copyWith(color: CustomerColors.onSurfaceVariant),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
