import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sound_tix_view/api.dart';
import 'package:sound_tix_view/components/app_localizations.dart';
import 'package:sound_tix_view/entity/user.dart';
import 'package:sound_tix_view/page/home_page/profile/account/change_password_widget.dart';
import 'package:sound_tix_view/page/home_page/profile/edit_profile.dart';
import 'package:sound_tix_view/page/login/verification.dart';

import '../../../model/model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;
  int userId = 1;
  bool _isLoadingData = true;
  EmailOTP myauth = EmailOTP();

  @override
  void initState() {
    getDetailUser(userId);
    super.initState();
  }

  getDetailUser(userId) async {
    var response = await httpGet("http://localhost:8080/user/$userId");
    setState(() {
      user = User.fromMap(response["body"]);
      _isLoadingData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    return Consumer<ChangeThemeModel>(builder: (context, changeThemeModel, child) {
      return Center(
        child: _isLoadingData
            ? const CircularProgressIndicator()
            : Container(
                padding: const EdgeInsets.all(10),
                color: changeThemeModel.isDark ? Colors.transparent : Colors.grey[200],
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: changeThemeModel.isDark ? Colors.grey[800] : Colors.white,
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          ClipOval(
                            child: Image.asset(
                              "images/${user!.avatar}",
                              height: 100,
                              width: 100,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user!.fullName,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: changeThemeModel.isDark ? Colors.white : const Color.fromARGB(255, 90, 90, 90)),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditProfileWidget(
                                            userId: user!.userId ?? 1,
                                            onCompleted: () {
                                              getDetailUser(userId);
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                      width: localeProvider.locale.languageCode == "en" ? 70 : 90,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: const Color(0xFF2DC275),
                                        ),
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context).translate("Edit"),
                                        style: const TextStyle(
                                          color: Color(0xFF2DC275),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  InkWell(
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: Image.asset("images/${user!.qrCode}"),
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                      width: localeProvider.locale.languageCode == "en" ? 70 : 90,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: const Color(0xFF2DC275),
                                        ),
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context).translate("Share"),
                                        style: const TextStyle(
                                          color: Color(0xFF2DC275),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: changeThemeModel.isDark ? Colors.grey[800] : Colors.white,
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context).translate("Link"),
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: changeThemeModel.isDark ? Colors.white : Colors.black),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Column(
                              children: [
                                InkWell(
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () {},
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.facebook,
                                        color: Colors.blue,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 20),
                                      Text("Facebook", style: TextStyle(color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                InkWell(
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () {},
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.telegram,
                                        color: Colors.blue,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 20),
                                      Text("Telegram", style: TextStyle(color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: changeThemeModel.isDark ? Colors.grey[800] : Colors.white,
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context).translate("Settings"),
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: changeThemeModel.isDark ? Colors.white : Colors.black),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Column(
                              children: [
                                InkWell(
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    context.go('/profile/change-language');
                                  },
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.language,
                                        color: Color(0xFF2196F3),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 20),
                                      Text(AppLocalizations.of(context).translate("Language"),
                                          style: TextStyle(color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                InkWell(
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    context.go('/profile/change-theme');
                                  },
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.color_lens_outlined,
                                        color: Colors.purpleAccent,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 20),
                                      Text(AppLocalizations.of(context).translate("Theme"),
                                          style: TextStyle(color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: changeThemeModel.isDark ? Colors.grey[800] : Colors.white,
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context).translate("Support"),
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: changeThemeModel.isDark ? Colors.white : Colors.black),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Column(
                              children: [
                                InkWell(
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    context.go('/profile/terms-of-use');
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.file_copy,
                                        color: changeThemeModel.isDark ? Colors.white : const Color(0xFF757575),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 20),
                                      Text(AppLocalizations.of(context).translate("Terms of use"),
                                          style: TextStyle(color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                InkWell(
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    context.go('/profile/faq');
                                  },
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.question_answer,
                                        color: Color(0xFFFF9800),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 20),
                                      Text(AppLocalizations.of(context).translate("FAQ"),
                                          style: TextStyle(color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                InkWell(
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    context.go('/profile/contact');
                                  },
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.phone,
                                        color: Color(0xFF2DC275),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 20),
                                      Text(AppLocalizations.of(context).translate("Contact"),
                                          style: TextStyle(color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                InkWell(
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    context.go('/profile/privacy-policy');
                                  },
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.security,
                                        color: Colors.blue,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 20),
                                      Text(AppLocalizations.of(context).translate("Privacy policy"),
                                          style: TextStyle(color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: changeThemeModel.isDark ? Colors.grey[800] : Colors.white,
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context).translate("Account"),
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: changeThemeModel.isDark ? Colors.white : Colors.black),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Column(
                              children: [
                                InkWell(
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChangePasswordWidget(
                                          userId: user!.userId ?? 1,
                                          onCompleted: () {
                                            getDetailUser(userId);
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.password_outlined,
                                        color: Color(0xFF757575),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 20),
                                      Text(AppLocalizations.of(context).translate("Change password"),
                                          style: TextStyle(color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                InkWell(
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    context.go('/profile/delete-account');
                                  },
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 20),
                                      Text(AppLocalizations.of(context).translate("Delete account"),
                                          style: TextStyle(color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                InkWell(
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    showConfirmDialog(changeThemeModel, "lock");
                                  },
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.lock,
                                        color: changeThemeModel.isDark ? Colors.white : const Color(0xFF757575),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 20),
                                      Text(
                                        AppLocalizations.of(context).translate("Lock account"),
                                        style: TextStyle(color: changeThemeModel.isDark ? Colors.white : Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                InkWell(
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    showConfirmDialog(changeThemeModel, "logout");
                                  },
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.exit_to_app,
                                        color: Color(0xFFF44336),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 20),
                                      Text(
                                        AppLocalizations.of(context).translate("Log out"),
                                        style: TextStyle(color: changeThemeModel.isDark ? Colors.white : Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      AppLocalizations.of(context).translate("Version 1.1.2"),
                      style: TextStyle(color: changeThemeModel.isDark ? Colors.white : Colors.black),
                    ),
                  ],
                ),
              ),
      );
    });
  }

  showConfirmDialog(ChangeThemeModel changeThemeModel, String type) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: changeThemeModel.isDark ? Colors.grey[800] : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: 150,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            Icon(type == "logout" ? Icons.exit_to_app : Icons.lock, size: 20),
                            const SizedBox(width: 5),
                            Text(
                                type == "logout"
                                    ? AppLocalizations.of(context).translate("Log out")
                                    : AppLocalizations.of(context).translate("Lock account"),
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold, color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                          type == "logout"
                              ? AppLocalizations.of(context).translate("Do you want to log out of SoundTix?")
                              : AppLocalizations.of(context).translate("Do you want to lock account?"),
                          style: TextStyle(fontSize: 14, color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 100,
                              padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: const Color(0xFF2DC275)),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(AppLocalizations.of(context).translate("Cancel"),
                                  style: const TextStyle(color: Color(0xFF2DC275), fontSize: 13)),
                            ),
                          ),
                          const SizedBox(width: 20),
                          InkWell(
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () async {
                              if (type == "lock") {
                                EmailOTP.config(appEmail: "tranvandu1211bg@gmail.com", appName: "SoundTix", otpLength: 6, otpType: OTPType.numeric);
                                if (await EmailOTP.sendOTP(email: user!.email) == true) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(AppLocalizations.of(context).translate("OTP has been sent")),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OtpScreen(
                                        myauth: myauth,
                                        type: "lockAccount",
                                        email: user!.email,
                                        userId: user!.userId,
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
                              width: 100,
                              padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2DC275),
                                border: Border.all(color: const Color(0xFF2DC275)),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                  type == "logout"
                                      ? AppLocalizations.of(context).translate("Log out")
                                      : AppLocalizations.of(context).translate("Lock"),
                                  style: const TextStyle(color: Colors.white, fontSize: 13)),
                            ),
                          ),
                        ],
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
