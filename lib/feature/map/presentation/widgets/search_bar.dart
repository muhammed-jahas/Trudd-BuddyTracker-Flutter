import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trudd_track_your_buddy/core/utils/text_styles.dart';
import 'package:trudd_track_your_buddy/feature/map/presentation/bloc/search/search_bloc.dart';

import '../../../../core/components/app_textfield.dart';
import '../../../../core/utils/colors.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.accentColor,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + 10),
          AppTextField(
            hint: 'Search Location',
            showBackButton: true,
            onChanged: (value) {
              if (value.trim().isEmpty) {
                context.read<SearchBloc>().add(ClearSearchEvent());
                return;
              }
              context.read<SearchBloc>().add(SearchLocationEvent(query: value));
            },
            
          ),
          const SizedBox(height: 10),
          const Text(
            'Hint: You can also select location by tapping in the map',
            style: AppText.appTextxSmall,
          ),
        ],
      ),
    );
  }
}
