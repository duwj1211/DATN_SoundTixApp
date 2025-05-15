import 'package:flutter/material.dart';
import 'package:sound_tix_view/api.dart';
import 'package:sound_tix_view/components/app_localizations.dart';
import 'package:sound_tix_view/components/custom_input.dart';

class OrganizerAddTicketWidget extends StatefulWidget {
  final int eventId;
  final Function onSubmit;
  const OrganizerAddTicketWidget({super.key, required this.eventId, required this.onSubmit});

  @override
  State<OrganizerAddTicketWidget> createState() => _OrganizerAddTicketWidgetState();
}

class _OrganizerAddTicketWidgetState extends State<OrganizerAddTicketWidget> {
  final TextEditingController _ticketNameController = TextEditingController();
  final TextEditingController _detailInformationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  int? priceTicket;
  int? quantityTicket;

  addTicket() async {
    final body = {
      "name": _ticketNameController.text,
      "detailInformation": _detailInformationController.text,
      "price": priceTicket,
      "quantityAvailable": quantityTicket,
      "sold": 0,
      "event": {"eventId": widget.eventId},
      "qrCode": "qrCode_QrCode.png",
    };

    try {
      await httpPost(context, "http://localhost:8080/ticket/add", body);
      if ( mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thêm vé thành công'),
            duration: Duration(seconds: 1),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã xảy ra lỗi, vui lòng thử lại'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    }
  }

  bool validateTicketFields() {
    return _ticketNameController.text.isNotEmpty &&
        _detailInformationController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        _quantityController.text.isNotEmpty;
  }

  @override
  void dispose() {
    _ticketNameController.dispose();
    _detailInformationController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Add ticket", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(AppLocalizations.of(context).translate("Ticket name"), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ),
              InputCustom(controller: _ticketNameController, obscureText: false),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(AppLocalizations.of(context).translate("Detail information"),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ),
              InputCustom(controller: _detailInformationController, obscureText: false, maxLines: 3),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(AppLocalizations.of(context).translate("Price"), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ),
              TextField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    priceTicket = int.tryParse(value);
                  });
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 235, 235, 235),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(AppLocalizations.of(context).translate("Quantity"), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ),
              TextField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    quantityTicket = int.tryParse(value);
                  });
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 235, 235, 235),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 80,
                child: InkWell(
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: validateTicketFields()
                      ? () async {
                          await addTicket();
                          widget.onSubmit();
                        }
                      : null,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: validateTicketFields() ? const Color(0xFF2DC275) : Colors.grey.shade400,
                      ),
                      borderRadius: BorderRadius.circular(5),
                      color: validateTicketFields() ? const Color(0xFF2DC275) : Colors.grey.shade400,
                    ),
                    child: const Text("Submit", style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
