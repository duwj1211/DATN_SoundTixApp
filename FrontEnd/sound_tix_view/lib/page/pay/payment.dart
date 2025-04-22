import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sound_tix_view/components/app_localizations.dart';
import 'package:sound_tix_view/components/close_button.dart';
import 'package:sound_tix_view/components/custom_input.dart';
import 'package:sound_tix_view/components/image_picker.dart';

class PaymentPage extends StatefulWidget {
  final String? selectedPayment;
  const PaymentPage({super.key, required this.selectedPayment});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? payFileName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            (widget.selectedPayment == "InternetBanking")
                ? Column(
                    children: [
                      Container(
                        color: const Color(0xFF2DC275),
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: Row(
                          children: [
                            const ButtonBack(),
                            const SizedBox(width: 20),
                            Text(AppLocalizations.of(context).translate("Internet Banking"),
                                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Container(
                              margin: const EdgeInsets.only(bottom: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context).translate("Transfer information"),
                                    style: const TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          "images/vcb-1.png",
                                          height: 30,
                                          width: MediaQuery.of(context).size.width,
                                        ),
                                        DefaultTextStyle(
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black,
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(AppLocalizations.of(context).translate("Bank: Vietcombank")),
                                              const SizedBox(height: 15),
                                              Text(AppLocalizations.of(context).translate("Account number: 1018898613")),
                                              const SizedBox(height: 15),
                                              Text(AppLocalizations.of(context).translate("Account owner: Công ty TNHH SoundTix")),
                                              const SizedBox(height: 15),
                                              Text(AppLocalizations.of(context).translate("Branch: Bac Tu Liem")),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context).translate(
                                      "   Customers please transfer money according to the information above with the content: \"Customer pays for ticket\"."),
                                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  AppLocalizations.of(context).translate("   Please take a screenshot and upload it here."),
                                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                                ),
                                const SizedBox(height: 30),
                                ImportImageWidget(
                                    nameAvatar: "avatar.jpg",
                                    callbackFileName: (newFileName) {
                                      setState(() {
                                        payFileName = newFileName;
                                      });
                                    }),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : (widget.selectedPayment == "CreditCard")
                    ? Column(
                        children: [
                          Container(
                            color: const Color(0xFF2DC275),
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            child: Row(
                              children: [
                                const ButtonBack(),
                                const SizedBox(width: 20),
                                Text(AppLocalizations.of(context).translate("Credit Card"),
                                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            margin: const EdgeInsets.only(top: 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Align(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.credit_card,
                                    size: 50,
                                    color: Color(0xFF2DC275),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  AppLocalizations.of(context).translate("Please fill in the information below"),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                InputCustom(
                                    label: Text(AppLocalizations.of(context).translate("Cardholder name")),
                                    hintText: AppLocalizations.of(context).translate("Cardholder name"),
                                    obscureText: false),
                                const SizedBox(height: 10),
                                InputCustom(
                                    label: Text(AppLocalizations.of(context).translate("Card number")),
                                    hintText: AppLocalizations.of(context).translate("Card number"),
                                    obscureText: false),
                                const SizedBox(height: 30),
                                Align(
                                  alignment: Alignment.center,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(AppLocalizations.of(context).translate("Confirm")),
                                            content: Text(AppLocalizations.of(context).translate("Confirm payment by credit card above.")),
                                            actions: [
                                              TextButton(
                                                child: Text(AppLocalizations.of(context).translate('CANCEL')),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              TextButton(
                                                child: Text(AppLocalizations.of(context).translate('OK')),
                                                onPressed: () {
                                                  context.go('/thank-you');
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Text(AppLocalizations.of(context).translate("OK")),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : (widget.selectedPayment == "MoMo")
                        ? Column(
                            children: [
                              Container(
                                color: const Color(0xFF2DC275),
                                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                child: const Row(
                                  children: [
                                    ButtonBack(),
                                    SizedBox(width: 20),
                                    Text("MoMo", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                child: const Column(
                                  children: [],
                                ),
                              ),
                            ],
                          )
                        : Container(
                            color: const Color(0xFF2DC275),
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            child: const Row(
                              children: [
                                ButtonBack(),
                                SizedBox(width: 20),
                                Text("VNPay", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
            const SizedBox(height: 60),
          ],
        ),
      ),
      bottomSheet: Container(
        color: const Color(0xFF2A2D34),
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: InkWell(
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                focusColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  context.go('/thank-you');
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2DC275),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.fromLTRB(15, 6, 15, 6),
                  child: Text(
                    AppLocalizations.of(context).translate("Pay"),
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
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
