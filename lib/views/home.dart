import 'package:flutter/material.dart';
import 'package:argos_home/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Utils
import 'package:argos_home/views/utils/router.dart' as router;
import 'package:argos_home/views/utils/app_bar.dart' as appbar;
import 'package:argos_home/views/utils/side_bar.dart' as sidebar;

// Views
import 'package:argos_home/views/settings.dart' as settings_view;
import 'package:argos_home/views/profile.dart' as profile_view;
import 'package:argos_home/views/login.dart' as login_view;
import 'package:argos_home/views/task/board_list.dart' as board_view;
import 'package:argos_home/views/notifications.dart' as notifications_view;
import 'package:argos_home/views/help.dart' as help_view;


const titleApp = "Smart Home Chakra";


class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      initialRoute: router.Routes.home,
      routes: {
        router.Routes.home: (context) => const HomeDashboardView(),
        router.Routes.profile: (context) => const profile_view.ProfileScreen(),
        router.Routes.settings: (context) => const settings_view.SettingsPage(),
        router.Routes.boards: (context) => const board_view.BoardListView(),
        router.Routes.login: (context) => const login_view.LoginScreen(),
        router.Routes.notifications: (context) => const notifications_view.NotificationView(),
        router.Routes.help: (context) => const help_view.HelpView(),
      },
      debugShowCheckedModeBanner: false,
      title: titleApp,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale("en"),
        Locale("es"),
      ],
    );
  }
}


class HomeDashboardView extends ConsumerWidget {
  const HomeDashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String textHome = AppLocalizations.of(context)!.home_view;

    return Scaffold(
      appBar: appbar.CustomAppBar(
        title: AppLocalizations.of(context)!.home,
      ),
      body: Center(
        child: Text(textHome),
      ),
      drawer: sidebar.sideBar(context),
    );
  }
}