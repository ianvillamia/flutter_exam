import 'package:flutter/material.dart';
import 'package:flutter_exam/features/tracking/presentation/cubit/tracking_cubit.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({required this.status, super.key});

  final TrackingStatus status;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_off, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            status == TrackingStatus.stopped
                ? 'Tracking stopped'
                : 'Toggle the switch to start',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
