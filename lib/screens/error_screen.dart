import 'package:flutter/material.dart';

class ErrorReloadWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onReloadPressed;

  const ErrorReloadWidget({
    super.key,
    required this.errorMessage,
    required this.onReloadPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            errorMessage,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onReloadPressed,
            child: const Text('Reload'),
          ),
        ],
      ),
    );
  }
}
