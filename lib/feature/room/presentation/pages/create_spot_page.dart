import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trudd_track_your_buddy/core/components/app_textfield.dart';
import 'package:trudd_track_your_buddy/core/utils/text_styles.dart';
import 'package:trudd_track_your_buddy/core/utils/validations.dart';
import 'package:trudd_track_your_buddy/feature/map/presentation/bloc/creator_map/creator_map_bloc.dart';
import 'package:trudd_track_your_buddy/feature/map/presentation/pages/creator_map_view_page.dart';

import '../../../../core/components/app_messenger.dart';
import '../../../../core/components/loading_buttons.dart';
import '../bloc/spot_bloc.dart';
import '../widgets/location_view.dart';

class ScreenCreateSpot extends StatelessWidget {
  ScreenCreateSpot({super.key});
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final instructionController = TextEditingController();
  final _createSpotKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final dheight = MediaQuery.sizeOf(context).height;
    final dwidth = MediaQuery.sizeOf(context).width;
    final dpadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: dheight,
          width: dwidth,
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/circlebg.png'),
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: kTextTabBarHeight + dpadding,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back),
                ),
              ),
              const SizedBox(height: 10),
              const Text('Create\nyour Spot', style: AppText.appTextXLarge),
              const SizedBox(height: 25),
              const Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.',
                style: AppText.appTextSmall,
              ),
              textFields(),
              const LocationView(),
              const SizedBox(height: 20),
              createSpotButton()
            ],
          ),
        ),
      ),
    );
  }

  Form textFields() {
    return Form(
      key: _createSpotKey,
      child: Column(
        children: [
          const SizedBox(height: 30),
          AppTextField(
            hint: 'Enter Your Name',
            controller: nameController,
            validator: (value) =>
                Validation.isEmpty(nameController.text, 'Name'),
          ),
          const SizedBox(height: 15),
          AppTextField(
            hint: 'Enter Your Mobile Number',
            controller: mobileController,
            keyboardType: TextInputType.phone,
            validator: (value) =>
                Validation.isNumber(mobileController.text, 'Mobile Number'),
          ),
          const SizedBox(height: 15),
          AppTextField(
            hint: 'Instructions',
            controller: instructionController,
            validator: (value) =>
                Validation.isEmpty(instructionController.text, 'Instructions'),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  BlocConsumer<SpotBloc, SpotState> createSpotButton() {
    return BlocConsumer<SpotBloc, SpotState>(
      listener: (context, state) {
        if (state is SpotCreatedState) {
          context.read<CreatorMapBloc>().add(LoadMapEvent(
                creator: state.creator,
              ));
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ScreenMapCreatorView()),
          );
          AppMessenger.showSuccess(
              message: 'Spot Created Successfully', context: context);
        } else if (state is SpotFailedState) {
          AppMessenger.showFailure(message: state.error, context: context);
        }
      },
      builder: (context, state) {
        bool isLoading = state is SpotLoadingState && state.isCreator;
        return LoadingOutLineButton(
          onPressed: () {
            if (_createSpotKey.currentState!.validate()) {
              context.read<SpotBloc>().add(
                    CreateSpotEvent(
                      name: nameController.text,
                      mobileNumber: mobileController.text,
                      instruction: instructionController.text,
                    ),
                  );
            }
          },
          label: 'Create Spot',
          isLoading: isLoading,
        );
      },
    );
  }
}
