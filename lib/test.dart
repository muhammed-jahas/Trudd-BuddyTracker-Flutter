

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trudd_track_your_buddy/config/map_theme.dart';
import 'package:trudd_track_your_buddy/core/components/app_messenger.dart';
import 'package:trudd_track_your_buddy/core/utils/colors.dart';
import 'package:trudd_track_your_buddy/core/utils/google_map_helpers.dart';

class ScreenGoogleMap extends StatefulWidget {
  const ScreenGoogleMap({super.key});

  @override
  State<ScreenGoogleMap> createState() => _ScreenGoogleMapState();
}

class _ScreenGoogleMapState extends State<ScreenGoogleMap> {
  String darkTheme = '';
  late GoogleMapController _controller;
  List<LatLng> routes = [];
  Set<Marker> markers = {};
  LatLng? origin;
  LatLng? destination;
  @override
  void initState() {
    super.initState();
    DefaultAssetBundle.of(context).loadString(googleMapDarkTheme).then((value) {
      // print(value);
      darkTheme = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dheight = MediaQuery.sizeOf(context).height;
    final dwidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: SizedBox(
        height: dheight,
        width: dwidth,
        child: GoogleMap(
          initialCameraPosition:
              const CameraPosition(target: LatLng(12.9716, 77.5946), zoom: 13),
          onMapCreated: (controller) async {
            await controller.setMapStyle(darkTheme);
            _controller = controller;
          },
          polylines: {
            Polyline(
              polylineId: const PolylineId('routes'),
              points: routes,
              color: AppColor.primaryColor,
              width: 6,
            )
          },
          compassEnabled: false,
          zoomControlsEnabled: false,
          zoomGesturesEnabled: true,
          markers: markers,
          //  {
          //   const Marker(
          //       markerId: MarkerId('marker1'),
          //       icon: BitmapDescriptor.defaultMarker,
          //       position: LatLng(37.378653930044955, -122.06901434808968)),
          //   const Marker(
          //       markerId: MarkerId('marker2'),
          //       icon: BitmapDescriptor.defaultMarker,
          //       position: LatLng(37.3944735902599, -122.09853775799274))
          // },
          onTap: onPlaceTapped,
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
              child: const Icon(Icons.roundabout_left),
              onPressed: () async {
                // if (origin == null || destination == null) {
                //   AppMessenger.showFailure(
                //     context: context,
                //     message: "Select your locations",
                //   );
                //   return;
                // }
                final route = await MapHelper.fetchRoute(origin!, destination!);
                if (route.isNotEmpty) {
                  routes.clear();
                  routes = route;
                  setState(() {});
                } else {
                  AppMessenger.showFailure(
                    context: context,
                    message: "Failed to get routes",
                  );
                }
              }),
          const SizedBox(height: 10),
          // FloatingActionButton(
          //     child: const Icon(Icons.location_on_outlined),
          //     onPressed: () async {
          //       final currentPos = await MapHelper.getCurrentLocation();
          //       if (currentPos != null) {
          //         markers.clear();
          //         markers.add(currentPos);
          //         _controller.animateCamera(CameraUpdate.newLatLng(LatLng(
          //             currentPos.position.latitude,
          //             currentPos.position.longitude)));
          //         origin = LatLng(currentPos.position.latitude,
          //             currentPos.position.longitude);
          //         setState(() {});
          //       } else {
          //         AppMessenger.showFailure(
          //           context: context,
          //           message: "Failed to get current location",
          //         );
          //       }
          //     }),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Future<void> onPlaceTapped(LatLng pos) async {
    var markerIcon = await MapHelper.getBytesFromCanvas(Colors.blue, 'A');
    final marker = Marker(
        markerId:
            MarkerId(DateTime.fromMillisecondsSinceEpoch(1000).toString()),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        position: pos);
    markers.add(marker);
    destination = pos;
    print(pos);
    setState(() {});
  }
}

Future<void> checkLocationPermission() async {
  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Handle denied permission
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Handle permanently denied permission
  }

  // Now you can call getCurrentLocation() to get the location.
}


//*******************************************************************************************************//


class ScreenGeoLocation extends StatefulWidget {
  const ScreenGeoLocation({super.key});

  @override
  State<ScreenGeoLocation> createState() => _ScreenGeoLocationState();
}

class _ScreenGeoLocationState extends State<ScreenGeoLocation> {
  final streamController = StreamController<User>();

  @override
  void initState() {
    super.initState();
    listenStream();
    // listenCurrentLocation();
  }

  listenStream() {
    streamController.stream.listen((user) {
      context.read<LocationBloc>().add(SetUserLocationEvent(user: user));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      constraints: const BoxConstraints(
        maxHeight: double.maxFinite,
        minHeight: 0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 40),
          Expanded(child: BlocBuilder<LocationBloc, LocationState>(
            builder: (context, state) {
              if (state is UserFetchedState) {
                List<User> users = state.users;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: users.length,
                  itemBuilder: (context, index) => Card(
                    child: ListTile(
                      leading: Text(users[index].id),
                      title: Text(users[index].name),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          )),
          buttons(context)
        ],
      ),
    )

        // Center(
        //     child: StreamBuilder(
        //         stream: Geolocator.getPositionStream(),
        //         builder: (context, snapShot) {
        //           if (snapShot.hasData) {
        //             return Text(
        //                 'latitude is ${snapShot.data!.latitude}  longitude is ${snapShot.data!.longitude}');
        //           }
        //           return const Text('please wait...');
        //         })),
        );
  }

  StreamSubscription<Position> listenCurrentLocation() {
    // Geolocator.getPositionStream();

    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 1,
      // timeLimit: Duration(seconds: 2),
    );

    StreamSubscription<Position> positionStream = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      print('${position.latitude}, ${position.longitude}');
    });

    return positionStream;
  }

  Expanded buttons(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
              onPressed: () {
                streamController.add(User(id: '1', name: 'name1'));
              },
              icon: const Icon(
                Icons.person_add_alt_1,
                color: Colors.green,
              )),
          IconButton(
              onPressed: () {
                streamController.add(User(id: '1', name: 'name1.1'));
              },
              icon: const Icon(
                Icons.person_remove,
                color: Colors.red,
              )),
          IconButton(
              onPressed: () {
                streamController.add(User(id: '2', name: 'name2'));
              },
              icon: const Icon(
                Icons.person_add_alt_1_outlined,
                color: Colors.green,
              )),
          IconButton(
              onPressed: () {
                streamController.add(User(id: '2', name: 'name2.1'));
              },
              icon: const Icon(
                Icons.person_remove_alt_1_outlined,
                color: Colors.red,
              )),
        ],
      ),
    );
  }
}

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationInitial()) {
    on<SetUserLocationEvent>(setUserLocationEvent);
  }
  List<User> users = [];
  final streamController = StreamController<User>();
  void setUserLocationEvent(
      SetUserLocationEvent event, Emitter<LocationState> emit) {
    final bool isJoined = users.any((user) => event.user.id == user.id);
    if (!isJoined) {
      users.add(event.user);
    } else {
      users = users.map((e) => e.id == event.user.id ? event.user : e).toList();
      print(users);
    }
    emit(UserFetchedState(users: users));
  }
}

//state
abstract class LocationState {}

class LocationInitial extends LocationState {}

class UserFetchedState extends LocationState {
  final List<User> users;

  UserFetchedState({required this.users});
}

//event
abstract class LocationEvent {}

class SetUserLocationEvent extends LocationEvent {
  final User user;

  SetUserLocationEvent({required this.user});
}

//model class
class User {
  final String id;
  final String name;

  User({required this.id, required this.name});
}
