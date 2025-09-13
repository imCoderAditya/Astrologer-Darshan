import 'package:get/get.dart';

import '../modules/auth/login/bindings/login_binding.dart';
import '../modules/auth/login/views/login_view.dart';
import '../modules/auth/otpVerify/bindings/otp_verify_binding.dart';
import '../modules/auth/otpVerify/views/otp_verify_view.dart';
import '../modules/auth/sign/bindings/sign_binding.dart';
import '../modules/auth/sign/views/sign_view.dart';
import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chat_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/hostAstro/bindings/host_astro_binding.dart';
import '../modules/hostAstro/views/host_astro_view.dart';
import '../modules/nav/bindings/nav_binding.dart';
import '../modules/nav/views/nav_view.dart';
import '../modules/notification/bindings/notification_binding.dart';
import '../modules/notification/views/notification_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/userRequest/bindings/user_request_binding.dart';
import '../modules/userRequest/views/user_request_view.dart';
import '../modules/voiceCall/bindings/voice_call_binding.dart';
import '../modules/voiceCall/views/voice_call_view.dart';
import '../modules/wallet/bindings/wallet_binding.dart';
import '../modules/wallet/views/wallet_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(name: _Paths.NAV, page: () => NavView(), binding: NavBinding()),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.WALLET,
      page: () => const WalletView(),
      binding: WalletBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.CHAT,
      page: () => const ChatView(),
      binding: ChatBinding(),
    ),
    GetPage(name: _Paths.NAV, page: () => NavView(), binding: NavBinding()),
    GetPage(
      name: _Paths.VOICE_CALL,
      page: () => VoiceCallView(),
      binding: VoiceCallBinding(),
    ),
    GetPage(
      name: _Paths.HOST_ASTRO,
      page: () => HostView(),
      binding: HostAstroBinding(),
    ),
    GetPage(
      name: _Paths.USER_REQUEST,
      page: () => const UserRequestView(),
      binding: UserRequestBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SIGN,
      page: () => const SignView(),
      binding: SignBinding(),
    ),
    GetPage(
      name: _Paths.OTP_VERIFY,
      page: () => const OtpVerifyView(),
      binding: OtpVerifyBinding(),
    ),
  ];
}
