import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Styles
import 'package:argos_home/styles.dart' as styles;

// Views
import 'package:argos_home/views/utils/router.dart' as router;

// Providers
import 'package:argos_home/providers/profile_provider.dart' as profile_provider;


class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final bool wantNotifications;
  final bool wantProfile;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.wantNotifications = true,
    this.wantProfile = true,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageUrlAsync = ref.watch(profile_provider.profileImageUrlProvider);

    return AppBar(
      title: Text(title),
      backgroundColor: styles.kAccentColor,
      actions: [
        if (wantNotifications) _buildNotificationButton(context),
        if (wantProfile) _buildProfileButton(context, imageUrlAsync),
      ],
    );
  }

  Widget _buildNotificationButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, router.Routes.notifications),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          const SizedBox(
            width: 50,
            height: 50,
            child: Icon(Icons.add_alert_sharp, size: 35),
          ),
          Positioned(
            top: -3,
            right: 2,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Text(
                '+9',
                style: TextStyle(color: Colors.white, fontSize: 11),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileButton(BuildContext context, AsyncValue<String?> imageUrlAsync) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, router.Routes.profile),
      child: Container(
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: styles.kPrimaryColor,
            width: 2.0,
          ),
        ),
        child: ClipOval(
          child: imageUrlAsync.when(
            loading: () => const SizedBox(
              width: 50,
              height: 50,
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            error: (_, __) => const CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, color: Colors.white),
            ),
            data: (url) {
              if (url == null) {
                return const CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white),
                );
              }
              return CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                width: 50,
                height: 50,
                placeholder: (context, url) => const CircularProgressIndicator(strokeWidth: 2),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              );
            },
          ),
        ),
      ),
    );
  }
}