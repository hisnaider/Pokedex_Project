import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final String error;
  final VoidCallback onPressed;
  const ErrorMessage({super.key, required this.error, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 90,
            color: Theme.of(context).colorScheme.primary,
          ),
          Text(
            error,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          FilledButton(
            onPressed: onPressed,
            child: const Text("Tentar novamente"),
          )
        ],
      ),
    );
  }
}
