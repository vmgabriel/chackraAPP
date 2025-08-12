import 'package:flutter_riverpod/flutter_riverpod.dart';

// Entity
import 'package:argos_home/domain/entity/profile.dart' as profile_entity;

// Services
import 'package:argos_home/domain/service/access.dart' as access_service;

// Infra
import 'package:argos_home/infra/builder.dart' as builder_infra;


final profileImageUrlProvider = FutureProvider<String?>((ref) async {
  final builder = builder_infra.InfraBuilder.build();
  final service = access_service.AccessService(infraBuilder: builder);
  try {
    final url = await service.getImageUrl();
    return url;
  } catch (e) {
    return null;
  }
});

final profileProvider = FutureProvider<profile_entity.Profile?>((ref) async {
  final builder = builder_infra.InfraBuilder.build();
  final service = access_service.AccessService(infraBuilder: builder);
  try {
    return await service.getProfile();
  } catch (e) {
    return null;
  }
});