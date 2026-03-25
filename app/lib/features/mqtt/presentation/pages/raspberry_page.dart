import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raspberry_monitor/features/mqtt/domain/entities/pi_system_status_entity.dart';
import 'package:raspberry_monitor/features/mqtt/domain/entities/pi_telemetry_entity.dart';
import 'package:raspberry_monitor/features/mqtt/presentation/bloc/raspberry_bloc.dart';
import 'package:raspberry_monitor/features/mqtt/presentation/bloc/raspberry_event.dart';
import 'package:raspberry_monitor/features/mqtt/presentation/bloc/raspberry_state.dart';
import 'package:raspberry_monitor/features/mqtt/presentation/widgets/telemetry_card.dart';
import 'package:raspberry_monitor/injection.dart';
import 'package:raspberry_monitor/l10n/app_localizations.dart';

/// The main dashboard page displaying real-time Raspberry Pi telemetry.
class RaspberryPage extends StatelessWidget {
  /// Creates the raspberry page
  const RaspberryPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<RaspberryBloc>(
    create: (context) =>
        getIt<RaspberryBloc>()..add(const ConnectToPiStarted()),
    child: const RaspberryView(),
  );
}

/// View showing a Raspberry Dashboard
class RaspberryView extends StatefulWidget {
  /// Creates the showcase view
  const RaspberryView({super.key});

  @override
  State<RaspberryView> createState() => _RaspberryViewState();
}

class _RaspberryViewState extends State<RaspberryView> {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Raspberry Pi Dashboard'),
      actions: [
        BlocBuilder<RaspberryBloc, RaspberryState>(
          builder: (context, state) {
            // Check if we are currently in an active connection state
            final isConnected =
                state is RaspberryConnected || state is RaspberryLoaded;
            return IconButton(
              icon: Icon(isConnected ? Icons.link_off : Icons.link),
              tooltip: isConnected ? 'Disconnect' : 'Connect',
              onPressed: () {
                if (isConnected) {
                  context.read<RaspberryBloc>().add(
                    const DisconnectFromPiStarted(),
                  );
                } else {
                  context.read<RaspberryBloc>().add(const ConnectToPiStarted());
                }
              },
            );
          },
        ),
      ],
    ),
    body: BlocBuilder<RaspberryBloc, RaspberryState>(
      builder: (context, state) {
        switch (state) {
          case RaspberryInitial():
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Connecting to broker...'),
                ],
              ),
            );
          case RaspberryConnecting():
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Connecting to broker...'),
                ],
              ),
            );
          case RaspberryConnected():
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Waiting for telemetry data...'),
                ],
              ),
            );
          case RaspberryLoaded():
            return buildDashboard(context, state.status, state.telementry);
          case RaspberryError():
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => context.read<RaspberryBloc>().add(
                        const ConnectToPiStarted(),
                      ),
                      child: const Text('Retry Connection'),
                    ),
                  ],
                ),
              ),
            );
        }
      },
    ),
  );

  Widget buildDashboard(
    BuildContext context,
    PiSystemStatusEntity? status,
    PiTelemetryEntity? telemetry,
  ) {
    final l10n = AppLocalizations.of(context)!;

    // Determine the status color and text cleanly
    final isOnline =
        (status?.status ?? PiSystemStatus.offline) == PiSystemStatus.online;
    final statusColor = isOnline ? Colors.green : Colors.red;
    final statusText = isOnline ? 'Online' : 'Offline';

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              statusText,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: statusColor,
                boxShadow: [
                  // Adds a nice little "LED Glow" effect around the dot
                  BoxShadow(
                    color: statusColor.withValues(alpha: 0.4),
                    blurRadius: 6,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // A grid of cards for the telemetry
        if (telemetry != null)
          GridView.count(
            crossAxisCount: 4,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              TelemetryCard(
                title: l10n.telemetryStatus,
                value: telemetry.status.name,
                icon: Icons.network_ping,
                color: telemetry.status == PiSystemStatus.online
                    ? Colors.green
                    : Colors.red,
              ),
              TelemetryCard(
                title: l10n.telemetryUptime,
                value: telemetry.uptime.toString(),
                icon: Icons.timelapse,
                color: Colors.green,
              ),
              TelemetryCard(
                title: l10n.telemetryCpuTemp,
                value: telemetry.cpuTemperature.toString(),
                icon: Icons.thermostat,
                color: Colors.green,
              ),
            ],
          )
        else
          const SizedBox.shrink(),
        const SizedBox(height: 16),
        /*Card(
            child: ListTile(
              leading: const Icon(Icons.timer),
              title: const Text('Uptime'),
              // Very basic seconds to hours conversion
              subtitle: Text(
                '${(status.uptimeSeconds / 3600).toStringAsFixed(1)} Hours',
              ),
            ),
          ),*/
        const SizedBox(height: 32),
        const Text(
          'GPIO Control (Coming Soon)',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 16),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: Text('GPIO visualizer will be placed here.')),
          ),
        ),
      ],
    );
  }
}
