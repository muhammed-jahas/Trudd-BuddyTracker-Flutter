
  import 'package:flutter/material.dart';
import 'package:trudd_track_your_buddy/core/utils/colors.dart';
import 'package:trudd_track_your_buddy/core/utils/text_styles.dart';

showCustomBottomSheet({
    required BuildContext context,
    required String title,
    required String onPrimaryText,
    required String onSecondaryText,
    required VoidCallback onPrimary,
    required VoidCallback onSecondary,
  }) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        color: AppColor.accentColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppText.appTextXLarge),
            const SizedBox(height: 25),
            ElevatedButton(onPressed: onPrimary, child: Text(onPrimaryText)),
            const SizedBox(height: 18),
            OutlinedButton(onPressed: onSecondary, child: Text(onSecondaryText)),
          ],
        ),
      ),
    );
  }
