import 'package:get/get.dart';
import 'package:ohm_pad/ui/account/account_binding.dart';
import 'package:ohm_pad/ui/account/account_screen.dart';
import 'package:ohm_pad/ui/account/change_password/change_password_binding.dart';
import 'package:ohm_pad/ui/account/change_password/change_password_screen.dart';
import 'package:ohm_pad/ui/account/edit_profile/edit_profile_binding.dart';
import 'package:ohm_pad/ui/account/edit_profile/edit_profile_screen.dart';
import 'package:ohm_pad/ui/auth/forgotpassword/forgot_password.dart';
import 'package:ohm_pad/ui/auth/forgotpassword/forgot_password_binding.dart';
import 'package:ohm_pad/ui/auth/forgotpassword/forgot_password_controller.dart';
import 'package:ohm_pad/ui/auth/login/login_binding.dart';
import 'package:ohm_pad/ui/auth/login/login_screen.dart';
import 'package:ohm_pad/ui/auth/register/register_binding.dart';
import 'package:ohm_pad/ui/auth/register/register_screen.dart';
import 'package:ohm_pad/ui/close/closing_binding.dart';
import 'package:ohm_pad/ui/close/closing_screen.dart';
import 'package:ohm_pad/ui/connection/scan_binding.dart';
import 'package:ohm_pad/ui/connection/scan_devices.dart';
import 'package:ohm_pad/ui/home/home_binding.dart';
import 'package:ohm_pad/ui/home/home_screen.dart';
import 'package:ohm_pad/ui/how_to_use/how_to_use_binding.dart';
import 'package:ohm_pad/ui/how_to_use/how_to_use_screen.dart';
import 'package:ohm_pad/ui/mood/mood_binding.dart';
import 'package:ohm_pad/ui/mood/mood_selection_screen.dart';
import 'package:ohm_pad/ui/mood/sub_mood_screen.dart';
import 'package:ohm_pad/ui/mood/submood_binding.dart';
import 'package:ohm_pad/ui/onboarding/onboarding_binding.dart';
import 'package:ohm_pad/ui/onboarding/onboarding_screen.dart';
import 'package:ohm_pad/ui/others/cms_bindings.dart';
import 'package:ohm_pad/ui/others/cms_page.dart';
import 'package:ohm_pad/ui/player/player_binding.dart';
import 'package:ohm_pad/ui/player/player_screen.dart';
import 'package:ohm_pad/ui/profile/profile_binding.dart';
import 'package:ohm_pad/ui/profile/profile_screen.dart';
import 'package:ohm_pad/ui/splash/splash_binding.dart';
import 'package:ohm_pad/ui/splash/splash_screen.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.SPLASH_SCREEN;

  static final routes = [
    GetPage(
      name: Routes.SPLASH_SCREEN,
      page: () => SplashScreen(),
      binding: SplashBinding()
    ),
  // info@OhmPad.com
    GetPage(
        name: Routes.ON_BOARDING,
        page: () => OnBoardingScreen(),
        binding: OnBoardingBinding()
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginScreen(),
      binding: LoginBinding()
    ),
    GetPage(
        name: Routes.CMS_SCREEN,
        page: () => CMSPage(),
        binding: CMSBindings()
    ),

    GetPage(
      name: Routes.SIGNUP,
      page: () => RegisterScreen(),
      binding: RegisterBinding()
    ),
    GetPage(
        name: Routes.FORGOT_PASSWORD,
        page: () => ForgotPasswordScreen(),
        binding: ForgotPasswordBinding()
    ),
    GetPage(
        name: Routes.MAIN_PAGE,
        page: () => HomeScreen(),
        binding: HomeBinding()
    ),
    GetPage(
        name: Routes.HOW_TO_USE,
        page: () => HowToUseScreen(),
        binding: HowToUseBinding()
    ),
    GetPage(
        name: Routes.ACCOUNT_SCREEN,
        page: () => AccountScreen(),
        binding: AcccountBinding()
    ),
    GetPage(
        name: Routes.CHANGE_PASSWORD_SCREEN,
        page: () => ChangePasswordScreen(),
        binding: ChangePasswordBinding()
    ),
    GetPage(
        name: Routes.SCAN_DEVICES,
        page: () => ScanDevicesPage(),
        binding: ScanBinding()
    ),
    GetPage(
        name: Routes.PLAYER_SCREEN,
        page: () => PlayerScreen(),
        binding: PlayerBinding()
    ),
    GetPage(
        name: Routes.MOOD_SELECTION_SCREEN,
        page: () => MoodSelectionScreen(),
        binding: MoodBinding()
    ),
    GetPage(
        name: Routes.SUB_MOOD_SELECTION_SCREEN,
        page: () => SubMoodScreen(),
        binding: SubMoodBinding()
    ),
    GetPage(
        name: Routes.CLOSING_SCREEN,
        page: () => ClosingScreen(),
        binding: ClosingBinding()
    ),
    GetPage(
        name: Routes.PROFILE_SCREEN,
        page: () => ProfileScreen(),
        binding: ProfileBinding()
    ),
    GetPage(
        name: Routes.EDIT_PROFILE,
        page: () => EditProfileScreen(),
        binding: EditProfileBinding()
    ),
  ];
}
