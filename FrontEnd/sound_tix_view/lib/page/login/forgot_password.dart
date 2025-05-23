import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:sound_tix_view/api.dart';
import 'package:sound_tix_view/components/app_localizations.dart';
import 'package:sound_tix_view/components/close_button.dart';
import 'package:sound_tix_view/components/custom_input.dart';
import 'package:sound_tix_view/entity/user.dart';
import 'package:sound_tix_view/page/login/verification.dart';

class ForgotPage extends StatefulWidget {
  const ForgotPage({super.key});

  @override
  State<ForgotPage> createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  final TextEditingController _userController = TextEditingController();
  EmailOTP myauth = EmailOTP();
  List<User> users = [];

  getListEvents() async {
    var rawData = await httpPost(context, "http://localhost:8080/user/search", {"userName": _userController.text});

    setState(() {
      users = [];

      for (var element in rawData["body"]["content"]) {
        var user = User.fromMap(element);
        users.add(user);
      }
    });
    return 0;
  }

  // bool isValidEmail(String email) {
  //   final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  //   return emailRegex.hasMatch(email);
  // }

  // void checkEmail(String value) {
  //   setState(() {
  //     _showEmailError = !isValidEmail(value);
  //   });
  // }

  @override
  void dispose() {
    _userController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          Container(
            color: const Color(0xFF2DC275),
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Row(
              children: [
                const ButtonBack(),
                const SizedBox(width: 20),
                Text(AppLocalizations.of(context).translate("Forgot password"),
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Center(child: Image.asset("images/send_email.png", width: 300, height: 300)),
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context).translate("Forgot password"),
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                Text(AppLocalizations.of(context).translate("Please enter your username to receive verification code."),
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 25),
                InputCustom(
                  controller: _userController,
                  label: const Text("Username"),
                  prefixIcon: const Icon(Icons.person_outlined),
                  obscureText: false,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                // if (_showEmailError)
                //   Column(
                //     children: [
                //       const SizedBox(height: 10),
                //       Text(AppLocalizations.of(context).translate("Invalid email address"), style: const TextStyle(color: Colors.red, fontSize: 12)),
                //     ],
                //   ),
                const SizedBox(height: 35),
                Center(
                  child: InkWell(
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () async {
                      await getListEvents();
                      if (users.isNotEmpty) {
                        EmailOTP.config(appEmail: "tranvandu1211bg@gmail.com", appName: "SoundTix", otpLength: 6, otpType: OTPType.numeric);
                        if (await EmailOTP.sendOTP(email: users[0].email) == true && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(AppLocalizations.of(context).translate("OTP has been sent")),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OtpScreen(myauth: myauth, type: "forgotPassword"),
                            ),
                          );
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(AppLocalizations.of(context).translate("Oops, OTP send failed")),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          }
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
                      child: Text(AppLocalizations.of(context).translate("SUBMIT"), style: const TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
