import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_package/shared_package.dart';
import '../../../core/theme/saathi_theme.dart';
import '../../auth/presentation/auth_controller.dart';

class ProfileScreen extends ConsumerWidget {
  final UserModel user;

  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(GhTokens.spaceLg),
      children: [
        // ── Top Header Identity ──────────────────────────────────────────
        Text(
          'GAAMHAUL • પ્રોફાઈલ',
          style: SaathiTextStyles.labelSm.copyWith(
            color: SaathiColors.primaryContainer,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: GhTokens.spaceXs),
        Text(
          'Profile',
          style: SaathiTextStyles.headlineXl,
        ),
        const SizedBox(height: GhTokens.spaceLg),

        // ── Identity Card ─────────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(GhTokens.spaceLg),
          decoration: BoxDecoration(
            color: SaathiColors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(GhTokens.radiusMd),
            border: Border.all(color: SaathiColors.structuralStroke),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style: SaathiTextStyles.headlineLg,
              ),
              const SizedBox(height: GhTokens.spaceXs),
              Text(
                user.phone,
                style: SaathiTextStyles.bodyMd.copyWith(color: SaathiColors.primary),
              ),
              const SizedBox(height: GhTokens.spaceMd),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: SaathiColors.onSurfaceVariant),
                  const SizedBox(width: GhTokens.spaceXs),
                  Text(
                    '${user.village} • ${user.taluka}',
                    style: SaathiTextStyles.bodySm.copyWith(color: SaathiColors.onSurfaceVariant),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: GhTokens.spaceLg),

        // ── Actions / Settings ────────────────────────────────────────────
        Text(
          'ACCOUNT',
          style: SaathiTextStyles.labelSm.copyWith(
            color: SaathiColors.onSurfaceVariant,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: GhTokens.spaceMd),
        
        // Logout Button
        OutlinedButton.icon(
          onPressed: () {
            ref.read(authControllerProvider.notifier).signOut();
          },
          icon: const Icon(Icons.logout),
          label: const Text('LOGOUT / સાઇન આઉટ'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: GhTokens.spaceMd),
            foregroundColor: SaathiColors.danger,
            side: const BorderSide(color: SaathiColors.danger),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(GhTokens.radiusSm),
            ),
          ),
        ),
        
        const SizedBox(height: GhTokens.spaceLg),
      ],
    );
  }
}
