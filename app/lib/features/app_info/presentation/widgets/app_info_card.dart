import 'package:flutter/material.dart';
import '../../../../core/design_system/design_system.dart';
import '../../domain/entities/app_info_entity.dart';
import 'app_info_row.dart';

/// Widget that displays app information in a card format
class AppInfoCard extends StatelessWidget {
  /// Creates an app info card with the provided app information
  const AppInfoCard({
    required this.appInfo, super.key,
  });

  /// The app information to display
  final AppInfoEntity appInfo;

  @override
  Widget build(BuildContext context) => Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppInfoRow(
              icon: Icons.app_registration,
              label: 'App Name',
              value: appInfo.appName,
            ),
            const SizedBox(height: AppSpacing.md),
            AppInfoRow(
              icon: Icons.archive_outlined,
              label: 'Package Name',
              value: appInfo.packageName,
            ),
            const SizedBox(height: AppSpacing.md),
            AppInfoRow(
              icon: Icons.info_outline,
              label: 'Version',
              value: appInfo.fullVersion,
            ),
            if (appInfo.buildSignature != null) ...[
              const SizedBox(height: AppSpacing.md),
              AppInfoRow(
                icon: Icons.security_outlined,
                label: 'Build Signature',
                value: appInfo.buildSignature!,
                isLong: true,
              ),
            ],
            if (appInfo.installerStore != null) ...[
              const SizedBox(height: AppSpacing.md),
              AppInfoRow(
                icon: Icons.store_outlined,
                label: 'Installer Store',
                value: appInfo.installerStore!,
              ),
            ],
          ],
        ),
      ),
    );

}
