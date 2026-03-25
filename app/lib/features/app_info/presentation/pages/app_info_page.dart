import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raspberry_monitor/l10n/app_localizations.dart';
import '../../../../core/design_system/design_system.dart';
import '../../../../injection.dart';
import '../bloc/app_info_bloc.dart';
import '../widgets/app_features_list.dart';
import '../widgets/app_info_card.dart';
import '../widgets/locale_selector.dart';

/// Page displaying app information and language settings
class AppInfoPage extends StatelessWidget {
  /// Creates the app info page
  const AppInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        elevation: 0,
      ),
      body: BlocProvider(
        create: (_) => getIt<AppInfoBloc>()..add(const LoadAppInfo()),
        child: const _AppInfoView(),
      ),
    );
  }
}

class _AppInfoView extends StatelessWidget {
  const _AppInfoView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.welcomeTitle('Rasperry Pi Monitor'),
                    style: AppTextStyles.h3,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l10n.appInfoShortDescription,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // App Information section
          Text(
            l10n.applicationInformation,
            style: AppTextStyles.h5,
          ),
          const SizedBox(height: AppSpacing.md),

          BlocBuilder<AppInfoBloc, AppInfoState>(
            builder: (context, state) {
              if (state is AppInfoLoading) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: AppLoadingIndicator(
                      message: AppLocalizations.of(context)!.loadingAppInfo,
                    ),
                  ),
                );
              }

              if (state is AppInfoError) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: AppErrorWidget(
                      message: state.message,
                      onRetry: () {
                        context.read<AppInfoBloc>().add(const LoadAppInfo());
                      },
                    ),
                  ),
                );
              }

              if (state is AppInfoLoaded) {
                return AppInfoCard(appInfo: state.appInfo);
              }

              return const SizedBox.shrink();
            },
          ),

          const SizedBox(height: AppSpacing.lg),

          // Language Settings section
          Text(
            AppLocalizations.of(context)!.languageSettings,
            style: AppTextStyles.h5,
          ),
          const SizedBox(height: AppSpacing.md),

          const LocaleSelector(),

          const SizedBox(height: AppSpacing.lg),

          // Features section
          Text(
            AppLocalizations.of(context)!.includedFeatures,
            style: AppTextStyles.h5,
          ),
          const SizedBox(height: AppSpacing.md),

          const AppFeaturesList(),
        ],
      ),
    );
  }

}
