import 'package:flutter/material.dart';
import 'package:trudd_track_your_buddy/core/utils/colors.dart';

class LoadingElevatedButton extends StatelessWidget {
  const LoadingElevatedButton(
      {super.key,
      required this.label,
      required this.isLoading,
      required this.onPressed});
  final String label;
  final bool isLoading;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: isLoading
          ? Transform.scale(
              scale: .6,
              child: const CircularProgressIndicator(
                  color: AppColor.secondaryColor),
            )
          : Text(label),
    );
  }
}

class LoadingOutLineButton extends StatelessWidget {
  const LoadingOutLineButton(
      {super.key,
      required this.label,
      required this.isLoading,
      required this.onPressed});
  final String label;
  final bool isLoading;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: isLoading
          ? Transform.scale(
              scale: .6,
              child: const CircularProgressIndicator(
                  color: AppColor.secondaryColor),
            )
          : Text(label),
    );
  }
}
