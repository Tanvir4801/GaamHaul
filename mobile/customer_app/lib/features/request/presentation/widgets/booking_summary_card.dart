import 'package:flutter/material.dart';
import 'package:shared_package/shared_package.dart';
import '../../../../core/theme/customer_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookingSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final VoidCallback onEdit;

  const BookingSummaryCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(bottom: GhTokens.spaceMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title.toUpperCase(),
                style: CustomerTextStyles.labelSm.copyWith(
                  color: CustomerColors.onSurfaceVariant,
                  letterSpacing: 1.2,
                ),
              ),
              GestureDetector(
                onTap: onEdit,
                child: Text(
                  l10n.editLabel,
                  style: CustomerTextStyles.labelMd.copyWith(color: CustomerColors.secondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: GhTokens.spaceXs),
          Text(
            value,
            style: CustomerTextStyles.titleLg,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle!,
              style: CustomerTextStyles.bodySm.copyWith(color: CustomerColors.onSurfaceVariant),
            ),
          ],
          const SizedBox(height: GhTokens.spaceMd),
          const Divider(height: 1),
        ],
      ),
    );
  }
}
