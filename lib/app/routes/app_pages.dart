import 'package:card/app/modules/card_detail_module/card_detail_binding.dart';
import 'package:card/app/modules/card_detail_module/card_detail_controller.dart';
import 'package:card/app/modules/card_detail_module/card_detail_screen.dart';
import 'package:card/app/modules/category_module/category_bindings.dart';
import 'package:card/app/modules/category_module/category_page.dart';
import 'package:card/app/modules/create_account_module/create_acoount_bindings.dart';
import 'package:card/app/modules/create_account_module/create_acoount_page.dart';
import 'package:card/app/modules/edit_profile_module/edit_profile_binding.dart';
import 'package:card/app/modules/edit_profile_module/edit_profile_screen.dart';
import 'package:card/app/modules/explore_card_rank_module/explore_card_rank_screen.dart';
import 'package:card/app/modules/explore_subCategory_module/explore_subCategory_binding.dart';
import 'package:card/app/modules/explore_subCategory_module/explore_subCategory_screen.dart';
import 'package:card/app/modules/login_module/login_bindings.dart';
import 'package:card/app/modules/login_module/login_page.dart';
import 'package:card/app/modules/notification_module/notifcation_screen.dart';
import 'package:card/app/modules/notification_module/notification_binding.dart';
import 'package:card/app/modules/otp_module/otp_bindings.dart';
import 'package:card/app/modules/otp_module/otp_page.dart';
import 'package:card/app/modules/privacy_policy_module/privacy_policy_binding.dart';
import 'package:card/app/modules/privacy_policy_module/privacy_policy_screen.dart';
import 'package:card/app/modules/repot_module/report_binding.dart';
import 'package:card/app/modules/repot_module/report_screen.dart';
import 'package:card/app/modules/splash_module/splash_bindings.dart';
import 'package:card/app/modules/splash_module/splash_page.dart';
import 'package:card/app/modules/term&condition_module/term&condition_bindings.dart';
import 'package:card/app/modules/term&condition_module/term&condition_page.dart';
import 'package:get/get.dart';

import '../../app/modules/add_card_module/add_card_bindings.dart';
import '../../app/modules/add_card_module/add_card_page.dart';
import '../../app/modules/dashboard_module/dashboard_bindings.dart';
import '../../app/modules/dashboard_module/dashboard_page.dart';
import '../../app/modules/profile_module/profile_bindings.dart';
import '../../app/modules/profile_module/profile_page.dart';
import '../../app/modules/submit_detail_module/submit_detail_bindings.dart';
import '../../app/modules/submit_detail_module/submit_detail_page.dart';
import '../../app/modules/swipe_card_module/swipe_card_bindings.dart';
import '../../app/modules/swipe_card_module/swipe_card_page.dart';
import '../modules/explore_card_rank_module/explore_card_rank_binding.dart';

part './app_routes.dart';

abstract class AppPages {
  static const initialRoute = Routes.SPLASH;
  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.SPLASH,
      page: () => SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.CREATE_ACOOUNT,
      page: () => CreateAccountPage(),
      binding: CreateAccountBinding(),
    ),
    GetPage(
      name: Routes.OTP,
      page: () => OtpPage(),
      binding: OtpBinding(),
    ),
    GetPage(
      name: Routes.TERMCONDITION,
      page: () => TermConditionPage(),
      binding: TermConditionBinding(),
    ),
    GetPage(
      name: Routes.CATEGORY,
      page: () => CategoryPage(),
      binding: CategoryBinding(),
    ),
    GetPage(
      name: Routes.SWIPE_CARD,
      page: () => SwipeCardPage(),
      binding: SwipeCardBinding(),
    ),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => DashboardPage(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => ProfilePage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.ADD_CARD,
      page: () => AddCardPage(),
      binding: AddCardBinding(),
    ),
    GetPage(
      name: Routes.SUBMIT_DETAIL,
      page: () => SubmitDetailPage(),
      binding: SubmitDetailBinding(),
    ),
    GetPage(
      name: Routes.NOTIFICATION,
      page: () => NotificationScreen(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: Routes.EDIT_PROFILE,
      page: () => EditProfileScreen(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: Routes.CARD_DETAIL,
      page: () => CardDetailScreen(),
      binding: CardDetailBinding(),
    ),
    GetPage(
      name: Routes.REPORT,
      page: () => ReportScreen(),
      binding: ReportBinding(),
    ),
    GetPage(
      name: Routes.EXPLORE_SUBCATEGORY,
      page: () => ExploreSubcategoryScreen(),
      binding: ExploreSubCateogryBinding(),
    ),
    GetPage(
      name: Routes.EXPLORE_TOP_CARD,
      page: () => ExploreCardRankScreen(),
      binding: ExploreCardBinding(),
    ),
    GetPage(
      name: Routes.PRIVACY_POLICY,
      page: () => PrivacyPolicyScreen(),
      binding: PrivacyPolicyBinding(),
    ),
  ];
}
