import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sound_tix_view/api.dart';
import 'package:sound_tix_view/components/app_localizations.dart';
import 'package:sound_tix_view/components/custom_input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isShow = true;

  login() async {
    final body = {
      'userName': _usernameController.text,
      'passWord': _passwordController.text,
    };

    try {
      final response = await httpPost(context, "http://localhost:8080/api/auth/login", body);

      final responseBody = response['body'];
      final statusCode = response['statusCode'];

      if (statusCode == 200 && responseBody is Map<String, dynamic> && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đăng nhập thành công'),
            duration: Duration(seconds: 1),
          ),
        );

        final userId = responseBody['userId'];
        final token = responseBody['token'];
        final role = responseBody['role'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('userId', userId);
        await prefs.setString('jwtToken', token);
        await prefs.setString('role', role);

        if (mounted) {
          switch (role) {
            case "Administrator":
              context.go('/admin-center');
              break;
            case "Organizer":
              context.go('/organizer-center');
              break;
            default:
              context.go('/home-page');
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đăng nhập không thành công'),
              duration: Duration(seconds: 1),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thất bại, vui lòng đăng nhập lại'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF2DC275),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 160),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context).translate("Welcome,"),
                    style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    AppLocalizations.of(context).translate("Sign in to continue!"),
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35)), color: Colors.white),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Column(
                      children: [
                        const SizedBox(height: 50),
                        InputCustom(
                          controller: _usernameController,
                          label: Text(AppLocalizations.of(context).translate("Username")),
                          prefixIcon: const Icon(Icons.person_outlined),
                          obscureText: false,
                          onChanged: (newValue) {
                            setState(() {});
                          },
                        ),
                        const SizedBox(height: 20),
                        Stack(
                          children: [
                            InputCustom(
                              controller: _passwordController,
                              label: Text(AppLocalizations.of(context).translate("Password")),
                              prefixIcon: const Icon(Icons.lock_outlined),
                              obscureText: isShow,
                              maxLines: 1,
                            ),
                            Positioned(
                              top: 15,
                              right: 15,
                              child: InkWell(
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  setState(() {
                                    isShow = !isShow;
                                  });
                                },
                                child: isShow ? const Icon(Icons.remove_red_eye_outlined) : const Icon(Icons.remove_red_eye),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                context.go('/forgot-password',
                                    extra: {"oldUrl": GoRouter.of(context).routerDelegate.currentConfiguration.matches.last.matchedLocation});
                              },
                              child: Text(
                                AppLocalizations.of(context).translate("Forgot your password?"),
                                style: const TextStyle(color: Color(0xFF2DC275), fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 50),
                        Center(
                          child: InkWell(
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {
                              login();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.fromLTRB(0, 11, 0, 11),
                              width: MediaQuery.of(context).size.width / 2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(99),
                                color: const Color(0xFF2DC275),
                              ),
                              child: Text(AppLocalizations.of(context).translate("Login"), style: const TextStyle(fontSize: 16, color: Colors.white)),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 30),
                            Text(AppLocalizations.of(context).translate("Or Continue with"),
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[600])),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "images/facebook_logo.png",
                                  width: 35,
                                  height: 35,
                                ),
                                const SizedBox(width: 15),
                                Image.asset(
                                  "images/twitter_logo.png",
                                  width: 35,
                                  height: 35,
                                ),
                                const SizedBox(width: 15),
                                Image.asset(
                                  "images/apple_logo.png",
                                  width: 35,
                                  height: 35,
                                ),
                              ],
                            ),
                            const SizedBox(height: 50),
                          ],
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(AppLocalizations.of(context).translate("Don't have an account?"), style: const TextStyle(fontSize: 15)),
                              const SizedBox(width: 5),
                              InkWell(
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  context.go('/sign-up',
                                      extra: {"oldUrl": GoRouter.of(context).routerDelegate.currentConfiguration.matches.last.matchedLocation});
                                },
                                child: Text(
                                  AppLocalizations.of(context).translate("SIGN UP"),
                                  style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                    decorationColor: Color(0xFF2DC275),
                                    color: Color(0xFF2DC275),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
