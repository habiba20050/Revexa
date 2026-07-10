import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

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
    Locale('ar'),
    Locale('en')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Revexa'**
  String get appTitle;

  /// No description provided for @servicesPrecisionCare.
  ///
  /// In en, this message translates to:
  /// **'Precision Care'**
  String get servicesPrecisionCare;

  /// No description provided for @servicesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select from our executive automotive services'**
  String get servicesSubtitle;

  /// No description provided for @servicesSearch.
  ///
  /// In en, this message translates to:
  /// **'Search services...'**
  String get servicesSearch;

  /// No description provided for @servicesCatWash.
  ///
  /// In en, this message translates to:
  /// **'Wash'**
  String get servicesCatWash;

  /// No description provided for @servicesCatMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get servicesCatMaintenance;

  /// No description provided for @servicesCatTires.
  ///
  /// In en, this message translates to:
  /// **'Tires'**
  String get servicesCatTires;

  /// No description provided for @servicesCatOil.
  ///
  /// In en, this message translates to:
  /// **'Oil'**
  String get servicesCatOil;

  /// No description provided for @servicesCatBattery.
  ///
  /// In en, this message translates to:
  /// **'Battery'**
  String get servicesCatBattery;

  /// No description provided for @servicesNoFound.
  ///
  /// In en, this message translates to:
  /// **'No services found'**
  String get servicesNoFound;

  /// No description provided for @servicesFeatured.
  ///
  /// In en, this message translates to:
  /// **'FEATURED'**
  String get servicesFeatured;

  /// No description provided for @servicesFromPrice.
  ///
  /// In en, this message translates to:
  /// **'From \${price}'**
  String servicesFromPrice(String price);

  /// No description provided for @servicesBookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get servicesBookNow;

  /// No description provided for @servicesConciergeTitle.
  ///
  /// In en, this message translates to:
  /// **'Custom Fleet Care?'**
  String get servicesConciergeTitle;

  /// No description provided for @servicesConciergeBody.
  ///
  /// In en, this message translates to:
  /// **'Our concierge team is available 24/7 for custom maintenance plans.'**
  String get servicesConciergeBody;

  /// No description provided for @servicesContactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get servicesContactUs;

  /// No description provided for @servicesViewFaq.
  ///
  /// In en, this message translates to:
  /// **'View FAQ'**
  String get servicesViewFaq;

  /// No description provided for @updates.
  ///
  /// In en, this message translates to:
  /// **'Updates'**
  String get updates;

  /// No description provided for @updatesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Stay informed about your fleet and services.'**
  String get updatesSubtitle;

  /// No description provided for @updatesRecent.
  ///
  /// In en, this message translates to:
  /// **'RECENT'**
  String get updatesRecent;

  /// No description provided for @updatesEarlier.
  ///
  /// In en, this message translates to:
  /// **'EARLIER'**
  String get updatesEarlier;

  /// No description provided for @updatesNew.
  ///
  /// In en, this message translates to:
  /// **'{n} New'**
  String updatesNew(int n);

  /// No description provided for @updatesVehicleAlert.
  ///
  /// In en, this message translates to:
  /// **'Vehicle health alert'**
  String get updatesVehicleAlert;

  /// No description provided for @updatesBookingConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Booking confirmation'**
  String get updatesBookingConfirmed;

  /// No description provided for @updatesServiceReminder.
  ///
  /// In en, this message translates to:
  /// **'Service reminder'**
  String get updatesServiceReminder;

  /// No description provided for @updatesPlatformNews.
  ///
  /// In en, this message translates to:
  /// **'Platform news'**
  String get updatesPlatformNews;

  /// No description provided for @updatesServiceCompleted.
  ///
  /// In en, this message translates to:
  /// **'Service Completed'**
  String get updatesServiceCompleted;

  /// No description provided for @updatesFeatured.
  ///
  /// In en, this message translates to:
  /// **'FEATURED'**
  String get updatesFeatured;

  /// No description provided for @updatesViewDiagnostic.
  ///
  /// In en, this message translates to:
  /// **'View Diagnostic'**
  String get updatesViewDiagnostic;

  /// No description provided for @updatesSchedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get updatesSchedule;

  /// No description provided for @updatesYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get updatesYesterday;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsMarkAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get notificationsMarkAllRead;

  /// No description provided for @notificationsAllCaughtUp.
  ///
  /// In en, this message translates to:
  /// **'All caught up!'**
  String get notificationsAllCaughtUp;

  /// No description provided for @notificationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No notifications right now.'**
  String get notificationsEmpty;

  /// No description provided for @notificationsNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get notificationsNew;

  /// No description provided for @notificationsEarlier.
  ///
  /// In en, this message translates to:
  /// **'Earlier'**
  String get notificationsEarlier;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Executive Automotive Care'**
  String get appTagline;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get navServices;

  /// No description provided for @navBookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get navBookings;

  /// No description provided for @navUpdates.
  ///
  /// In en, this message translates to:
  /// **'Updates'**
  String get navUpdates;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @joinRevexa.
  ///
  /// In en, this message translates to:
  /// **'Join Revexa'**
  String get joinRevexa;

  /// No description provided for @premiumCarManagement.
  ///
  /// In en, this message translates to:
  /// **'The premium standard for car management'**
  String get premiumCarManagement;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @emailPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'name@company.com'**
  String get emailPlaceholder;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get emailInvalid;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPasswordTitle;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'OR CONTINUE WITH'**
  String get orContinueWith;

  /// No description provided for @securedEncryption.
  ///
  /// In en, this message translates to:
  /// **'SECURED 256-BIT SSL ENCRYPTION'**
  String get securedEncryption;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get noAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @agreeToTerms.
  ///
  /// In en, this message translates to:
  /// **'By signing up, you agree to our '**
  String get agreeToTerms;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get and;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @companyName.
  ///
  /// In en, this message translates to:
  /// **'Company Name'**
  String get companyName;

  /// No description provided for @accountType.
  ///
  /// In en, this message translates to:
  /// **'Account Type'**
  String get accountType;

  /// No description provided for @personalAccount.
  ///
  /// In en, this message translates to:
  /// **'Personal Account'**
  String get personalAccount;

  /// No description provided for @companyAccount.
  ///
  /// In en, this message translates to:
  /// **'Company Account'**
  String get companyAccount;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @minCharacters.
  ///
  /// In en, this message translates to:
  /// **'Min {n} characters'**
  String minCharacters(int n);

  /// No description provided for @minAge.
  ///
  /// In en, this message translates to:
  /// **'Min age: 18'**
  String get minAge;

  /// No description provided for @createMyAccount.
  ///
  /// In en, this message translates to:
  /// **'Create My Account'**
  String get createMyAccount;

  /// No description provided for @addServiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Service'**
  String get addServiceTitle;

  /// No description provided for @serviceAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Service added successfully'**
  String get serviceAddedSuccessfully;

  /// No description provided for @serviceTitle.
  ///
  /// In en, this message translates to:
  /// **'Service Title'**
  String get serviceTitle;

  /// No description provided for @serviceTitlePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter service title'**
  String get serviceTitlePlaceholder;

  /// No description provided for @serviceDescription.
  ///
  /// In en, this message translates to:
  /// **'Service Description'**
  String get serviceDescription;

  /// No description provided for @serviceDescriptionPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Describe your service'**
  String get serviceDescriptionPlaceholder;

  /// No description provided for @servicePrice.
  ///
  /// In en, this message translates to:
  /// **'Service Price'**
  String get servicePrice;

  /// No description provided for @saveService.
  ///
  /// In en, this message translates to:
  /// **'Save Service'**
  String get saveService;

  /// No description provided for @serviceCategoryHint.
  ///
  /// In en, this message translates to:
  /// **'Select category'**
  String get serviceCategoryHint;

  /// No description provided for @serviceCategory.
  ///
  /// In en, this message translates to:
  /// **'Service Category'**
  String get serviceCategory;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get goodEvening;

  /// No description provided for @goldMember.
  ///
  /// In en, this message translates to:
  /// **'Gold Member'**
  String get goldMember;

  /// No description provided for @vehicleStatus.
  ///
  /// In en, this message translates to:
  /// **'VEHICLE STATUS'**
  String get vehicleStatus;

  /// No description provided for @optimal.
  ///
  /// In en, this message translates to:
  /// **'OPTIMAL'**
  String get optimal;

  /// No description provided for @engine.
  ///
  /// In en, this message translates to:
  /// **'Engine'**
  String get engine;

  /// No description provided for @battery.
  ///
  /// In en, this message translates to:
  /// **'Battery'**
  String get battery;

  /// No description provided for @tyres.
  ///
  /// In en, this message translates to:
  /// **'Tyres'**
  String get tyres;

  /// No description provided for @quickWash.
  ///
  /// In en, this message translates to:
  /// **'Wash'**
  String get quickWash;

  /// No description provided for @quickService.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get quickService;

  /// No description provided for @quickTires.
  ///
  /// In en, this message translates to:
  /// **'Tires'**
  String get quickTires;

  /// No description provided for @quickMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get quickMore;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @noServicesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No services available'**
  String get noServicesAvailable;

  /// No description provided for @activeBooking.
  ///
  /// In en, this message translates to:
  /// **'Active Booking'**
  String get activeBooking;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @limitedOffer.
  ///
  /// In en, this message translates to:
  /// **'LIMITED OFFER'**
  String get limitedOffer;

  /// No description provided for @summerShinePackage.
  ///
  /// In en, this message translates to:
  /// **'Summer Shine\nPackage'**
  String get summerShinePackage;

  /// No description provided for @claimNow.
  ///
  /// In en, this message translates to:
  /// **'CLAIM NOW'**
  String get claimNow;

  /// No description provided for @bookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get bookings;

  /// No description provided for @bookingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your service appointments.'**
  String get bookingsSubtitle;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @past.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get past;

  /// No description provided for @noUpcomingAppointments.
  ///
  /// In en, this message translates to:
  /// **'No upcoming appointments'**
  String get noUpcomingAppointments;

  /// No description provided for @noPastAppointments.
  ///
  /// In en, this message translates to:
  /// **'No past appointments'**
  String get noPastAppointments;

  /// No description provided for @nextAppointments.
  ///
  /// In en, this message translates to:
  /// **'Next Appointments'**
  String get nextAppointments;

  /// No description provided for @bookFirst.
  ///
  /// In en, this message translates to:
  /// **'Book your first service'**
  String get bookFirst;

  /// No description provided for @bookNew.
  ///
  /// In en, this message translates to:
  /// **'BOOK NEW'**
  String get bookNew;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @vehicles.
  ///
  /// In en, this message translates to:
  /// **'Vehicles'**
  String get vehicles;

  /// No description provided for @memberships.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get memberships;

  /// No description provided for @member.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get member;

  /// No description provided for @accountManagement.
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT MANAGEMENT'**
  String get accountManagement;

  /// No description provided for @myVehicles.
  ///
  /// In en, this message translates to:
  /// **'My Vehicles'**
  String get myVehicles;

  /// No description provided for @myVehiclesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your fleet'**
  String get myVehiclesSubtitle;

  /// No description provided for @serviceHistory.
  ///
  /// In en, this message translates to:
  /// **'Service History'**
  String get serviceHistory;

  /// No description provided for @serviceHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Past appointments'**
  String get serviceHistorySubtitle;

  /// No description provided for @payments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get payments;

  /// No description provided for @paymentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Cards & wallets'**
  String get paymentsSubtitle;

  /// No description provided for @addresses.
  ///
  /// In en, this message translates to:
  /// **'Addresses'**
  String get addresses;

  /// No description provided for @addressesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Saved locations'**
  String get addressesSubtitle;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'PREFERENCES'**
  String get preferences;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @darkModeCurrent.
  ///
  /// In en, this message translates to:
  /// **'Currently dark'**
  String get darkModeCurrent;

  /// No description provided for @lightModeCurrent.
  ///
  /// In en, this message translates to:
  /// **'Currently light'**
  String get lightModeCurrent;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get languageArabic;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @settingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'App preferences'**
  String get settingsSubtitle;

  /// No description provided for @helpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get helpCenter;

  /// No description provided for @helpCenterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'FAQ & support'**
  String get helpCenterSubtitle;

  /// No description provided for @confirmSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get confirmSignOut;

  /// No description provided for @confirmSignOutMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get confirmSignOutMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'Version 2.4.1 (Build 884)'**
  String get appVersion;

  /// No description provided for @settingsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Settings Coming Soon'**
  String get settingsComingSoon;

  /// No description provided for @userManagement.
  ///
  /// In en, this message translates to:
  /// **'User Management'**
  String get userManagement;

  /// No description provided for @userManagementSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage app users'**
  String get userManagementSubtitle;

  /// No description provided for @noUsersFound.
  ///
  /// In en, this message translates to:
  /// **'No users found'**
  String get noUsersFound;

  /// No description provided for @deleteUserConfirmationTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete User'**
  String get deleteUserConfirmationTitle;

  /// No description provided for @deleteUserConfirmationBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this user? This action cannot be undone.'**
  String get deleteUserConfirmationBody;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @unexpectedState.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get unexpectedState;
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
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
