import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../request_form_controller.dart';

class LocationStep extends ConsumerStatefulWidget {
  const LocationStep({super.key});

  @override
  ConsumerState<LocationStep> createState() => _LocationStepState();
}

class _LocationStepState extends ConsumerState<LocationStep> {
  final MapController _mapController = MapController();
  // Default to Gujarat center
  LatLng _center = const LatLng(22.2587, 71.1924);
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    // Set initial state value if it exists, otherwise use default
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(requestFormControllerProvider);
      if (state.pickupLocation != null) {
        setState(() {
          _center = LatLng(state.pickupLocation!.latitude, state.pickupLocation!.longitude);
        });
      } else {
        // We set the default location in the provider so validation passes if user just clicks next
        ref.read(requestFormControllerProvider.notifier)
           .setPickupLocation(GeoPoint(_center.latitude, _center.longitude));
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
        _center = LatLng(position.latitude, position.longitude);
        _mapController.move(_center, 15.0);
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Where do you need it?', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const Text('Drag map to set pickup location'),
        const SizedBox(height: 16),
        Expanded(
          child: Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _center,
                  initialZoom: 12.0,
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
                child: Icon(Icons.location_pin, size: 48, color: Colors.red),
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: FloatingActionButton(
                  onPressed: _isLoadingLocation ? null : _requestLocation,
                  child: _isLoadingLocation 
                      ? const CircularProgressIndicator(color: Colors.white) 
                      : const Icon(Icons.my_location),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
