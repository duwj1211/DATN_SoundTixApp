import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sound_tix_admin/components/textfield_custom.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isShow = true;

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
          color: Colors.blue,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 160),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome,",
                    style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Sign in to continue!",
                    style: TextStyle(color: Colors.white, fontSize: 20),
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
                            label: const Text("Username"),
                            prefixIcon: const Icon(Icons.person_outlined),
                            hintText: "Enter your username",
                            obscureText: false),
                        const SizedBox(height: 20),
                        Stack(
                          children: [
                            InputCustom(
                                controller: _passwordController,
                                label: const Text("Password"),
                                prefixIcon: const Icon(Icons.lock_outlined),
                                hintText: "Enter your password",
                                obscureText: isShow),
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
                        const SizedBox(height: 50),
                        Center(
                          child: InkWell(
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {
                              context.go('/home-page');
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                              width: MediaQuery.of(context).size.width / 10,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(99),
                                color: Colors.blue,
                              ),
                              child: const Text("Login", style: TextStyle(fontSize: 16, color: Colors.white)),
                            ),
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
