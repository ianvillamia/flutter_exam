import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_exam/features/tracking/domain/entities/location_reading_entity.dart';
import 'package:flutter_exam/features/tracking/presentation/widgets/reading_card.dart';

class ReadingsList extends StatefulWidget {
  const ReadingsList({required this.readings, super.key});

  final List<LocationReadingEntity> readings;

  @override
  State<ReadingsList> createState() => _ReadingsListState();
}

class _ReadingsListState extends State<ReadingsList> {
  final _scrollController = ScrollController();

  @override
  void didUpdateWidget(ReadingsList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.readings.length > oldWidget.readings.length) {
      WidgetsBinding.instance.addPostFrameCallback((timestamp) {
        if (_scrollController.hasClients) {
          unawaited(
            _scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            ),
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: widget.readings.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (_, index) => ReadingCard(
        reading: widget.readings[index],
        index: index,
      ),
    );
  }
}
