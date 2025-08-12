import 'package:flutter/material.dart';
import 'package:argos_home/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Styles
import 'package:argos_home/styles.dart' as styles;

// utils
import 'package:argos_home/views/utils/router.dart' as router;

// Views
import 'package:argos_home/splash_screen.dart' as splash_screen;
import 'package:argos_home/views/utils/app_bar.dart' as appbar;

// Providers
import 'package:argos_home/providers/profile_provider.dart' as profile_provider;

// Services
import 'package:argos_home/domain/service/access.dart' as access_service;


Future<void> logout(BuildContext context) async {
  await access_service.AccessService().logout();
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => splash_screen.SplashScreen()),
  );
}


class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  Future<void> _editProfile(WidgetRef ref, BuildContext context) async {
    final currentProfile = ref.read(profile_provider.profileProvider.future);
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        final controllerName = TextEditingController();
        final controllerBio = TextEditingController();

        ref.watch(profile_provider.profileProvider).whenData((profile) {
          controllerName.text = profile != null ? profile.name : "";
          controllerBio.text = profile != null ? profile.description : "";
        });

        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.edit_profile),
          content: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: controllerName,
                  decoration: InputDecoration(labelText: AppLocalizations.of(context)!.name),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: controllerBio,
                  decoration: InputDecoration(labelText: AppLocalizations.of(context)!.biography),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(AppLocalizations.of(context)!.save),
            ),
          ],
        );
      },
    );

    if (result == true) {
      // Aquí llamarías a un servicio para guardar
      // Ej: await access_service.AccessService().updateProfile(...)
      // Y refrescar el provider
      ref.invalidate(profile_provider.profileProvider); // ← Recarga el perfil
    }
  }

  Widget _buildOption(
      IconData icon,
      String label,
      VoidCallback onTap, {
        Color? color
      }) {
    return ListTile(
      leading: Icon(icon, color: color ?? styles.kAccentColor),
      title: Text(label),
      trailing: Icon(Icons.chevron_right),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      hoverColor: Colors.grey.shade100,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mq = MediaQuery.of(context);
    final profileAsync = ref.watch(profile_provider.profileProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: appbar.CustomAppBar(
        title: AppLocalizations.of(context)!.profile,
        wantProfile: false,
        wantNotifications: false,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: mq.size.height * 0.23,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [styles.kAccentColor, styles.kPrimaryColor],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
          ),
          SafeArea(
            child: profileAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text('Error al cargar el perfil: $err'),
                    TextButton(
                      onPressed: () => ref.invalidate(profile_provider.profileProvider),
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
              data: (user) => SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: styles.kPrimaryColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 8,
                              color: Colors.black.withOpacity(0.15),
                            )
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 52,
                          backgroundColor: styles.kPrimaryColor,
                          backgroundImage: user!.imageUrl.isNotEmpty
                              ? NetworkImage(user.imageUrl)
                              : null,
                          child: user.imageUrl.isEmpty
                              ? Text(
                            user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: styles.kWhiteColor,
                            ),
                          )
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user.name + " " + user.lastName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: styles.kWhiteColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.username,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: styles.kAccentColor),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        user.description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => _editProfile(ref, context),
                      icon: Icon(Icons.edit, color: styles.kAccentColor),
                      label: Text(
                        AppLocalizations.of(context)!.edit_profile,
                        style: TextStyle(color: styles.kAccentColor),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        minimumSize: const Size(160, 44),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Divider(color: Colors.grey.shade300),
                    const SizedBox(height: 16),
                    _buildOption(
                      Icons.settings,
                      AppLocalizations.of(context)!.configurations,
                          () {
                        Navigator.pushNamed(context, router.Routes.settings);
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildOption(
                      Icons.help_outline,
                      AppLocalizations.of(context)!.help_and_contact,
                          () {
                        Navigator.pushNamed(context, router.Routes.help);
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildOption(
                      Icons.logout,
                      AppLocalizations.of(context)!.logout,
                          () {
                        logout(context);
                      },
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}