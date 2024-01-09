import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';

class AppMessenger {
  static showSuccess({required String message, required BuildContext context}) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      margin: const EdgeInsets.all(20),
      backgroundColor: AppColor.accentColor,
      duration: const Duration(seconds: 4),
      icon: const Icon(
        Icons.check_circle_outline_rounded,
        color: AppColor.primaryColor,
        size: 30,
      ),
      borderRadius: BorderRadius.circular(10),
      titleText: const Text(
        "TRUDD",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white38),
      ),
      messageText: Text(
        message,
        style: const TextStyle(fontSize: 15),
      ),
    ).show(context);
  }

  static showFailure({required String message, required BuildContext context}) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      margin: const EdgeInsets.all(20),
      backgroundColor: AppColor.accentColor,
      duration: const Duration(seconds: 4),
      icon: const Icon(
        Icons.cancel_outlined,
        color: Colors.red,
        size: 30,
      ),
      borderRadius: BorderRadius.circular(10),
      titleText: const Text(
        "TRUDD",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white38),
      ),
      messageText: Text(
        message,
        style: const TextStyle(
          fontSize: 15,
        ),
      ),
    ).show(context);
  }
}
