import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:trudd_track_your_buddy/config/theme.dart';
import 'package:trudd_track_your_buddy/feature/map/presentation/bloc/creator_map/creator_map_bloc.dart';
import 'package:trudd_track_your_buddy/feature/map/presentation/bloc/joiner_map/joiner_map_bloc.dart';
import 'package:trudd_track_your_buddy/feature/map/presentation/bloc/search/search_bloc.dart';
import 'package:trudd_track_your_buddy/feature/room/presentation/bloc/spot_bloc.dart';
import 'package:trudd_track_your_buddy/feature/room/presentation/pages/welcome_page.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SpotBloc()),
        BlocProvider(create: (context) => SearchBloc()),
        BlocProvider(create: (context) => CreatorMapBloc()),
        BlocProvider(create: (context) => JoinerMapBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: themeData,
        home: const ScreenWelcome(),
      ),
    );
  }
}
