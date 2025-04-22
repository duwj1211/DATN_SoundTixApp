import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sound_tix_view/components/app_localizations.dart';
import 'package:sound_tix_view/components/close_button.dart';
import 'package:sound_tix_view/model/model.dart';

class FaqWidget extends StatefulWidget {
  const FaqWidget({super.key});

  @override
  State<FaqWidget> createState() => _FaqWidgetState();
}

class _FaqWidgetState extends State<FaqWidget> {
  List<Item> data = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    data = <Item>[
      Item(
        headerValue: AppLocalizations.of(context).translate("Questions about purchasing tickets"),
        expandedValue: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context).translate("How can I buy tickets?"),
                      style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[500])),
                  const SizedBox(height: 10),
                  Text(
                      AppLocalizations.of(context).translate(
                          "First, select the event you want to attend on the Ticketbox website, then click on the \"Book Now\" button on the right, select the number of tickets you want to buy, answer a few questions asked by the organizer and fill in your payment information and payment method. Finally, pay for the tickets."),
                      style: TextStyle(color: Colors.grey[500])),
                ],
              ),
            ],
          ),
        ),
      ),
      Item(
        headerValue: AppLocalizations.of(context).translate("Questions about creating events"),
        expandedValue: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context).translate("How can I create my event and sell tickets on SoundTix?"),
                      style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[500])),
                  const SizedBox(height: 10),
                  Text(
                      AppLocalizations.of(context).translate(
                          "The first step is to register your account, then click on the \"Add Event\" button, then please fill in all the necessary information to create an event. You can insert images, insert youtube video links into the event page, choose the ticket sales start date, end date, ticket price, create multiple ticket types, create a questionnaire for crazy customers to enter when buying tickets..."),
                      style: TextStyle(color: Colors.grey[500])),
                ],
              ),
              const SizedBox(height: 35),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context).translate("Once an event is created, who will see the event?"),
                      style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[500])),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: AppLocalizations.of(context).translate(
                                "Once you have created your event, only those with the direct link will be able to view it. Your event will not appear on our event list yet. If you would like your event to appear on the list, please contact us at "),
                            style: TextStyle(color: Colors.grey[500])),
                        TextSpan(
                            text: AppLocalizations.of(context).translate("support@soundtix.vn"), style: const TextStyle(color: Color(0xFF2DC275)))
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      Item(
        headerValue: AppLocalizations.of(context).translate("Account Questions"),
        expandedValue: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context).translate("How can I retrieve my password?"),
                      style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[500])),
                  const SizedBox(height: 10),
                  Text(
                      AppLocalizations.of(context).translate(
                          "If you have lost or forgotten your password, please click here and enter your email address. You will receive an email with a link to retrieve your password."),
                      style: TextStyle(color: Colors.grey[500])),
                ],
              ),
            ],
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChangeThemeModel>(builder: (context, changeThemeModel, child) {
      return Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: const Color(0xFF2DC275),
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Row(
                  children: [
                    const ButtonBack(),
                    const SizedBox(width: 20),
                    Text(AppLocalizations.of(context).translate("Frequently asked questions"),
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("images/faq.png", width: MediaQuery.of(context).size.width, height: 150),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(AppLocalizations.of(context).translate("What is this?"),
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2DC275))),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                            AppLocalizations.of(context).translate(
                                "SoundTix makes buying event tickets as easy and secure as possible. Here are some frequently asked questions from our customers."),
                            style: TextStyle(color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                      ),
                      const SizedBox(height: 10),
                      ExpansionPanelList(
                        expansionCallback: (int index, bool isExpanded) {
                          setState(() {
                            data[index].isExpanded = !data[index].isExpanded;
                          });
                        },
                        children: data.map<ExpansionPanel>((Item item) {
                          return ExpansionPanel(
                            backgroundColor: changeThemeModel.isDark ? Colors.grey[800] : Colors.white,
                            headerBuilder: (BuildContext context, bool isExpanded) {
                              return ListTile(
                                title: Text(item.headerValue,
                                    style: TextStyle(fontWeight: FontWeight.w600, color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                              );
                            },
                            body: item.expandedValue,
                            isExpanded: item.isExpanded,
                            canTapOnHeader: true,
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
      );
    });
  }
}

class Item {
  Item({
    required this.headerValue,
    required this.expandedValue,
    this.isExpanded = false,
  });

  String headerValue;
  Widget expandedValue;
  bool isExpanded;
}
