import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sound_tix_view/api.dart';
import 'package:sound_tix_view/components/app_localizations.dart';
import 'package:sound_tix_view/components/close_button.dart';
import 'package:sound_tix_view/entity/event.dart';

class PayPage extends StatefulWidget {
  final String? id;
  const PayPage({super.key, required this.id});

  @override
  State<PayPage> createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {
  String selectedPayment = "";
  Event? event;
  bool _isLoadingData = true;

  @override
  void initState() {
    int eventId = int.parse(widget.id!);
    getDetailEvent(eventId);
    super.initState();
  }

  getDetailEvent(eventId) async {
    var rawData = await httpGet("http://localhost:8080/event/$eventId");
    setState(() {
      event = Event.fromMap(rawData["body"]);
      _isLoadingData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoadingData
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : Scaffold(
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
                      Text(AppLocalizations.of(context).translate("Pay"),
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      Text(
                        AppLocalizations.of(context).translate("Ticket information"),
                        style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w700, fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(15),
                        margin: const EdgeInsets.only(bottom: 30),
                        decoration:
                            BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event!.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.location_on, size: 18, color: Color(0xFF2DC275)),
                                const SizedBox(width: 10),
                                Text(
                                  event!.location,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF2DC275)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.calendar_month, size: 18, color: Color(0xFF2DC275)),
                                const SizedBox(width: 10),
                                Text(
                                  DateFormat("dd-MM-yyyy").format(event!.dateTime),
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF2DC275)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context).translate("Payment method"),
                            style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w700, fontSize: 18),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            margin: const EdgeInsets.only(bottom: 30),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2A2D34),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                RadioListTile(
                                  title: Row(
                                    children: [
                                      const Icon(
                                        Icons.home,
                                        color: Color(0xFF2DC275),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                          child: Text(AppLocalizations.of(context).translate("Internet Banking"),
                                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white))),
                                    ],
                                  ),
                                  activeColor: Colors.white,
                                  value: "InternetBanking",
                                  groupValue: selectedPayment,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedPayment = value as String;
                                    });
                                  },
                                ),
                                RadioListTile(
                                  title: Row(
                                    children: [
                                      const Icon(Icons.credit_card, color: Color(0xFF2DC275)),
                                      const SizedBox(width: 10),
                                      Expanded(
                                          child: Text(AppLocalizations.of(context).translate("Credit Card"),
                                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white))),
                                    ],
                                  ),
                                  activeColor: Colors.white,
                                  selectedTileColor: Colors.white,
                                  value: "CreditCard",
                                  groupValue: selectedPayment,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedPayment = value as String;
                                    });
                                  },
                                ),
                                RadioListTile(
                                  title: Row(
                                    children: [
                                      const SizedBox(width: 2.5),
                                      Image.asset(
                                        "images/momo.png",
                                        height: 20,
                                        width: 20,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                          child: Text(AppLocalizations.of(context).translate("Payment via MoMo"),
                                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white))),
                                    ],
                                  ),
                                  activeColor: Colors.white,
                                  selectedTileColor: Colors.white,
                                  value: "MoMo",
                                  groupValue: selectedPayment,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedPayment = value as String;
                                    });
                                  },
                                ),
                                RadioListTile(
                                  title: Row(
                                    children: [
                                      const SizedBox(width: 2.5),
                                      Image.asset(
                                        "images/vnpay.png",
                                        height: 20,
                                        width: 20,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                          child: Text(AppLocalizations.of(context).translate("Payment via VNPay"),
                                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white))),
                                    ],
                                  ),
                                  activeColor: Colors.white,
                                  selectedTileColor: Colors.white,
                                  value: "VnPay",
                                  groupValue: selectedPayment,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedPayment = value as String;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            )),
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
                        context.go(
                          '/pay-ment/$selectedPayment',
                          extra: {"oldUrl": GoRouter.of(context).routerDelegate.currentConfiguration.matches.last.matchedLocation},
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2DC275),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.fromLTRB(20, 6, 20, 6),
                        child: Text(
                          AppLocalizations.of(context).translate("Continue"),
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
