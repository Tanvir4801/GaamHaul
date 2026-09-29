import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/auth_state.dart';
import 'auth_controller.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _verify() {
    if (_formKey.currentState!.validate()) {
      final state = ref.read(authControllerProvider);
      if (state is AuthOtpSent) {
        ref.read(authControllerProvider.notifier).verifyOtp(
              state.verificationId,
              _otpController.text.trim(),
            );
      }
    }
  }

  void _resendOtp() {
    final state = ref.read(authControllerProvider);
    if (state is AuthOtpSent) {
      ref.read(authControllerProvider.notifier).sendOtp(state.phoneNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    String phoneStr = '';
    if (authState is AuthOtpSent) {
      phoneStr = authState.phoneNumber;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'OTP sent to $phoneStr',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '6-digit OTP',
                  border: OutlineInputBorder(),
                ),
                maxLength: 6,
                validator: (value) {
                  if (value == null || value.trim().length != 6) {
                    return 'Enter a valid 6-digit OTP';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _verify,
                child: const Text('Verify'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _resendOtp,
                child: const Text('Resend OTP'),
              ),
              TextButton(
                onPressed: () {
                  ref.read(authControllerProvider.notifier).signOut();
                },
                child: const Text('Change Number'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
