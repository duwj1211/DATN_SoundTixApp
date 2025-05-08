import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sound_tix_view/components/localization_delegate.dart';
import 'package:sound_tix_view/model/model.dart';
import 'package:sound_tix_view/page/home_page/home/search_page.dart';
import 'package:sound_tix_view/page/home_page/profile/settings/change_language.dart';
import 'package:sound_tix_view/page/home_page/profile/settings/change_theme.dart';
import 'package:sound_tix_view/page/home_page/profile/account/delete_account_success.dart';
import 'package:sound_tix_view/page/home_page/profile/support/faq_widget.dart';
import 'package:sound_tix_view/page/home_page/profile/support/privacy_policy_widget.dart';
import 'package:sound_tix_view/page/home_page/profile/support/terms_of_use_widget.dart';
import 'package:sound_tix_view/page/login/reset_password.dart';
import 'package:sound_tix_view/page/login/verified.dart';
import 'package:sound_tix_view/page/not_found_page.dart';
import 'package:sound_tix_view/page/book_ticket.dart';
import 'package:sound_tix_view/page/detail_event.dart';
import 'package:sound_tix_view/page/home_page/profile/support/contact_widget.dart';
import 'package:sound_tix_view/page/home_page/home_page.dart';
import 'package:sound_tix_view/page/login/forgot_password.dart';
import 'package:sound_tix_view/page/login/login.dart';
import 'package:sound_tix_view/page/login/sign_up.dart';
import 'package:sound_tix_view/page/onboarding.dart';
import 'package:sound_tix_view/page/organizer/organizer-center/organizer_center.dart';
import 'package:sound_tix_view/page/organizer/profile/organizer_profile.dart';
import 'package:sound_tix_view/page/organizer/report-management/report_management.dart';
import 'package:sound_tix_view/page/pay/pay.dart';
import 'package:sound_tix_view/page/pay/payment.dart';
import 'package:sound_tix_view/page/pay/thank_you.dart';
import 'package:sound_tix_view/page/splash_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ChangeThemeModel()),
        ChangeNotifierProvider(create: (context) => LocaleProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChangeThemeModel>(builder: (context, changeThemeModel, child) {
      return MaterialApp.router(
        localizationsDelegates: const [
          AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('vi', ''),
        ],
        locale: Provider.of<LocaleProvider>(context).locale,
        title: "SoundTix",
        theme: changeThemeModel.isDark
            ? ThemeData(scaffoldBackgroundColor: const Color.fromARGB(255, 42, 42, 42), appBarTheme: const AppBarTheme(color: Color(0xFF2DC275)))
            : null,
        debugShowCheckedModeBanner: false,
        routerConfig: _router,
      );
    });
  }

  late final GoRouter _router = GoRouter(
      routes: <GoRoute>[
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/onboarding',
          builder: (BuildContext context, GoRouterState state) => const Onboarding(),
        ),
        GoRoute(
          path: '/login',
          builder: (BuildContext context, GoRouterState state) => const LoginPage(),
        ),
        GoRoute(
          path: '/sign-up',
          builder: (BuildContext context, GoRouterState state) => const SignUpPage(),
        ),
        GoRoute(
          path: '/forgot-password',
          builder: (BuildContext context, GoRouterState state) => const ForgotPage(),
        ),
        GoRoute(
          path: '/verified',
          builder: (BuildContext context, GoRouterState state) => const VerifiedScreen(),
        ),
        GoRoute(
          path: '/reset-password/:email',
          builder: (BuildContext context, GoRouterState state) => ResetPage(email: state.pathParameters['email']),
        ),
        GoRoute(
          path: '/home-page',
          builder: (BuildContext context, GoRouterState state) => const HomePage(index: 0),
        ),
        GoRoute(
          path: '/search-event',
          builder: (BuildContext context, GoRouterState state) => const SearchPageWidget(),
        ),
        GoRoute(
          path: '/my-tickets',
          builder: (BuildContext context, GoRouterState state) => const HomePage(index: 1),
        ),
        GoRoute(
          path: '/profile',
          builder: (BuildContext context, GoRouterState state) => const HomePage(index: 2),
          routes: [
            // GoRoute(
            //   path: 'edit-profile/:userId',
            //   builder: (BuildContext context, GoRouterState state) => EditProfileWidget(userId: state.pathParameters['userId']),
            // ),
            GoRoute(
              path: 'change-language',
              builder: (BuildContext context, GoRouterState state) => const ChangeLanguageWidget(),
            ),
            GoRoute(
              path: 'change-theme',
              builder: (BuildContext context, GoRouterState state) => const ChangeThemeWidget(),
            ),
            GoRoute(
              path: 'terms-of-use',
              builder: (BuildContext context, GoRouterState state) => const TermsOfUseWidget(),
            ),
            GoRoute(
              path: 'faq',
              builder: (BuildContext context, GoRouterState state) => const FaqWidget(),
            ),
            GoRoute(
              path: 'contact',
              builder: (BuildContext context, GoRouterState state) => const ContactUsPage(),
            ),
            GoRoute(
              path: 'privacy-policy',
              builder: (BuildContext context, GoRouterState state) => const PrivacyPolicyWidget(),
            ),
            GoRoute(
              path: 'terms-of-use',
              builder: (BuildContext context, GoRouterState state) => const TermsOfUseWidget(),
            ),
            GoRoute(
              path: 'faq',
              builder: (BuildContext context, GoRouterState state) => const FaqWidget(),
            ),
            GoRoute(
              path: 'contact',
              builder: (BuildContext context, GoRouterState state) => const ContactUsPage(),
            ),
            GoRoute(
              path: 'privacy-policy',
              builder: (BuildContext context, GoRouterState state) => const PrivacyPolicyWidget(),
            ),
          ],
        ),
        GoRoute(
          path: '/delete-account-successful',
          builder: (BuildContext context, GoRouterState state) => const DeleteAccountSuccessfulPage(),
        ),
        GoRoute(
          path: '/thank-you',
          builder: (BuildContext context, GoRouterState state) => const ThankYouPage(),
        ),
        GoRoute(
          path: '/detail-event/:eventId',
          builder: (BuildContext context, GoRouterState state) => DetailPage(id: state.pathParameters['eventId']),
        ),
        GoRoute(
          path: '/pay/:eventId',
          builder: (BuildContext context, GoRouterState state) => PayPage(id: state.pathParameters['eventId']),
        ),
        GoRoute(
          path: '/book/:eventId',
          builder: (BuildContext context, GoRouterState state) => BookPage(id: state.pathParameters['eventId']),
        ),
        GoRoute(
          path: '/pay-ment/:selectedPayment',
          builder: (BuildContext context, GoRouterState state) => PaymentPage(selectedPayment: state.pathParameters['selectedPayment']),
        ),
        GoRoute(
          path: '/organizer-center',
          builder: (BuildContext context, GoRouterState state) => const OrganizerCenterWidget(),
        ),
        GoRoute(
          path: '/report-management',
          builder: (BuildContext context, GoRouterState state) => const ReportManagementWidget(),
        ),
        GoRoute(
          path: '/organizer-profile',
          builder: (BuildContext context, GoRouterState state) => const OrganizerProfilePage(),
        ),
      ],
      errorBuilder: (BuildContext context, GoRouterState state) {
        return const NotFoundPage();
      }
      // redirect: (BuildContext context, GoRouterState state) {
      //   final bool loggedIn = _loginInfo.authenticated;
      //   final bool loggingIn = state.matchedLocation == '/login';
      //   if (!loggedIn) {
      //     return '/login';
      //   }
      //   if (loggingIn) {
      //     return '/';
      //   }
      //   return null;
      // },
      // refreshListenable: _LoginInfo,
      );
}
