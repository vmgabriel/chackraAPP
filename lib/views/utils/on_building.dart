import 'package:argos_home/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

// Utils
import 'package:argos_home/styles.dart' as styles;
import 'package:argos_home/tools/generics.dart' as generic_functions;

// Widgets
import 'package:argos_home/widgets/password_text_box.dart' as pass_text_box;
import 'package:argos_home/widgets/text_box.dart' as text_box;

// Views
import 'package:argos_home/views/home.dart' as home_view;
import 'package:argos_home/views/signup.dart' as signup_view;


class OnBuildingScreen extends StatefulWidget {
  const OnBuildingScreen({super.key});

  @override
  State<OnBuildingScreen> createState() => _OnBuildingScreenState();
}

class _OnBuildingScreenState extends State<OnBuildingScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: styles.kBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: columnForm()
            ),
          ),
        ),
      ),
    );
  }

  Column columnForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(
            Icons.build,
            size: 80,
            color: styles.kPrimaryColor
        ),
        const SizedBox(height: 16),
        Text(
            AppLocalizations.of(context)!.on_building,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: styles.kPrimaryColor,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat'
            )
        ),
        Text(
            AppLocalizations.of(context)!.soon_view_will_be_complete,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: styles.kPrimaryColor,
                fontSize: 16
            )
        ),
        const SizedBox(height: 48),
      ],
    );
  }
}