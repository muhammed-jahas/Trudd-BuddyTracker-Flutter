// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:trudd_track_your_buddy/core/utils/colors.dart';
import 'package:trudd_track_your_buddy/feature/map/presentation/bloc/creator_map/creator_map_bloc.dart';
import 'package:trudd_track_your_buddy/feature/room/domain/entities/creator_entity.dart';

import '../../../../config/map_theme.dart';
import '../../../../core/components/app_bottom_sheet.dart';
import '../widgets/cube_button.dart';

class ScreenMapCreatorView extends StatelessWidget {
  ScreenMapCreatorView({super.key});

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    final dheight = MediaQuery.sizeOf(context).height;
    final safeAreaHeight = MediaQuery.of(context).padding.top;
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: AppColor.primaryColor));
    return Scaffold(
      appBar: appBar(context),
      body: SingleChildScrollView(
        child: SizedBox(
          height: dheight - safeAreaHeight - kToolbarHeight,
          child: Column(children: [
            googleMap(context),
            buttons(context),
          ]),
        ),
      ),
    );
  }

  Widget googleMap(BuildContext context) {
    return BlocBuilder<CreatorMapBloc, CreatorMapState>(
      builder: (context, state) {
        if (state is MapDataFetchedState) {
          return Expanded(
            child: GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: state.destination, zoom: 13),
              onMapCreated: (controller) async {
                String darkTheme = '';
                await DefaultAssetBundle.of(context)
                    .loadString(googleMapDarkTheme)
                    .then((value) {
                  // print(value);
                  darkTheme = value;
                });
                await controller.setMapStyle(darkTheme);
                _controller.complete(controller);
              },
              compassEnabled: false,
              zoomControlsEnabled: false,
              zoomGesturesEnabled: true,
              markers: state.markers,
            ),
          );
        } else {
          return Expanded(child: Center(child: Text('Failed to load Map')));
        }
      },
    );
  }

  Container buttons(BuildContext context) {
    CreatorEntity? creator = context.read<CreatorMapBloc>().creator;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CubeButton(
            label: 'Info',
            onPressed: () {},
            icon: Icons.edit_outlined,
            isFocused: true,
          ),
          CubeButton(
            label: 'Joined',
            onPressed: () {},
            text: '0',
          ),
          CubeButton(
            label: 'Share',
            onPressed: creator == null
                ? null
                : () async {
                    await Share.share(
                        '${creator.userName} invites you to Join their Spot \nSpotID: ${creator.spotCode}');
                  },
            icon: Icons.share_outlined,
          ),
          CubeButton(
            label: 'Close',
            onPressed: () {
              showCustomBottomSheet(
                  context: context,
                  title: 'Are you sure\nYou want to end ?',
                  onPrimaryText: 'Confirm',
                  onSecondaryText: 'Cancel',
                  onPrimary: () {},
                  onSecondary: () => Navigator.pop(context));
            },
            icon: Icons.cancel_outlined,
          ),
        ],
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              color: AppColor.accentColor,
            )),
        title: const Text('Calicut'));
  }
}
