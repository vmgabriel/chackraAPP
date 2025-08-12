// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcome => 'Welcome';

  @override
  String get start_session_to_continue => 'Login for Continue';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get login => 'Login';

  @override
  String get are_you_forget_the_password => 'Are You Forget The Password?';

  @override
  String get insert_your_password => 'Insert you password';

  @override
  String get please_insert_your_password => 'Please, Insert your password';

  @override
  String field_require_least(String gender, String field, num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.selectLogic(gender, {
      'male': 'The',
      'female': 'The',
      'other': 'The',
    });
    String _temp1 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString characters',
      one: '1 character',
    );
    return '$_temp0 $field has to have at least $_temp1';
  }

  @override
  String get please_insert_your_email => 'Please, Insert your Email';

  @override
  String get please_insert_a_valid_email => 'Please, Insert a Valid Email';

  @override
  String get im_new => 'I\'m New, I Want Signup';

  @override
  String get repeat_password => 'Repeat Password';

  @override
  String get register => 'Sign Up';

  @override
  String get username => 'Username';

  @override
  String get name => 'Name';

  @override
  String get last_name => 'Last Name';

  @override
  String get phone => 'Phone';

  @override
  String get complete_the_form => 'Complete the Form for Register';

  @override
  String get on_building => 'On Building';

  @override
  String get soon_view_will_be_complete => 'Soon this view will be complete';

  @override
  String get home => 'Home';

  @override
  String get home_view => 'Home View';

  @override
  String get show_notifications => 'Show Notifications';

  @override
  String get menu => 'Menu';

  @override
  String get tasks => 'Tasks';

  @override
  String get edit_profile => 'Edit Profile';

  @override
  String get biography => 'Biography';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get profile => 'Profile';

  @override
  String get configurations => 'Configurations';

  @override
  String get help_and_contact => 'Help And Contact';

  @override
  String get logout => 'Logout';

  @override
  String get preferences => 'Preferences';

  @override
  String get dark_mode => 'Dark Mode';

  @override
  String get account => 'Account';

  @override
  String get change_password => 'Change Password';

  @override
  String get authentication_with_biometric => 'Authentication with Biometric';

  @override
  String get general => 'General';

  @override
  String get notifications => 'Notifications';

  @override
  String get idiom => 'Language';

  @override
  String get boards => 'Boards';

  @override
  String get search => 'Search';

  @override
  String get search_in_board => 'Search in Board';

  @override
  String get loading_boards => 'Loading boards...';

  @override
  String get not_found_boards_with_query => 'No boards found with query';

  @override
  String get not_found_boards => 'No Found Boards';

  @override
  String get loading => 'Loading';

  @override
  String get all_loaded => 'All Information Loaded';

  @override
  String get username_is_required_message => 'Username Is Required';

  @override
  String get it_may_not_have_spaces => 'It May Not Have Spaces';

  @override
  String get it_may_not_have_special_characters =>
      'It May Not Have Special Characters';

  @override
  String get it_may_not_be_clear => 'It May Not Be Clear';

  @override
  String get it_may_be_number => 'It May Be Number';

  @override
  String get invalid_authentication => 'Invalid Authentication';

  @override
  String get error_in_server_or_internet => 'Error in server or internet';

  @override
  String get data_not_valid => 'Data Not Valid';

  @override
  String get server_connection => 'Error in Connection with Server';

  @override
  String get username_already_exists => 'Username Has Already Exists';

  @override
  String get email_already_exists => 'Email Has Already Exists';

  @override
  String get created_correctly => 'Created Correctly';
}
