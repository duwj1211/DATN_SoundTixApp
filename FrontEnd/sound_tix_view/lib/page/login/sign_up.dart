import 'package:diacritic/diacritic.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sound_tix_view/components/app_localizations.dart';
import 'package:sound_tix_view/components/close_button.dart';
import 'package:sound_tix_view/components/custom_input.dart';
import 'package:sound_tix_view/components/image_picker.dart';
import 'package:sound_tix_view/page/login/verification.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  String? avatarFileName;
  EmailOTP myauth = EmailOTP();
  bool _showInvalidError = false;
  bool _showEmptyError = false;
  bool _showEmailFieldError = false;

  @override
  void dispose() {
    _emailController.dispose();
    _userNameController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  bool validPassword(String password) {
    final RegExp passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$');
    return passwordRegex.hasMatch(password);
  }

  void checkValidatePassword(String value) {
    setState(() {
      _showInvalidError = !validPassword(value);
    });
  }

  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  void checkEmail(String value) {
    setState(() {
      _showEmailFieldError = !isValidEmail(value);
    });
  }

  bool validateFields() {
    return _emailController.text.isNotEmpty &&
        _userNameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _fullNameController.text.isNotEmpty &&
        avatarFileName != null;
  }

  String convertFullName(input) {
    return removeDiacritics(input).replaceAll(' ', '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            color: const Color(0xFF2DC275),
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Row(
              children: [
                const ButtonBack(),
                const SizedBox(width: 20),
                Text(AppLocalizations.of(context).translate("Sign Up"),
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context).translate("Create account,"),
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                Text(AppLocalizations.of(context).translate("Sign up to get started!"), style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 35),
                ImportImageWidget(
                    nameAvatar: "avatar.jpg",
                    callbackFileName: (newFileName) {
                      setState(() {
                        avatarFileName = newFileName;
                      });
                    }),
                const SizedBox(height: 30),
                InputCustom(
                  controller: _emailController,
                  label: const Text("Email"),
                  prefixIcon: const Icon(Icons.email_outlined),
                  hintText: "Email",
                  obscureText: false,
                  onChanged: (value) {
                    checkEmail(value);
                  },
                ),
                if (_showEmailFieldError)
                  Column(
                    children: [
                      const SizedBox(height: 10),
                      Text(AppLocalizations.of(context).translate("Invalid email address"), style: const TextStyle(color: Colors.red, fontSize: 12)),
                    ],
                  ),
                const SizedBox(height: 15),
                InputCustom(
                    controller: _userNameController,
                    label: const Text("Username"),
                    prefixIcon: const Icon(Icons.person_outlined),
                    hintText: "Username",
                    obscureText: false),
                const SizedBox(height: 15),
                InputCustom(
                  controller: _passwordController,
                  label: const Text("Password"),
                  prefixIcon: const Icon(Icons.lock_outlined),
                  hintText: "Password",
                  obscureText: true,
                  onChanged: (value) {
                    checkValidatePassword(value);
                  },
                ),
                if (_showInvalidError)
                  Column(
                    children: [
                      const SizedBox(height: 10),
                      Text(AppLocalizations.of(context).translate("Invalid password"), style: const TextStyle(color: Colors.red, fontSize: 12)),
                    ],
                  ),
                const SizedBox(height: 15),
                InputCustom(
                    controller: _fullNameController,
                    label: Text(AppLocalizations.of(context).translate("Full name")),
                    prefixIcon: const Icon(Icons.person_pin_circle_outlined),
                    hintText: AppLocalizations.of(context).translate("Full name"),
                    obscureText: false),
                if (_showEmptyError)
                  Column(
                    children: [
                      const SizedBox(height: 10),
                      Text(AppLocalizations.of(context).translate("Please fill in all information"),
                          style: const TextStyle(color: Colors.red, fontSize: 12)),
                    ],
                  ),
                const SizedBox(height: 35),
                Center(
                  child: InkWell(
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () async {
                      setState(() {
                        _showEmptyError = !validateFields();
                      });
                      if (validateFields() && !_showInvalidError && !_showEmailFieldError) {
                        EmailOTP.config(appEmail: "tranvandu1211bg@gmail.com", appName: "SoundTix", otpLength: 6, otpType: OTPType.numeric);
                        if (await EmailOTP.sendOTP(email: _emailController.text) == true) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(AppLocalizations.of(context).translate("OTP has been sent")),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                          var body = {
                            'userName': _userNameController.text,
                            'email': _emailController.text,
                            'passWord': _passwordController.text,
                            'fullName': _fullNameController.text,
                            'avatar': avatarFileName,
                            'qrCode': "qrCode_${convertFullName(_fullNameController.text)}.png"
                          };
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OtpScreen(
                                myauth: myauth,
                                type: "signUp",
                                registerBody: body,
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(AppLocalizations.of(context).translate("Oops, OTP send failed")),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        }
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.fromLTRB(0, 11, 0, 11),
                      width: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(99),
                        color: const Color(0xFF2DC275),
                      ),
                      child: Text(AppLocalizations.of(context).translate("SIGN UP"), style: const TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                ),
                SizedBox(
                    height: ((_showEmptyError && !_showInvalidError && !_showEmailFieldError) ||
                            (!_showEmptyError && _showInvalidError && !_showEmailFieldError) ||
                            (!_showEmptyError && !_showInvalidError && _showEmailFieldError))
                        ? 60
                        : ((_showEmptyError && _showInvalidError && !_showEmailFieldError) ||
                                (_showEmptyError && !_showInvalidError && _showEmailFieldError) ||
                                (!_showEmptyError && _showInvalidError && _showEmailFieldError))
                            ? 35
                            : (_showEmptyError && _showInvalidError && _showEmailFieldError)
                                ? 10
                                : 90),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppLocalizations.of(context).translate("Already have an account?"), style: const TextStyle(fontSize: 15)),
                    const SizedBox(width: 5),
                    InkWell(
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        context
                            .go('/login', extra: {"oldUrl": GoRouter.of(context).routerDelegate.currentConfiguration.matches.last.matchedLocation});
                      },
                      child: Text(
                        AppLocalizations.of(context).translate("SIGN IN"),
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
              ],
            ),
          ),
        ],
      )),
    );
  }
}
