import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_exam/features/tracking/presentation/cubit/tracking_cubit.dart';

class FilterRow extends StatelessWidget {
  const FilterRow({required this.filterCount, super.key});

  final int filterCount;

  static const _options = [5, 10, 15, 20];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Text('Show last', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(width: 12),
          DropdownButton<int>(
            value: filterCount,
            underline: const SizedBox.shrink(),
            items: _options
                .map(
                  (n) => DropdownMenuItem(
                    value: n,
                    child: Text(
                      '$n readings',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                context.read<TrackingCubit>().updateFilter(value);
              }
            },
          ),
        ],
      ),
    );
  }
}
