import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trudd_track_your_buddy/core/components/app_bottom_sheet.dart';
import 'package:trudd_track_your_buddy/core/components/app_messenger.dart';
import 'package:trudd_track_your_buddy/core/utils/google_map_helpers.dart';
import 'package:trudd_track_your_buddy/core/utils/text_styles.dart';
import 'package:trudd_track_your_buddy/feature/map/presentation/pages/custom_location_page.dart';

import '../bloc/spot_bloc.dart';

class LocationView extends StatelessWidget {
  const LocationView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[800],
          image: const DecorationImage(
              image: AssetImage('assets/images/create-spot-bg.png'),
              fit: BoxFit.cover)),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          BlocListener<SpotBloc, SpotState>(
            listener: (context, state) {
              if (state is LocationFetchedState) {
                AppMessenger.showSuccess(
                  message: 'Location Fetched Successfully',
                  context: context,
                );
              }
            },
            child: InkWell(
              child: Container(
                height: 40,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.17),
                  borderRadius: BorderRadius.circular(5),
                ),
                alignment: Alignment.center,
                child:
                    const Text('Choose Location', style: AppText.appTextSmall),
              ),
              onTap: () {
                showCustomBottomSheet(
                  context: context,
                  title: 'Preferred\nLocation type',
                  onPrimaryText: 'Current Location',
                  onSecondaryText: 'Custom Location',
                  onPrimary: () {
                    Navigator.pop(context);
                    context.read<SpotBloc>().add(SetDestinationEvent());
                  },
                  onSecondary: () {
                    MapHelper.getCurrentLocation().then((location) {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ScreenCustomLocation(
                          location: location ?? const LatLng(10.1632, 76.6413),
                        ),
                      ));
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    ));
  }
}
