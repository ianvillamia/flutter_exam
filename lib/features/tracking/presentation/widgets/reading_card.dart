import 'package:flutter/material.dart';
import 'package:flutter_exam/features/tracking/domain/entities/location_reading_entity.dart';
import 'package:intl/intl.dart';

class ReadingCard extends StatelessWidget {
  const ReadingCard({required this.reading, required this.index, super.key});

  final LocationReadingEntity reading;
  final int index;

  static final _timeFmt = DateFormat('HH:mm:ss');
  static final _dateFmt = DateFormat('MMM dd');

  String _formatDistance(double meters) {
    if (meters >= 1000) {
      return '${(meters / 1000).toStringAsFixed(2)} km';
    }
    return '${meters.toStringAsFixed(1)} m';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '${index + 1}',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          size: 13, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '${_timeFmt.format(reading.timestamp)}  '
                        '${_dateFmt.format(reading.timestamp)}',
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Lat: ${reading.lat.toStringAsFixed(6)}',
                    style: theme.textTheme.bodyMedium,
                  ),
                  Text(
                    'Lng: ${reading.lng.toStringAsFixed(6)}',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(
                  Icons.location_searching,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 2),
                Text(
                  _formatDistance(reading.distanceMeters),
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'to target',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
