import 'package:flutter/material.dart';
import 'package:argos_home/l10n/app_localizations.dart';

// Views
import 'package:argos_home/views/utils/app_bar.dart' as appbar;


class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar.CustomAppBar(
          title: AppLocalizations.of(context)!.configurations,
          wantProfile: false,
          wantNotifications: false
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
              AppLocalizations.of(context)!.preferences,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            title: Text(AppLocalizations.of(context)!.dark_mode),
            secondary: const Icon(Icons.dark_mode),
            value: Theme.of(context).brightness == Brightness.dark,
            onChanged: (value) {
            },
          ),
          const Divider(height: 32),
          Text(
              AppLocalizations.of(context)!.account,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: Text(AppLocalizations.of(context)!.change_password),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.fingerprint),
            title: Text(AppLocalizations.of(context)!.authentication_with_biometric),
            onTap: () {},
          ),
          const Divider(height: 32),
          Text(
              AppLocalizations.of(context)!.general,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.notifications_active_outlined),
            title: Text(AppLocalizations.of(context)!.notifications),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(AppLocalizations.of(context)!.idiom),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}