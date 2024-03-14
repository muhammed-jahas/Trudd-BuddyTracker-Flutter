import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trudd_track_your_buddy/core/utils/text_styles.dart';
import 'package:trudd_track_your_buddy/feature/room/presentation/pages/option_page.dart';

class ScreenWelcome extends StatelessWidget {
  const ScreenWelcome({Key? key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Scaffold(
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/welcomebg.png'),
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Track\nyour buddies\non the way',
              style: AppText.appTextXLarge,
            ),
            const SizedBox(height: 25),
            const Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt',
              style: AppText.appTextSmall,
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                _getLocationPermission(context);
              },
              child: const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getLocationPermission(BuildContext context) async {
    LocationPermission permissionStatus = await Geolocator.checkPermission();
    if (permissionStatus == LocationPermission.whileInUse ||
        permissionStatus == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const ScreenOption(),
      ));
    } else if (permissionStatus == LocationPermission.denied) {
      LocationPermission newPermissionStatus =
          await Geolocator.requestPermission();
      if (newPermissionStatus == LocationPermission.whileInUse ||
          newPermissionStatus == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ScreenOption(),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location permission is required.'),
            action: SnackBarAction(
              label: 'Open Settings',
              onPressed: () {
                openAppSettings();
              },
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location permission is permanently denied.'),
        ),
      );
    }
  }
}
