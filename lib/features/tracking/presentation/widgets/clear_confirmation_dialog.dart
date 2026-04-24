import 'package:flutter/material.dart';

class ClearConfirmationDialog extends StatefulWidget {
  const ClearConfirmationDialog({super.key});

  static Future<bool> show(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const ClearConfirmationDialog(),
    );
    return confirmed ?? false;
  }

  @override
  State<ClearConfirmationDialog> createState() =>
      _ClearConfirmationDialogState();
}

class _ClearConfirmationDialogState extends State<ClearConfirmationDialog> {
  final _controller = TextEditingController();
  bool _confirmed = false;

  static const _requiredPhrase = 'yes i do';

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final matches =
          _controller.text.trim().toLowerCase() == _requiredPhrase;
      if (matches != _confirmed) setState(() => _confirmed = matches);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: const Text('Clear entries'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Do you really want to clear the entries?'),
          const SizedBox(height: 20),
          Text(
            'Type  "$_requiredPhrase"  to confirm',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: _requiredPhrase,
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed:
              _confirmed ? () => Navigator.of(context).pop(true) : null,
          style: FilledButton.styleFrom(
            backgroundColor: Colors.red.shade600,
            disabledBackgroundColor: Colors.red.shade200,
            foregroundColor: Colors.white,
          ),
          child: const Text('Clear'),
        ),
      ],
    );
  }
}
