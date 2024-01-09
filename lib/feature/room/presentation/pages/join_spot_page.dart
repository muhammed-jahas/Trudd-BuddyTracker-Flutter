import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trudd_track_your_buddy/core/components/app_messenger.dart';
import 'package:trudd_track_your_buddy/core/components/app_textfield.dart';
import 'package:trudd_track_your_buddy/core/components/loading_buttons.dart';
import 'package:trudd_track_your_buddy/core/utils/text_styles.dart';
import 'package:trudd_track_your_buddy/core/utils/validations.dart';
import 'package:trudd_track_your_buddy/feature/map/presentation/bloc/joiner_map/joiner_map_bloc.dart';
import 'package:trudd_track_your_buddy/feature/map/presentation/pages/joiner_map_view_page.dart';

import '../bloc/spot_bloc.dart';

class ScreenJoinSpot extends StatelessWidget {
  ScreenJoinSpot({super.key});
  final _spotKey = GlobalKey<FormState>();
  final spotIdController = TextEditingController();
  final nameController = TextEditingController();
  final mobileNumberController = TextEditingController();
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: kTextTabBarHeight + dpadding,
                child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back)),
              ),
              const SizedBox(height: 10),
              const Text('Join\nyour Spot', style: AppText.appTextXLarge),
              const SizedBox(height: 25),
              const Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.',
                style: AppText.appTextSmall,
              ),
              const SizedBox(height: 25),
              mapImage(),
              textFields(),
              joinSpotButton()
            ],
          ),
        ),
      ),
    );
  }

  Expanded mapImage() {
    return Expanded(
        child: Container(
      decoration: BoxDecoration(
        color: Colors.grey[700],
        borderRadius: BorderRadius.circular(8),
        image: const DecorationImage(
            image: AssetImage('assets/images/create-spot-bg.png'),
            fit: BoxFit.cover),
      ),
    ));
  }

  Form textFields() {
    return Form(
      key: _spotKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            'Enter Spot ID:',
            style: AppText.appTextSmall.copyWith(fontWeight: FontWeight.bold),
          ),
          AppTextField(
            hint: 'X044-12AC-07UI',
            isCodeField: true,
            controller: spotIdController,
            validator: (value) =>
                Validation.isEmpty(spotIdController.text, 'Spot ID'),
          ),
          const SizedBox(height: 20),
          AppTextField(
            hint: 'Enter Your Name',
            controller: nameController,
            validator: (value) =>
                Validation.isEmpty(nameController.text, 'Name'),
          ),
          const SizedBox(height: 20),
          AppTextField(
            hint: 'Enter Your Mobile Number',
            controller: mobileNumberController,
            keyboardType: TextInputType.phone,
            validator: (value) => Validation.isNumber(
                mobileNumberController.text, 'Mobile Number'),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  BlocConsumer<SpotBloc, SpotState> joinSpotButton() {
    return BlocConsumer<SpotBloc, SpotState>(
      listener: (context, state) {
        if (state is SpotJoinedState) {
          context
              .read<JoinerMapBloc>()
              .add(SetJoinerEvent(joiner: state.joiner));
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const ScreenJoinerMapView()),
          );
          AppMessenger.showSuccess(
              message: 'Joined room successfully', context: context);
        } else if (state is SpotFailedState) {
          AppMessenger.showFailure(message: state.error, context: context);
        }
      },
      builder: (context, state) {
        bool isLoading = state is SpotLoadingState && !state.isCreator;
        return LoadingElevatedButton(
          onPressed: () {
            if (_spotKey.currentState!.validate()) {
              context.read<SpotBloc>().add(JoinSpotEvent(
                    userName: nameController.text,
                    userMobile: mobileNumberController.text,
                    spotId: spotIdController.text,
                  ));
            }
          },
          label: 'Join Spot',
          isLoading: isLoading,
        );
      },
    );
  }
}
