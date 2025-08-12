import 'package:flutter/material.dart';

// Views
import 'package:argos_home/views/utils/app_bar.dart' as appbar;


class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar.CustomAppBar(
        title: "Notifications",
        wantProfile: false,
        wantNotifications: false
      ),
      body: const Center(
        child: Text('Notifications Page'),
      ),
    );
  }
}