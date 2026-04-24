import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_exam/features/tracking/presentation/cubit/tracking_cubit.dart';

class TrackingPage extends StatelessWidget {
  const TrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tracking')),
      body: BlocBuilder<TrackingCubit, TrackingState>(
        builder: (context, state) => switch (state) {
          TrackingInitial() => const Center(
              child: Text('Tap the button to load target location'),
            ),
          TrackingLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
          TrackingLoaded(:final targetLocation) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('ID: ${targetLocation.id}'),
                  Text('Lat: ${targetLocation.targetLat}'),
                  Text('Lng: ${targetLocation.targetLng}'),
                ],
              ),
            ),
          TrackingError(:final message) => Center(
              child: Text('Error: $message'),
            ),
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<TrackingCubit>().fetchTargetLocation(),
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
