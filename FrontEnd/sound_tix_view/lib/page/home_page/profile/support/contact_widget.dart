import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sound_tix_view/components/app_localizations.dart';
import 'package:sound_tix_view/components/close_button.dart';
import 'package:sound_tix_view/model/model.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

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
                    Text(AppLocalizations.of(context).translate("Contact us"),
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                child: Text(
                    AppLocalizations.of(context).translate(
                        "You can get in touch with us through below platforms. Our Team will reach out to you as soon as it would be possible"),
                    style: TextStyle(fontSize: 15, color: changeThemeModel.isDark ? Colors.grey[400] : Colors.grey[700])),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: changeThemeModel.isDark ? Colors.grey[800] : const Color.fromARGB(255, 235, 235, 235),
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppLocalizations.of(context).translate("Customer Support"),
                          style: TextStyle(fontSize: 17, color: changeThemeModel.isDark ? Colors.white : Colors.grey, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Icon(Icons.phone, size: 35, color: Colors.green),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppLocalizations.of(context).translate("Contact Number"),
                                  style: TextStyle(fontSize: 14, color: changeThemeModel.isDark ? Colors.white : Colors.grey)),
                              Text("+84 38 594 3631",
                                  style: TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.w500, color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          const Icon(Icons.email, size: 35, color: Colors.redAccent),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppLocalizations.of(context).translate("Email Address"),
                                  style: TextStyle(fontSize: 14, color: changeThemeModel.isDark ? Colors.white : Colors.grey)),
                              Text("support@soundtix.vn",
                                  style: TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.w500, color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 20),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: changeThemeModel.isDark ? Colors.grey[800] : const Color.fromARGB(255, 235, 235, 235),
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppLocalizations.of(context).translate("Social Media"),
                          style: TextStyle(fontSize: 17, color: changeThemeModel.isDark ? Colors.white : Colors.grey, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Image.asset("images/facebook_logo.png", width: 38, height: 38),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Facebook", style: TextStyle(fontSize: 14, color: changeThemeModel.isDark ? Colors.white : Colors.grey)),
                              Text("SoundTix",
                                  style: TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.w500, color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          const Icon(Icons.telegram, size: 42, color: Colors.blue),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Telegram", style: TextStyle(fontSize: 14, color: changeThemeModel.isDark ? Colors.white : Colors.grey)),
                              Text("@soundtix.telegram",
                                  style: TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.w500, color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Image.asset("images/twitter_logo.png", width: 38, height: 38),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Twitter", style: TextStyle(fontSize: 14, color: changeThemeModel.isDark ? Colors.white : Colors.grey)),
                              Text("@soundtix.twitter",
                                  style: TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.w500, color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                            ],
                          ),
                        ],
                      ),
                    ],
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
