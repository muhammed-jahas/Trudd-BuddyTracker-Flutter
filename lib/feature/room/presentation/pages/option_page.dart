import 'package:flutter/material.dart';
import 'package:trudd_track_your_buddy/core/utils/text_styles.dart';
import 'package:trudd_track_your_buddy/feature/room/presentation/pages/create_spot_page.dart';
import 'package:trudd_track_your_buddy/feature/room/presentation/pages/join_spot_page.dart';

class ScreenOption extends StatelessWidget {
  const ScreenOption({super.key});

  @override
  Widget build(BuildContext context) {
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
            const Text('Everything\nStarts with a Spot',
                style: AppText.appTextXLarge),
            const SizedBox(height: 25),
            const Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt',
                style: AppText.appTextSmall),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ScreenCreateSpot()));
              },
              child: const Text('Create Spot'),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ScreenJoinSpot()));
              },
              child: const Text('Join Spot'),
            ),
          ],
        ),
      ),
    );
  }
}
