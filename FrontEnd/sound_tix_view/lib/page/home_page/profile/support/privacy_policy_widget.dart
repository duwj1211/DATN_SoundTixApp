import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sound_tix_view/components/app_localizations.dart';
import 'package:sound_tix_view/components/close_button.dart';
import 'package:sound_tix_view/model/model.dart';

class PrivacyPolicyWidget extends StatelessWidget {
  const PrivacyPolicyWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
                    const ButtonBack(),
                    const SizedBox(width: 20),
                    Text(AppLocalizations.of(context).translate("Privacy policy"),
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(AppLocalizations.of(context).translate("PERSONAL INFORMATION PRIVACY POLICY"),
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold, color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(AppLocalizations.of(context).translate("1. Consent"),
                            style: TextStyle(fontWeight: FontWeight.bold, color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 35),
                          child: Column(
                            children: [
                              Text(
                                  AppLocalizations.of(context).translate(
                                      "By providing us with your personal information, using Ticketbox E-commerce, you agree that your personal information will be collected and used as stated in the Information Security Policy (“Policy”). If you do not agree with this Policy, you must stop providing us with any personal information and/or exercising the rights as stated in Section 7 below."),
                                  style: TextStyle(color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                              const SizedBox(height: 20),
                              Text(
                                  AppLocalizations.of(context).translate(
                                      "We reserve the right to amend and supplement this Policy at any time to improve it. We encourage members to regularly review this Information Security Policy to obtain the latest updates to ensure that members know and exercise their right to manage their personal information."),
                                  style: TextStyle(color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(AppLocalizations.of(context).translate("2. Purpose of personal information"),
                            style: TextStyle(fontWeight: FontWeight.bold, color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                        const SizedBox(height: 10),
                        Text(AppLocalizations.of(context).translate("We collect personal information only as necessary for the purposes of:"),
                            style: TextStyle(color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 35),
                          child: Column(
                            children: [
                              Text(AppLocalizations.of(context).translate("(i)   Orders: to handle issues related to member orders."),
                                  style: TextStyle(color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                              const SizedBox(height: 20),
                              Text(
                                  AppLocalizations.of(context).translate(
                                      "(ii)   Account Maintenance: to create and maintain a member's account with us, including any loyalty or rewards programs associated with the member's account."),
                                  style: TextStyle(color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                              const SizedBox(height: 20),
                              Text(
                                  AppLocalizations.of(context).translate(
                                      "(iii)   Consumer Services, Customer Care Services: includes responses to member requests, complaints and feedback."),
                                  style: TextStyle(color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                              const SizedBox(height: 20),
                              Text(
                                  AppLocalizations.of(context).translate(
                                      "(iv)   Security: for the purposes of preventing activities that destroy customer user accounts or activities that impersonate customers. As required by law: depending on the provisions of law at each time, we may collect, store and provide as required by competent state agencies."),
                                  style: TextStyle(color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                              const SizedBox(height: 20),
                              Text(
                                  AppLocalizations.of(context).translate(
                                      "(v)   As required by law: subject to the provisions of law at each time, we may collect, store and provide as required by competent state agencies."),
                                  style: TextStyle(color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(AppLocalizations.of(context).translate("3. Address of the unit collecting and managing personal information"),
                            style: TextStyle(fontWeight: FontWeight.bold, color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 35),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppLocalizations.of(context).translate("SoundTix Company Limited"),
                                  style: TextStyle(color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                              const SizedBox(height: 5),
                              Text(
                                  AppLocalizations.of(context)
                                      .translate("Head office: 278 Kim Giang Street, Dai Kim Ward, Hoang Mai District, Hanoi City"),
                                  style: TextStyle(color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                              const SizedBox(height: 5),
                              Text(AppLocalizations.of(context).translate("Hotline: 038 594 3631"),
                                  style: TextStyle(color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                              const SizedBox(height: 5),
                              RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                    text: AppLocalizations.of(context).translate("Email: "),
                                    style: TextStyle(color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                                TextSpan(
                                    text: AppLocalizations.of(context).translate("support@soundtix.vn"),
                                    style: const TextStyle(
                                        color: Color(0xFF2DC275), decoration: TextDecoration.underline, decorationColor: Color(0xFF2DC275))),
                              ])),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
