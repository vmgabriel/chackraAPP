import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @start_session_to_continue.
  ///
  /// In en, this message translates to:
  /// **'Login for Continue'**
  String get start_session_to_continue;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @are_you_forget_the_password.
  ///
  /// In en, this message translates to:
  /// **'Are You Forget The Password?'**
  String get are_you_forget_the_password;

  /// No description provided for @insert_your_password.
  ///
  /// In en, this message translates to:
  /// **'Insert you password'**
  String get insert_your_password;

  /// No description provided for @please_insert_your_password.
  ///
  /// In en, this message translates to:
  /// **'Please, Insert your password'**
  String get please_insert_your_password;

  /// Message for describe the requests
  ///
  /// In en, this message translates to:
  /// **'{gender, select, male{The} female{The} other{The}} {field} has to have at least {count, plural, =1{1 character} other{{count} characters}}'**
  String field_require_least(String gender, String field, num count);

  /// No description provided for @please_insert_your_email.
  ///
  /// In en, this message translates to:
  /// **'Please, Insert your Email'**
  String get please_insert_your_email;

  /// No description provided for @please_insert_a_valid_email.
  ///
  /// In en, this message translates to:
  /// **'Please, Insert a Valid Email'**
  String get please_insert_a_valid_email;

  /// No description provided for @im_new.
  ///
  /// In en, this message translates to:
  /// **'I\'m New, I Want Signup'**
  String get im_new;

  /// No description provided for @repeat_password.
  ///
  /// In en, this message translates to:
  /// **'Repeat Password'**
  String get repeat_password;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get register;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @last_name.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get last_name;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @complete_the_form.
  ///
  /// In en, this message translates to:
  /// **'Complete the Form for Register'**
  String get complete_the_form;

  /// No description provided for @on_building.
  ///
  /// In en, this message translates to:
  /// **'On Building'**
  String get on_building;

  /// No description provided for @soon_view_will_be_complete.
  ///
  /// In en, this message translates to:
  /// **'Soon this view will be complete'**
  String get soon_view_will_be_complete;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @home_view.
  ///
  /// In en, this message translates to:
  /// **'Home View'**
  String get home_view;

  /// No description provided for @show_notifications.
  ///
  /// In en, this message translates to:
  /// **'Show Notifications'**
  String get show_notifications;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @tasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasks;

  /// No description provided for @edit_profile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get edit_profile;

  /// No description provided for @biography.
  ///
  /// In en, this message translates to:
  /// **'Biography'**
  String get biography;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @configurations.
  ///
  /// In en, this message translates to:
  /// **'Configurations'**
  String get configurations;

  /// No description provided for @help_and_contact.
  ///
  /// In en, this message translates to:
  /// **'Help And Contact'**
  String get help_and_contact;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @dark_mode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get dark_mode;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @change_password.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get change_password;

  /// No description provided for @authentication_with_biometric.
  ///
  /// In en, this message translates to:
  /// **'Authentication with Biometric'**
  String get authentication_with_biometric;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @idiom.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get idiom;

  /// No description provided for @boards.
  ///
  /// In en, this message translates to:
  /// **'Boards'**
  String get boards;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @search_in_board.
  ///
  /// In en, this message translates to:
  /// **'Search in Board'**
  String get search_in_board;

  /// No description provided for @loading_boards.
  ///
  /// In en, this message translates to:
  /// **'Loading boards...'**
  String get loading_boards;

  /// No description provided for @not_found_boards_with_query.
  ///
  /// In en, this message translates to:
  /// **'No boards found with query'**
  String get not_found_boards_with_query;

  /// No description provided for @not_found_boards.
  ///
  /// In en, this message translates to:
  /// **'No Found Boards'**
  String get not_found_boards;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @all_loaded.
  ///
  /// In en, this message translates to:
  /// **'All Information Loaded'**
  String get all_loaded;

  /// No description provided for @username_is_required_message.
  ///
  /// In en, this message translates to:
  /// **'Username Is Required'**
  String get username_is_required_message;

  /// No description provided for @it_may_not_have_spaces.
  ///
  /// In en, this message translates to:
  /// **'It May Not Have Spaces'**
  String get it_may_not_have_spaces;

  /// No description provided for @it_may_not_have_special_characters.
  ///
  /// In en, this message translates to:
  /// **'It May Not Have Special Characters'**
  String get it_may_not_have_special_characters;

  /// No description provided for @it_may_not_be_clear.
  ///
  /// In en, this message translates to:
  /// **'It May Not Be Clear'**
  String get it_may_not_be_clear;

  /// No description provided for @it_may_be_number.
  ///
  /// In en, this message translates to:
  /// **'It May Be Number'**
  String get it_may_be_number;

  /// No description provided for @invalid_authentication.
  ///
  /// In en, this message translates to:
  /// **'Invalid Authentication'**
  String get invalid_authentication;

  /// No description provided for @error_in_server_or_internet.
  ///
  /// In en, this message translates to:
  /// **'Error in server or internet'**
  String get error_in_server_or_internet;

  /// No description provided for @data_not_valid.
  ///
  /// In en, this message translates to:
  /// **'Data Not Valid'**
  String get data_not_valid;

  /// No description provided for @server_connection.
  ///
  /// In en, this message translates to:
  /// **'Error in Connection with Server'**
  String get server_connection;

  /// No description provided for @username_already_exists.
  ///
  /// In en, this message translates to:
  /// **'Username Has Already Exists'**
  String get username_already_exists;

  /// No description provided for @email_already_exists.
  ///
  /// In en, this message translates to:
  /// **'Email Has Already Exists'**
  String get email_already_exists;

  /// No description provided for @created_correctly.
  ///
  /// In en, this message translates to:
  /// **'Created Correctly'**
  String get created_correctly;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
