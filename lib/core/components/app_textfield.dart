import 'package:flutter/material.dart';
import 'package:trudd_track_your_buddy/core/utils/colors.dart';
import 'package:trudd_track_your_buddy/core/utils/text_styles.dart';

class AppTextField extends StatelessWidget {
  const AppTextField(
      {super.key,
      this.controller,
      this.hint,
      this.keyboardType,
      this.onChanged,
      this.validator,
      this.showBackButton = false,
      this.isCodeField = false});
  final TextEditingController? controller;
  final String? hint;
  final TextInputType? keyboardType;
  final bool isCodeField;
  final bool showBackButton;
  final FormFieldValidator? validator;
  final void Function(String)? onChanged;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textCapitalization:
          isCodeField ? TextCapitalization.characters : TextCapitalization.none,
      style: isCodeField
          ? const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)
          : null,
      onChanged: onChanged,
      keyboardType: keyboardType,
      validator: validator,
      decoration: !isCodeField
          ? InputDecoration(
              hintText: hint,
              hintStyle: AppText.appTextSmall,
              prefixIcon: showBackButton
                  ? IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back))
                  : null,
            )
          : InputDecoration(
              enabledBorder: const UnderlineInputBorder(),
              focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColor.primaryColor)),
              errorBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red)),
              focusedErrorBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red)),
              hintText: hint,
              hintStyle: const TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff171717)),
            ),
    );
  }
}
