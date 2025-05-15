import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sound_tix_view/api.dart';
import 'package:sound_tix_view/components/app_localizations.dart';
import 'package:sound_tix_view/components/close_button.dart';
import 'package:sound_tix_view/entity/user.dart';
import 'package:sound_tix_view/model/model.dart';
import 'package:sound_tix_view/page/login/verification.dart';

class DeleteAccountWidget extends StatefulWidget {
  final int userId;
  const DeleteAccountWidget({super.key, required this.userId});

  @override
  State<DeleteAccountWidget> createState() => _DeleteAccountWidgetState();
}

class _DeleteAccountWidgetState extends State<DeleteAccountWidget> {
  User? user;
  String _selectedReason = '';
  EmailOTP myauth = EmailOTP();

  @override
  void initState() {
    getDetailUser(widget.userId);
    super.initState();
  }

  getDetailUser(userId) async {
    var response = await httpGet(context, "http://localhost:8080/user/$userId");
    setState(() {
      user = User.fromMap(response["body"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    List listReason = [
      {"name": AppLocalizations.of(context).translate("I do not want to continue using SoundTix"), "value": "do_not_want_to_continue_using"},
      {"name": AppLocalizations.of(context).translate("Bad service"), "value": "bad_service"},
      {"name": AppLocalizations.of(context).translate("Other reason"), "value": "other_reason"},
    ];
    return Consumer<ChangeThemeModel>(builder: (context, changeThemeModel, child) {
      return Scaffold(
        body: Center(
          child: Column(
            children: [
              Container(
                color: const Color(0xFF2DC275),
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Row(
                  children: [
                    const ButtonBack(isPopScreen: true),
                    const SizedBox(width: 20),
                    Text(AppLocalizations.of(context).translate("Delete account"),
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("images/delete_account.png",
                              width: 120, height: 120, color: changeThemeModel.isDark ? Colors.white : Colors.black),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                          AppLocalizations.of(context)
                              .translate("We're sorry you want to delete your SoundTix account. Please let SoundTix know why!"),
                          style: TextStyle(color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                      const SizedBox(height: 20),
                      Text(AppLocalizations.of(context).translate("Select reason"),
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                      const SizedBox(height: 10),
                      Column(
                        children: listReason.map((option) {
                          return Row(
                            children: [
                              Radio<String>(
                                fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                                  if (states.contains(WidgetState.selected)) {
                                    return const Color(0xFF2DC275);
                                  }
                                  return changeThemeModel.isDark ? Colors.white : Colors.black;
                                }),
                                value: option["value"],
                                groupValue: _selectedReason,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedReason = newValue!;
                                  });
                                },
                              ),
                              const SizedBox(width: 10),
                              Text(option["name"], style: TextStyle(color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomSheet: Container(
          padding: const EdgeInsets.fromLTRB(25, 12, 25, 12),
          height: 60,
          color: const Color(0xFF2A2D34),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 6, 20, 6),
            decoration: BoxDecoration(
              color: (_selectedReason != '') ? const Color(0xFF2DC275) : Colors.grey[300],
              borderRadius: BorderRadius.circular(5),
            ),
            child: InkWell(
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () async {
                if (_selectedReason != '') {
                  EmailOTP.config(appEmail: "tranvandu1211bg@gmail.com", appName: "SoundTix", otpLength: 6, otpType: OTPType.numeric);
                  if (await EmailOTP.sendOTP(email: user!.email) == true && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppLocalizations.of(context).translate("OTP has been sent")),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OtpScreen(myauth: myauth, type: "deleteAccount"),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context).translate("Continue"),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
