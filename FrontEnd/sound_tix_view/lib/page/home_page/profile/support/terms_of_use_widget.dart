import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sound_tix_view/components/app_localizations.dart';
import 'package:sound_tix_view/components/close_button.dart';
import 'package:sound_tix_view/model/model.dart';

class TermsOfUseWidget extends StatelessWidget {
  const TermsOfUseWidget({super.key});

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
                    Text(AppLocalizations.of(context).translate("Terms of use"),
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
                            Text(AppLocalizations.of(context).translate("Terms of use").toUpperCase(),
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold, color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(AppLocalizations.of(context).translate("1. General Provisions"),
                            style: TextStyle(fontWeight: FontWeight.bold, color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 35),
                          child: Column(
                            children: [
                              Text(
                                  AppLocalizations.of(context).translate(
                                      "Welcome to the Ticketbox e-commerce trading floor (including website and mobile application) including: (i) Ticketbox.vn e-commerce website registered and operating as an e-commerce website and (ii) mobile application on Android and iOS operating systems called Ticketbox registered as an e-commerce application so that other traders, organizations and individuals can conduct the entire process of buying and selling goods and services on it in the form of operation: Website/application allows participants to open booths to display and introduce goods or services and Customers to make purchases on it. These Terms of Use include the terms (“Terms of Use”) that are legally binding between the Customer (“Customer” or “you”) and Ticketbox Company Limited, a company that owns, operates and provides a variety of services depending on the level of your request."),
                                  style: TextStyle(color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                              const SizedBox(height: 20),
                              Text(
                                  AppLocalizations.of(context).translate(
                                      "If you do not agree to the terms, conditions, regulations, policies or procedures set forth below, please do not use our services. The Terms of Use may be amended as set forth in Section 2 below."),
                                  style: TextStyle(color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(AppLocalizations.of(context).translate("2. Amendments and Supplements to Terms of Use"),
                            style: TextStyle(fontWeight: FontWeight.bold, color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 35),
                          child: Text(
                              AppLocalizations.of(context).translate(
                                  "Ticketbox reserves the right to edit, modify and supplement any content of the Terms of Use at any time if deemed necessary. Edits, modifications and supplements will be effective immediately upon posting on the Ticketbox E-commerce Platform. The Customer agrees to regularly update the Terms of Use and any modifications to these Terms of Use will constitute the Customer's agreement and acceptance of these modifications whether or not they have been updated by the Customer. When you access the Ticketbox E-commerce Platform or use the information and functions of Ticketbox, it means that you have read, understood and agreed to these Terms of Use as well as any terms that are modified later."),
                              style: TextStyle(color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                        ),
                        const SizedBox(height: 20),
                        Text(
                            AppLocalizations.of(context)
                                .translate("3. Deletion of account/personal data on Ticketbox E-commerce Platform by Customer"),
                            style: TextStyle(fontWeight: FontWeight.bold, color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 35),
                          child: RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: AppLocalizations.of(context).translate(
                                    "Customers have the right to decide to stop accessing or stop using the service on the Ticketbox e-commerce platform. In case the Customer wants to delete his/her account and personal data on the Ticketbox e-commerce platform, the Customer should send a request or ask the Ticketbox e-commerce platform administrator for support by calling the hotline: 1900.6408 or sending the information needing support via the administrator's email: "),
                                style: TextStyle(color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                            TextSpan(
                                text: AppLocalizations.of(context).translate("support@soundtix.vn"),
                                style: const TextStyle(
                                    color: Color(0xFF2DC275), decoration: TextDecoration.underline, decorationColor: Color(0xFF2DC275))),
                          ])),
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
