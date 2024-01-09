import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/entities/place_entities.dart';
import '../bloc/search/search_bloc.dart';

class ResultViewer extends StatelessWidget {
  const ResultViewer({super.key, required this.controller});
  final Completer<GoogleMapController> controller;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchBloc, SearchState>(
      builder: (context, state) {
        List<PlaceEntity> results =
            (state is SearchSuccessState) ? state.results : [];
        bool visible = state is SearchSuccessState;
        return Visibility(
          visible: visible,
          child: Container(
            width: double.maxFinite,
            margin: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 8,
            ),
            constraints: const BoxConstraints(
              maxHeight: 300,
              minHeight: 0,
            ),
            decoration: BoxDecoration(
                // color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8)),
            child: results.isEmpty
                ? const Center(child: Text('No matching records found'))
                : ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final result = results[index];
                      return Card(
                        // color: AppColor.accentColor,
                        child: ListTile(
                          onTap: () {
                            controller.future.then((mapController) {
                              mapController.animateCamera(
                                  CameraUpdate.newCameraPosition(CameraPosition(
                                target:
                                    LatLng(result.latitude, result.longitude),
                                zoom: 13,
                              )));
                            });
                            context.read<SearchBloc>().add(ClearSearchEvent());
                            context.read<SearchBloc>().add(SetLocationEvent(
                                  position:
                                      LatLng(result.latitude, result.longitude),
                                ));
                          },
                          title: Text(
                            result.placeName,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 0),
                    itemCount: results.length,
                  ),
          ),
        );
      },
      listener: (context, state) {},
    );
  }
}
