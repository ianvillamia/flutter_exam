import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_exam/features/tracking/presentation/cubit/tracking_cubit.dart';
import 'package:flutter_exam/features/tracking/presentation/widgets/clear_confirmation_dialog.dart';
import 'package:flutter_exam/features/tracking/presentation/widgets/empty_state.dart';
import 'package:flutter_exam/features/tracking/presentation/widgets/filter_row.dart';
import 'package:flutter_exam/features/tracking/presentation/widgets/readings_list.dart';
import 'package:flutter_exam/features/tracking/presentation/widgets/status_banner.dart';
import 'package:flutter_exam/features/tracking/presentation/widgets/toggle_card.dart';

class TrackingPage extends StatelessWidget {
  const TrackingPage({super.key});

  Future<void> _onClearTapped(BuildContext context) async {
    final confirmed = await ClearConfirmationDialog.show(context);
    if (confirmed && context.mounted) {
      await context.read<TrackingCubit>().clearReadings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Tracker'),
        actions: [
          BlocBuilder<TrackingCubit, TrackingState>(
            buildWhen: (prev, curr) =>
                prev.readings.isEmpty != curr.readings.isEmpty,
            builder: (context, state) => state.readings.isEmpty
                ? const SizedBox.shrink()
                : IconButton(
                    icon: const Icon(Icons.delete_outline),
                    tooltip: 'Clear entries',
                    onPressed: () => _onClearTapped(context),
                  ),
          ),
        ],
      ),
      body: BlocBuilder<TrackingCubit, TrackingState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ToggleCard(state: state),
              if (state.status == TrackingStatus.permissionDenied)
                const StatusBanner(
                  message:
                      'Location permission denied. Enable it in Settings.',
                  color: Colors.orange,
                  icon: Icons.warning_amber,
                ),
              if (state.status == TrackingStatus.error &&
                  state.errorMessage != null)
                StatusBanner(
                  message: state.errorMessage!,
                  color: Colors.red,
                  icon: Icons.error_outline,
                ),
              if (state.readings.isNotEmpty) ...[
                FilterRow(filterCount: state.filterCount),
                const Divider(height: 1),
              ],
              Expanded(
                child: state.readings.isEmpty
                    ? EmptyState(status: state.status)
                    : ReadingsList(readings: state.filteredReadings),
              ),
            ],
          );
        },
      ),
    );
  }
}
