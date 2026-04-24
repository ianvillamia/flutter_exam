import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_exam/features/tracking/presentation/cubit/tracking_cubit.dart';

class ToggleCard extends StatelessWidget {
  const ToggleCard({required this.state, super.key});

  final TrackingState state;

  @override
  Widget build(BuildContext context) {
    final isLoading = state.status == TrackingStatus.loading;
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Start Tracking',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    state.isTracking
                        ? 'Polling every 5 s'
                        : 'Toggle to begin location polling',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: state.isTracking
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            if (isLoading)
              const SizedBox(
                width: 36,
                height: 36,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              )
            else
              Switch(
                value: state.isTracking,
                onChanged: (_) =>
                    context.read<TrackingCubit>().toggleTracking(),
              ),
          ],
        ),
      ),
    );
  }
}
