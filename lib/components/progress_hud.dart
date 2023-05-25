import 'package:flutter/material.dart';

class ProgressHud extends StatelessWidget {
  final bool loading;
  final Color color;
  final Widget child;
  const ProgressHud(
      {super.key,
      required this.loading,
      required this.color,
      required this.child});

  @override
  Widget build(BuildContext context) {
    if (!loading) return child;
    return Stack(
      children: [
        Opacity(
          opacity: 0.5,
          child: ModalBarrier(
            color: Theme.of(context).colorScheme.background,
            dismissible: false,
          ),
        ),
        const Center(
          child: CircularProgressIndicator(strokeWidth: 5),
        )
      ],
    );
  }
}
