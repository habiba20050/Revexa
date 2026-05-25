// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'ريفيكسا';

  @override
  String get servicesPrecisionCare => 'عناية فائقة الدقة';

  @override
  String get servicesSubtitle => 'اختر من خدماتنا التنفيذية للسيارات';

  @override
  String get servicesSearch => 'البحث عن الخدمات...';

  @override
  String get servicesCatWash => 'غسيل';

  @override
  String get servicesCatMaintenance => 'صيانة';

  @override
  String get servicesCatTires => 'إطارات';

  @override
  String get servicesCatOil => 'زيت';

  @override
  String get servicesCatBattery => 'بطارية';

  @override
  String get servicesNoFound => 'لم يتم العثور على خدمات';

  @override
  String get servicesFeatured => 'مميز';

  @override
  String servicesFromPrice(String price) {
    return 'تبدأ من \$$price';
  }

  @override
  String get servicesBookNow => 'احجز الآن';

  @override
  String get servicesConciergeTitle => 'عناية مخصصة للأسطول؟';

  @override
  String get servicesConciergeBody =>
      'فريقنا المخصص متاح على مدار الساعة لخطط الصيانة المخصصة.';

  @override
  String get servicesContactUs => 'اتصل بنا';

  @override
  String get servicesViewFaq => 'الأسئلة الشائعة';

  @override
  String get updates => 'التحديثات';

  @override
  String get updatesSubtitle => 'ابقَ على اطلاع بأسطولك وخدماتك.';

  @override
  String get updatesRecent => 'الأخيرة';

  @override
  String get updatesEarlier => 'السابقة';

  @override
  String updatesNew(int n) {
    return '$n جديد';
  }

  @override
  String get updatesVehicleAlert => 'تنبيه صحة السيارة';

  @override
  String get updatesBookingConfirmed => 'تأكيد الحجز';

  @override
  String get updatesServiceReminder => 'تذكير بالخدمة';

  @override
  String get updatesPlatformNews => 'أخبار المنصة';

  @override
  String get updatesServiceCompleted => 'اكتملت الخدمة';

  @override
  String get updatesFeatured => 'مميز';

  @override
  String get updatesViewDiagnostic => 'عرض التشخيص';

  @override
  String get updatesSchedule => 'جدولة';

  @override
  String get updatesYesterday => 'أمس';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get notificationsMarkAllRead => 'تحديد الكل كمقروء';

  @override
  String get notificationsAllCaughtUp => 'أنت على اطلاع كامل!';

  @override
  String get notificationsEmpty => 'لا توجد إشعارات الآن.';

  @override
  String get notificationsNew => 'جديد';

  @override
  String get notificationsEarlier => 'السابقة';

  @override
  String get appTagline => 'رعاية السيارات التنفيذية';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navServices => 'الخدمات';

  @override
  String get navBookings => 'الحجوزات';

  @override
  String get navUpdates => 'التحديثات';

  @override
  String get navProfile => 'الملف الشخصي';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get joinRevexa => 'انضم إلى ريفيكسا';

  @override
  String get premiumCarManagement => 'المعيار الفاخر لإدارة السيارات';

  @override
  String get emailAddress => 'البريد الإلكتروني';

  @override
  String get emailPlaceholder => 'name@company.com';

  @override
  String get emailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get emailInvalid => 'أدخل بريدًا إلكترونيًا صحيحًا';

  @override
  String get password => 'كلمة المرور';

  @override
  String get passwordRequired => 'كلمة المرور مطلوبة';

  @override
  String get passwordMinLength => 'يجب أن تكون كلمة المرور 6 أحرف على الأقل';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get forgotPasswordTitle => 'نسيت كلمة المرور';

  @override
  String get orContinueWith => 'أو تابع باستخدام';

  @override
  String get securedEncryption => 'مشفّر بتقنية SSL 256-BIT';

  @override
  String get noAccount => 'ليس لديك حساب؟ ';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟ ';

  @override
  String get agreeToTerms => 'بالتسجيل، أنت توافق على ';

  @override
  String get termsOfService => 'شروط الخدمة';

  @override
  String get and => ' و';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get firstName => 'الاسم الأول';

  @override
  String get lastName => 'اسم العائلة';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get age => 'العمر';

  @override
  String get gender => 'الجنس';

  @override
  String get male => 'ذكر';

  @override
  String get female => 'أنثى';

  @override
  String get address => 'العنوان';

  @override
  String minCharacters(int n) {
    return 'الحد الأدنى $n أحرف';
  }

  @override
  String get minAge => 'الحد الأدنى للعمر: 18';

  @override
  String get createMyAccount => 'إنشاء حسابي';

  @override
  String get goodMorning => 'صباح الخير';

  @override
  String get goodAfternoon => 'مساء الخير';

  @override
  String get goodEvening => 'مساء النور';

  @override
  String get goldMember => 'عضو ذهبي';

  @override
  String get vehicleStatus => 'حالة السيارة';

  @override
  String get optimal => 'ممتاز';

  @override
  String get engine => 'المحرك';

  @override
  String get battery => 'البطارية';

  @override
  String get tyres => 'الإطارات';

  @override
  String get quickWash => 'غسيل';

  @override
  String get quickService => 'خدمة';

  @override
  String get quickTires => 'إطارات';

  @override
  String get quickMore => 'المزيد';

  @override
  String get services => 'الخدمات';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get noServicesAvailable => 'لا توجد خدمات متاحة';

  @override
  String get activeBooking => 'الحجز النشط';

  @override
  String get details => 'التفاصيل';

  @override
  String get limitedOffer => 'عرض محدود';

  @override
  String get summerShinePackage => 'باقة\nبريق الصيف';

  @override
  String get claimNow => 'احجز الآن';

  @override
  String get bookings => 'الحجوزات';

  @override
  String get bookingsSubtitle => 'إدارة مواعيد الخدمة الخاصة بك.';

  @override
  String get upcoming => 'القادمة';

  @override
  String get past => 'السابقة';

  @override
  String get noUpcomingAppointments => 'لا توجد مواعيد قادمة';

  @override
  String get noPastAppointments => 'لا توجد مواعيد سابقة';

  @override
  String get nextAppointments => 'المواعيد القادمة';

  @override
  String get bookFirst => 'احجز أول خدمة لك';

  @override
  String get bookNew => 'حجز جديد';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get profileTitle => 'الملف الشخصي';

  @override
  String get vehicles => 'السيارات';

  @override
  String get memberships => 'الخدمات';

  @override
  String get member => 'عضو';

  @override
  String get accountManagement => 'إدارة الحساب';

  @override
  String get myVehicles => 'سياراتي';

  @override
  String get myVehiclesSubtitle => 'إدارة أسطولك';

  @override
  String get serviceHistory => 'سجل الخدمات';

  @override
  String get serviceHistorySubtitle => 'المواعيد السابقة';

  @override
  String get payments => 'المدفوعات';

  @override
  String get paymentsSubtitle => 'البطاقات والمحافظ';

  @override
  String get addresses => 'العناوين';

  @override
  String get addressesSubtitle => 'المواقع المحفوظة';

  @override
  String get preferences => 'التفضيلات';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get darkModeCurrent => 'الوضع الداكن مفعّل';

  @override
  String get lightModeCurrent => 'الوضع الفاتح مفعّل';

  @override
  String get language => 'اللغة';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageEnglish => 'English';

  @override
  String get settings => 'الإعدادات';

  @override
  String get settingsSubtitle => 'تفضيلات التطبيق';

  @override
  String get helpCenter => 'مركز المساعدة';

  @override
  String get helpCenterSubtitle => 'الأسئلة الشائعة والدعم';

  @override
  String get confirmSignOut => 'تسجيل الخروج';

  @override
  String get confirmSignOutMessage => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get appVersion => 'الإصدار 2.4.1 (بناء 884)';

  @override
  String get settingsComingSoon => 'الإعدادات قريبًا';
}
