import 'package:flutter/material.dart';

// Views
import 'package:argos_home/views/utils/app_bar.dart' as appbar;


class HelpView extends StatelessWidget {
  const HelpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const appbar.CustomAppBar(
        title: "Help",
        wantNotifications: false,
        wantProfile: false,
      ),
      body: const Center(
        child: Text('Help View'),
      ),
    );
  }
}