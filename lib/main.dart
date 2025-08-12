import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Security
import 'package:argos_home/tools/service_locator.dart' as service_locator;

// Views
import 'package:argos_home/app.dart' as app;


void main() {
  service_locator.setupLocator();
  runApp(ProviderScope(child: const app.MyApp()));
}