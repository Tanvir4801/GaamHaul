import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_package/shared_package.dart';
import 'vehicle_registration_controller.dart';

class VehicleRegistrationScreen extends ConsumerStatefulWidget {
  const VehicleRegistrationScreen({super.key});

  @override
  ConsumerState<VehicleRegistrationScreen> createState() => _VehicleRegistrationScreenState();
}

class _VehicleRegistrationScreenState extends ConsumerState<VehicleRegistrationScreen> {
  int _currentStep = 0;
  final _picker = ImagePicker();
  final _regController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _regController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(bool isVehicle) async {
    final picked = await _picker.pickImage(source: ImageSource.camera, imageQuality: 70);
    if (picked != null) {
      if (isVehicle) {
        ref.read(vehicleRegistrationControllerProvider.notifier).setVehiclePhoto(File(picked.path));
      } else {
        ref.read(vehicleRegistrationControllerProvider.notifier).setRcPhoto(File(picked.path));
      }
    }
  }

  void _next() {
    final state = ref.read(vehicleRegistrationControllerProvider);

    if (_currentStep == 0 && state.type == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select a vehicle type')));
      return;
    }
    
    if (_currentStep == 1) {
      if (!_formKey.currentState!.validate()) return;
      ref.read(vehicleRegistrationControllerProvider.notifier).setRegistrationNumber(_regController.text);
    }
    
    if (_currentStep == 2 && state.vehiclePhoto == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please capture a vehicle photo')));
      return;
    }

    if (_currentStep == 3 && state.rcPhoto == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please capture the RC document')));
      return;
    }

    if (_currentStep == 4) {
      _submit();
      return;
    }

    setState(() {
      _currentStep++;
    });
  }

  void _previous() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _submit() async {
    final success = await ref.read(vehicleRegistrationControllerProvider.notifier).submit();
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vehicle Registered Successfully!')),
      );
      Navigator.pop(context); // Return to home
    } else if (mounted) {
      final state = ref.read(vehicleRegistrationControllerProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.error ?? 'Failed to register')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(vehicleRegistrationControllerProvider);

    if (state.isLoading) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Uploading documents and registering...'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Vehicle'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _previous,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _buildStepContent(state),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _next,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: Text(_currentStep == 4 ? 'Submit' : 'Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent(VehicleRegistrationState state) {
    switch (_currentStep) {
      case 0:
        return _buildTypeSelection(state);
      case 1:
        return _buildRegistrationInput();
      case 2:
        return _buildPhotoUpload(
          title: 'Vehicle Photo',
          subtitle: 'Take a clear picture of your vehicle',
          file: state.vehiclePhoto,
          onTap: () => _pickImage(true),
        );
      case 3:
        return _buildPhotoUpload(
          title: 'RC Document',
          subtitle: 'Take a clear picture of your RC document',
          file: state.rcPhoto,
          onTap: () => _pickImage(false),
        );
      case 4:
        return _buildReview(state);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTypeSelection(VehicleRegistrationState state) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Select Vehicle Type', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ...VehicleType.values.map((type) {
          final isSelected = state.type == type;
          return Card(
            color: isSelected ? Colors.blue.shade100 : null,
            child: ListTile(
              title: Text(type.value.toUpperCase()), // Will want a nice labeler in a real app
              trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.blue) : null,
              onTap: () {
                ref.read(vehicleRegistrationControllerProvider.notifier).setType(type);
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildRegistrationInput() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Registration Number', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Enter the vehicle registration number (e.g. GJ01AB1234)'),
            const SizedBox(height: 24),
            TextFormField(
              controller: _regController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Registration Number',
              ),
              textCapitalization: TextCapitalization.characters,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Registration number is required';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoUpload({
    required String title,
    required String subtitle,
    required File? file,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(subtitle),
          const SizedBox(height: 24),
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: file != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(file, fit: BoxFit.cover),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('Tap to open camera'),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReview(VehicleRegistrationState state) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Review Registration', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        ListTile(
          title: const Text('Type'),
          subtitle: Text(state.type?.value.toUpperCase() ?? ''),
        ),
        ListTile(
          title: const Text('Registration Number'),
          subtitle: Text(state.registrationNumber),
        ),
        const ListTile(
          title: Text('Vehicle Photo'),
          subtitle: Text('Provided'),
          trailing: Icon(Icons.check, color: Colors.green),
        ),
        const ListTile(
          title: Text('RC Document'),
          subtitle: Text('Provided'),
          trailing: Icon(Icons.check, color: Colors.green),
        ),
      ],
    );
  }
}
