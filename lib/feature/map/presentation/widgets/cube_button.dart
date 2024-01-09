import 'package:flutter/material.dart';

import '../../../../core/utils/colors.dart';
import '../../../../core/utils/text_styles.dart';

class CubeButton extends StatelessWidget {
  final String label;
  final String? text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isFocused;

  const CubeButton({
    super.key,
    required this.label,
     this.onPressed,
    this.isFocused = false,
    this.icon,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    final dwidth = MediaQuery.sizeOf(context).width;
    return Column(
      children: [
        Container(
          height: dwidth / 6,
          width: dwidth / 6,
          alignment: Alignment.center,
          constraints: const BoxConstraints(
            maxHeight: 100,
            maxWidth: 100,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isFocused ? AppColor.primaryColor : AppColor.accentColor,
          ),
          child: text == null
              ? IconButton(
                  onPressed: onPressed,
                  icon: Icon(
                    icon,
                    color: isFocused
                        ? AppColor.secondaryColor
                        : AppColor.primaryColor,
                  ),
                )
              : Text(text!, style: AppText.appTextLarge),
        ),
        const SizedBox(height: 10),
        Text(label, style: AppText.appTextSmall)
      ],
    );
  }
}
