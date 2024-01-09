// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:trudd_track_your_buddy/core/components/app_bottom_sheet.dart';
import 'package:trudd_track_your_buddy/core/utils/colors.dart';

import '../../../../config/map_theme.dart';
import '../bloc/joiner_map/joiner_map_bloc.dart';
import '../widgets/cube_button.dart';

class ScreenJoinerMapView extends StatefulWidget {
  const ScreenJoinerMapView({super.key});

  @override
  State<ScreenJoinerMapView> createState() => _ScreenJoinerMapViewState();
}

class _ScreenJoinerMapViewState extends State<ScreenJoinerMapView> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  late StreamSubscription<Position> positionStream;

  @override
  void initState() {
    super.initState();
    // startListening(context);
  }

  @override
  Widget build(BuildContext context) {
    final dheight = MediaQuery.sizeOf(context).height;
    final safeAreaHeight = MediaQuery.of(context).padding.top;
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: AppColor.primaryColor));
    return Scaffold(
      appBar: appBar(),
      body: SingleChildScrollView(
        child: SizedBox(
          height: dheight - safeAreaHeight - kToolbarHeight,
          child: Column(
            children: [
              googleMap(context),
              buttons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget googleMap(BuildContext context) {
    return Expanded(
      child: BlocBuilder<JoinerMapBloc, JoinerMapState>(
        builder: (context, state) {
          if (state is PositionSetState) {
            return GoogleMap(
              initialCameraPosition: CameraPosition(
                  target: LatLng(state.currentPosition.latitude,
                      state.currentPosition.longitude),
                  zoom: 13),
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
            );
          } else {
            return Center(child: Text('Failed to Load Map'));
          }
        },
      ),
    );
  }

  Container buttons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CubeButton(
            label: 'Info',
            onPressed: () {},
            icon: Icons.info,
            isFocused: true,
          ),
          CubeButton(
            label: 'Joined',
            onPressed: () {},
            text: '0',
          ),
          CubeButton(
            label: 'Share',
            onPressed: () async {
              await Share.share('hello world');
            },
            icon: Icons.share_outlined,
          ),
          CubeButton(
            label: 'Exit',
            onPressed: () {
              showCustomBottomSheet(
                  context: context,
                  title: 'Are you sure\nYou want to exit ?',
                  onPrimaryText: 'Confirm',
                  onSecondaryText: 'Cancel',
                  onPrimary: () {},
                  onSecondary: () => Navigator.pop(context));
            },
            icon: Icons.close_outlined,
          ),
        ],
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      leading: InkWell(
        child: Icon(
          Icons.arrow_back,
          color: AppColor.accentColor,
        ),
        onTap: () => Navigator.pop(context),
      ),
      title: const Text('Calicut'),
    );
  }

  // void startListening(BuildContext context) {
  //   positionStream = Geolocator.getPositionStream().listen((position) {
  //     var currentPosition = LatLng(position.latitude, position.longitude);
  //     print('listening to position');
  //     context
  //         .read<JoinerMapBloc>()
  //         .add(UpdateJoinerLocationEvent(currentPosition: currentPosition));
  //   });
  // }

  @override
  void dispose() {
    super.dispose();
    print(positionStream);
    positionStream.cancel();
  }
}
