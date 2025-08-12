import 'package:argos_home/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Utils
import 'package:argos_home/styles.dart' as styles;
import 'package:argos_home/tools/generics.dart' as generic_functions;

// Widgets
import 'package:argos_home/widgets/password_text_box.dart' as pass_text_box;
import 'package:argos_home/widgets/text_box.dart' as text_box;

// Views
import 'package:argos_home/views/home.dart' as home_view;
import 'package:argos_home/views/signup.dart' as signup_view;
import 'package:argos_home/views/utils/on_building.dart' as on_building_view;

// Entities
import 'package:argos_home/domain/entity/access.dart' as access_entity;

// Infra Connector
import 'package:argos_home/infra/builder.dart' as builder_infra;

// Services
import 'package:argos_home/domain/service/access.dart' as access_service;


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;

      var builder = builder_infra.InfraBuilder.build();
      var responseServer = await access_service.AccessService(infraBuilder: builder).login(email, password);

      if (responseServer == access_entity.LoginResponseType.DataNotValid) {
        _emailController.text = "";
        _passwordController.text = "";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.invalid_authentication)),
        );
      } else if (responseServer == access_entity.LoginResponseType.LoginSuccess) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => home_view.HomeView()),
        );
      } else {
        // Message of Internet or connection with Server error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.error_in_server_or_internet)),
        );
      }
    }
  }

  void _go_to_signup() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => signup_view.SignUpScreen()));
  }

  void _go_to_forget_password() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => on_building_view.OnBuildingScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: styles.kBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: columnForm(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column columnForm() {
    final String welcomeMsg = AppLocalizations.of(context)!.welcome;
    final String subtitleMsg = AppLocalizations.of(context)!.start_session_to_continue;
    final String emailLabel = AppLocalizations.of(context)!.email;
    final String emailError = AppLocalizations.of(context)!.please_insert_your_email;
    final String emailValidError = AppLocalizations.of(context)!.please_insert_a_valid_email;
    final String loginButton = AppLocalizations.of(context)!.login;
    final String imNewButton = AppLocalizations.of(context)!.im_new;
    final String forgetPasswordButton = AppLocalizations.of(context)!.are_you_forget_the_password;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(
            Icons.lock_outline,
            size: 80,
            color: styles.kPrimaryColor
        ),
        const SizedBox(height: 16),
        Text(
            welcomeMsg,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: styles.kPrimaryColor,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat'
            )
        ),
        Text(
            subtitleMsg,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: styles.kPrimaryColor,
                fontSize: 16
            )
        ),
        const SizedBox(height: 48),

        text_box.InputField(
          controller: _emailController,
          textInputType: TextInputType.emailAddress,
          labelTextContext: (BuildContext context) => emailLabel,
          hintTextContext: (BuildContext context) => "a.email@example.co",
          validators: [
            generic_functions.wrapAndCheckValidation(
                generic_functions.itNotMayBeClear,
                    (BuildContext context) => emailError,
            ),
            generic_functions.wrapAndCheckValidation(
                generic_functions.itMayBeAEmail,
                    (BuildContext context) => emailValidError
            ),
          ],
        ),
        const SizedBox(height: 24),

        pass_text_box.PasswordInputField(
            controller: _passwordController,
            labelTextContext: (BuildContext context) => AppLocalizations.of(context)!.password,
            hintTextContext: (BuildContext context) => AppLocalizations.of(context)!.insert_your_password,
            validators: [
              generic_functions.wrapAndCheckValidation(
                  generic_functions.itNotMayBeClear,
                      (BuildContext context) => AppLocalizations.of(context)!.please_insert_your_password,
              ),
              generic_functions.wrapAndCheckValidation(
                  generic_functions.itMayHaveAtLeast6Characters,
                  (BuildContext context) => AppLocalizations.of(context)!.field_require_least(
                    "female",
                    AppLocalizations.of(context)!.password,
                    6,
                  ),
              )
            ]
        ),
        const SizedBox(height: 32),

        ElevatedButton(
          onPressed: _login,
          style: ElevatedButton.styleFrom(
            backgroundColor: styles.kAccentColor,
            foregroundColor: styles.kWhiteColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
            ),
            elevation: 5,
          ),
          child: Text(
              loginButton,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              )
          ),
        ),
        const SizedBox(height: 16),

        TextButton(
          onPressed: _go_to_signup,
          child: Text(
              imNewButton,
              style: TextStyle(
                  color: styles.kPrimaryColor,
                  decoration: TextDecoration.underline
              )
          ),
        ),
        TextButton(
          onPressed: _go_to_forget_password,
          child: Text(
              forgetPasswordButton,
              style: TextStyle(
                  color: styles.kPrimaryColor,
                  decoration: TextDecoration.underline
              )
          ),
        ),
      ],
    );
  }
}