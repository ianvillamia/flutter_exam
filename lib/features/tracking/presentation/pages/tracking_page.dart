import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_exam/features/tracking/presentation/cubit/tracking_cubit.dart';
import 'package:flutter_exam/features/tracking/presentation/widgets/empty_state.dart';
import 'package:flutter_exam/features/tracking/presentation/widgets/filter_row.dart';
import 'package:flutter_exam/features/tracking/presentation/widgets/readings_list.dart';
import 'package:flutter_exam/features/tracking/presentation/widgets/status_banner.dart';
import 'package:flutter_exam/features/tracking/presentation/widgets/toggle_card.dart';

class TrackingPage extends StatelessWidget {
  const TrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Location Tracker')),
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
