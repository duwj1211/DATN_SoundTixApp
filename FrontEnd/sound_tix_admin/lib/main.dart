import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sound_tix_admin/model/model.dart';
import 'package:sound_tix_admin/page/home_page/home_page.dart';
import 'package:sound_tix_admin/page/login/login.dart';
import 'package:sound_tix_admin/page/not_found/not_found_page.dart';
import 'package:sound_tix_admin/page/options/profile.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => DisplayDrawerModel()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SoundTix Admin',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }

  late final GoRouter _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) => const LoginPage(),
      ),
      GoRoute(
        path: '/home-page',
        builder: (BuildContext context, GoRouterState state) => const HomePage(),
      ),
      GoRoute(
        path: '/profile',
        builder: (BuildContext context, GoRouterState state) => const ProfileWidget(),
      ),
    ],
    errorBuilder: (BuildContext context, GoRouterState state) {
      return const NotFoundPage();
    },
  );
}
