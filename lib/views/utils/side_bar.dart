import 'package:flutter/material.dart';
import 'package:argos_home/l10n/app_localizations.dart';

// Styles
import 'package:argos_home/styles.dart' as styles;

// utils
import 'package:argos_home/views/utils/router.dart' as router;



Drawer sideBar(BuildContext context) {
  return Drawer(
    child: ListView(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(color: styles.kAccentColor),
          child: Text(AppLocalizations.of(context)!.menu, style: TextStyle(fontSize: 24)),
        ),
        ListTile(
          leading: const Icon(Icons.home),
          title: Text(AppLocalizations.of(context)!.home),
          onTap: () => Navigator.pushNamed(context, router.Routes.home),
        ),
        ListTile(
          leading: const Icon(Icons.task),
          title: Text(AppLocalizations.of(context)!.tasks),
          onTap: () => Navigator.pushNamed(context, router.Routes.boards),
        ),
      ],
    )
  );
}