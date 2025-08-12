import 'package:argos_home/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:uuid/v4.dart';

// Utils
import 'package:argos_home/styles.dart' as styles;
import 'package:argos_home/tools/generics.dart' as generic_functions;

// Widgets
import 'package:argos_home/widgets/password_text_box.dart' as pass_text_box;
import 'package:argos_home/widgets/text_box.dart' as text_box;

// Views
import 'package:argos_home/views/login.dart' as login_view;

// Entities
import 'package:argos_home/domain/entity/access.dart' as access_entity;
import 'package:argos_home/domain/entity/profile.dart' as profile_entity;

// Services
import 'package:argos_home/domain/service/access.dart' as access_service;


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _passwordController;
  late final TextEditingController _repeatPasswordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _repeatPasswordController = TextEditingController();
    _nameController = TextEditingController();
    _lastNameController = TextEditingController();
    _usernameController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    _nameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;
      final repeatPassword = _repeatPasswordController.text;
      final name = _nameController.text;
      final lastName = _lastNameController.text;
      final username = _usernameController.text;
      final phone = _phoneController.text;

      var response = await access_service.AccessService().create(profile_entity.User(
          id: UuidV4().generate(),
          email: email,
          password: password,
          repeatPassword: repeatPassword,
          name: name,
          lastName: lastName,
          username: username,
          phone: phone,
          imageUrl: "",
          description: "",
          updatedAt: DateTime.now(),
      ));

      if (response == access_entity.CreateResponseType.DataNotValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.data_not_valid)),
        );
      } else if (response == access_entity.CreateResponseType.ServerConnection) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.server_connection)),
        );
      } else if (response == access_entity.CreateResponseType.UsernameAlreadyExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.username_already_exists)),
        );
      } else if (response == access_entity.CreateResponseType.EmailAlreadyExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.email_already_exists)),
        );
      } else if (response == access_entity.CreateResponseType.CreatedSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.created_correctly)),
        );
        Navigator.push(context, MaterialPageRoute(builder: (context) => login_view.LoginScreen()));
      }
    }
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
                child: SingleChildScrollView(child: columnForm()),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column columnForm() {
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
            AppLocalizations.of(context)!.welcome,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: styles.kPrimaryColor,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat'
            )
        ),
        Text(
            AppLocalizations.of(context)!.complete_the_form,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: styles.kPrimaryColor,
                fontSize: 16
            )
        ),
        const SizedBox(height: 48),

        text_box.InputField(
          controller: _usernameController,
          textInputType: TextInputType.text,
          labelTextContext: (BuildContext context) => AppLocalizations.of(context)!.username,
          hintTextContext: (BuildContext context) => "my.username",
          validators: [
            generic_functions.wrapAndCheckValidation(
              generic_functions.itNotMayBeClear,
                  (BuildContext context) => AppLocalizations.of(context)!.username_is_required_message,
            ),
            generic_functions.wrapAndCheckValidation(
              generic_functions.itMayNotHaveSpecialCharacters,
                  (BuildContext context) => AppLocalizations.of(context)!.it_may_not_have_special_characters,
            ),
            generic_functions.wrapAndCheckValidation(
              generic_functions.itMayNotHaveSpaces,
                  (BuildContext context) => AppLocalizations.of(context)!.it_may_not_have_spaces,
            ),
          ],
        ),
        const SizedBox(height: 24),

        text_box.InputField(
          controller: _nameController,
          textInputType: TextInputType.text,
          labelTextContext: (BuildContext context) => AppLocalizations.of(context)!.name,
          hintTextContext: (BuildContext context) => "John",
          validators: [
            generic_functions.wrapAndCheckValidation(
              generic_functions.itNotMayBeClear,
                  (BuildContext context) => AppLocalizations.of(context)!.it_may_not_be_clear,
            ),
          ],
        ),
        const SizedBox(height: 24),

        text_box.InputField(
          controller: _lastNameController,
          textInputType: TextInputType.text,
          labelTextContext: (BuildContext context) => AppLocalizations.of(context)!.last_name,
          hintTextContext: (BuildContext context) => "Doe",
          validators: [
            generic_functions.wrapAndCheckValidation(
              generic_functions.itNotMayBeClear,
                  (BuildContext context) => AppLocalizations.of(context)!.it_may_not_be_clear,
            ),
          ],
        ),
        const SizedBox(height: 24),

        text_box.InputField(
          controller: _phoneController,
          textInputType: TextInputType.phone,
          labelTextContext: (BuildContext context) => AppLocalizations.of(context)!.phone,
          hintTextContext: (BuildContext context) => "23232323",
          validators: [
            generic_functions.wrapAndCheckValidation(
              generic_functions.itNotMayBeClear,
                  (BuildContext context) => AppLocalizations.of(context)!.it_may_not_be_clear,
            ),
            generic_functions.wrapAndCheckValidation(
              generic_functions.itMayNotHaveSpecialCharacters,
                  (BuildContext context) => AppLocalizations.of(context)!.it_may_not_have_special_characters,
            ),
            generic_functions.wrapAndCheckValidation(
              generic_functions.itMayNotHaveSpaces,
                  (BuildContext context) => AppLocalizations.of(context)!.it_may_not_have_spaces,
            ),
            generic_functions.wrapAndCheckValidation(
              generic_functions.itMayBeNumber,
                  (BuildContext context) => AppLocalizations.of(context)!.it_may_be_number,
            ),
          ],
        ),
        const SizedBox(height: 24),

        text_box.InputField(
          controller: _emailController,
          textInputType: TextInputType.emailAddress,
          labelTextContext: (BuildContext context) => AppLocalizations.of(context)!.email,
          hintTextContext: (BuildContext context) => "a.email@example.co",
          validators: [
            generic_functions.wrapAndCheckValidation(
                generic_functions.itNotMayBeClear,
                    (BuildContext context) => (
                    AppLocalizations.of(context)!.please_insert_your_email
                )
            ),
            generic_functions.wrapAndCheckValidation(
                generic_functions.itMayBeAEmail,
                    (BuildContext context) => (
                    AppLocalizations.of(context)!.please_insert_a_valid_email
                )
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

        pass_text_box.PasswordInputField(
            controller: _repeatPasswordController,
            labelTextContext: (BuildContext context) => AppLocalizations.of(context)!.repeat_password,
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
                  AppLocalizations.of(context)!.repeat_password,
                  6,
                ),
              )
            ]
        ),
        const SizedBox(height: 32),

        ElevatedButton(
          onPressed: _register,
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
              AppLocalizations.of(context)!.register,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              )
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}