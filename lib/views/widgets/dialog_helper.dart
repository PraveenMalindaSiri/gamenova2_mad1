// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

enum NoticeType { success, error, info, warning }

IconData _icon(NoticeType t) {
  switch (t) {
    case NoticeType.success:
      return Icons.check_circle_rounded;
    case NoticeType.error:
      return Icons.error_rounded;
    case NoticeType.info:
      return Icons.info_rounded;
    case NoticeType.warning:
      return Icons.warning_amber_rounded;
  }
}

Color _color(NoticeType t) {
  switch (t) {
    case NoticeType.success:
      return Colors.green;
    case NoticeType.error:
      return Colors.red;
    case NoticeType.info:
      return Colors.blue;
    case NoticeType.warning:
      return Colors.orange;
  }
}

Future<void> showNoticeDialog({
  required BuildContext context,
  required String title,
  String? message,
  required NoticeType type,
  String buttonText = 'OK',
  List<Widget>? actions,
}) async {
  final color = _color(type);

  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white70, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(_icon(type), color: color),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: color,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  message ?? 'Something went wrong',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                if (actions != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: actions,
                    ),
                  ),
                if (actions == null)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        buttonText,
                        style: TextStyle(color: color, fontSize: 16),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
