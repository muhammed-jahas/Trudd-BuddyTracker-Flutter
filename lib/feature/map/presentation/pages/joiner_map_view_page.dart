import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:trudd_track_your_buddy/core/components/app_bottom_sheet.dart';
import 'package:trudd_track_your_buddy/core/components/app_messenger.dart';
import 'package:trudd_track_your_buddy/core/network/network_url.dart';
import 'package:trudd_track_your_buddy/core/utils/colors.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

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
  late StreamSubscription socketStream;
  final WebSocketChannel channel = IOWebSocketChannel.connect(webSocketUrl);
  @override
  void initState() {
    super.initState();
    listenCurrentLocation(context);
    listenWebSocket();
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
      child: BlocConsumer<JoinerMapBloc, JoinerMapState>(
        listenWhen: (previous, current) => current is JoinerMapActionState,
        buildWhen: (previous, current) => current is! JoinerMapActionState,
        listener: (BuildContext context, JoinerMapState state) {
          if (state is JoinerErrorState) {
            AppMessenger.showFailure(message: state.error, context: context);
          }
        },
        builder: (context, state) {
          if (state is PositionSetState) {
            // log(state.markers.toString());
            log(state.markers.length.toString());
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
              polylines: state.polylines,
            );
          } else if (state is JoinerLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(child: Text('Failed to Load Map'));
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
          BlocBuilder<JoinerMapBloc, JoinerMapState>(
            builder: (context, state) {
              if (state is PositionSetState) {
                return CubeButton(
                  label: 'Joined',
                  text: (state.markers.length - 1).toString(),
                );
              } else {
                return CubeButton(
                  label: 'Joined',
                  onPressed: () {},
                  text: '0',
                );
              }
            },
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
            onPressed: () => showCustomBottomSheet(
                context: context,
                title: 'Are you sure\nYou want to exit ?',
                onPrimaryText: 'Confirm',
                onSecondaryText: 'Cancel',
                onPrimary: () {},
                onSecondary: () => Navigator.pop(context)),
            icon: Icons.close_outlined,
          ),
        ],
      ),
    );
  }

  AppBar appBar() => AppBar(
        leading: InkWell(
          child: const Icon(Icons.arrow_back, color: AppColor.accentColor),
          onTap: () {
            context.read<JoinerMapBloc>().add(ResetJoinerEvent());
            Navigator.pop(context);
          },
        ),
        title: const Text('Calicut'),
      );

  void listenCurrentLocation(BuildContext context) {
    const settings = LocationSettings(distanceFilter: 1);
    positionStream = Geolocator.getPositionStream(locationSettings: settings)
        .listen((position) {
      var currentPosition = LatLng(position.latitude, position.longitude);
      context
          .read<JoinerMapBloc>()
          .add(UpdateLocationEvent(currentPosition: currentPosition));
    });
  }

  void listenWebSocket() {
    socketStream = channel.stream.listen((rawData) {
      var data = jsonDecode(rawData);
      final position = LatLng(data['latitude'], data['longitude']);
      context
          .read<JoinerMapBloc>()
          .add(UpdateMarkerEvent(position: position, joiner: data));
    });
  }

  @override
  void dispose() {
    super.dispose();
    positionStream.cancel();
    socketStream.cancel();
  }
}
