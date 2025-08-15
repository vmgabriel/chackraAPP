import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Views
import 'package:argos_home/views/login.dart' as login_view;
import 'package:argos_home/views/home.dart' as home_view;

// Auth Adapters
import '../tools/auth_service.dart';
import '../tools/service_locator.dart';

// Service
import 'package:argos_home/domain/service/access.dart' as access_service;


const CURRENT_LOGIN = login_view.LoginScreen();
const CURRENT_HOME = home_view.HomeView();
const int maxErrorCounter = 4;
const in_my_pc = false;


Future<bool> useBiometric(BuildContext context, AuthService auth) async {
  if (in_my_pc) {
    return true;
  }
  if (!await auth.canCheckBiometrics) {
    showDialog(context: context, builder: (context) => Text(AppLocalizations.of(context)!.not_supported));
    return false;
  }
  final ok = await auth.authenticate();
  if (ok) {
    return true;
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.failed_authentication)),
    );
    return false;
  }
}


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final auth = getIt<AuthService>();

  @override
  void initState() {
    super.initState();
    navigateToNextScreen();
  }

  void navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 2));
    final isLoggedIn = await checkLoginStatus();

    if (isLoggedIn && await useBiometric(context, auth)) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CURRENT_HOME),
      );
    } else if (!await hasCounter()) {
      print("No require counter");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CURRENT_LOGIN),
      );
    } else {
      bool maxTries = false;
      while (!maxTries) {
        if (isLoggedIn && await useBiometric(context, auth)) {
          return;
        } else {
          await increaseErrorCounter();
        }
        if (await getErrorCounter() >= maxErrorCounter) {
          maxTries = true;
        }
      }
      if (maxTries) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.too_much_tries_failed)),
        );
        await access_service.AccessService().logout();
        await resetErrorCounter();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CURRENT_LOGIN),
        );
      }
    }
  }

  Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("email") == null ? false : true;
  }

  Future<int> getErrorCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("error_counter") ?? 0;
  }

  Future<bool> hasCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey("error_counter");
  }

  Future<void> increaseErrorCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var currentCounter = await getErrorCounter();
    prefs.setInt("error_counter", currentCounter + 1);
  }

  Future<void> resetErrorCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("error_counter", 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.network("https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fpbs.twimg.com%2Fprofile_images%2F1260649719640076289%2FBzL686oM_400x400.jpg&f=1&nofb=1&ipt=df9a94660e8aea027f406d48b199fe57ea845b09ffce0463f5a505393d6072fb")
      ),
    );
  }
}