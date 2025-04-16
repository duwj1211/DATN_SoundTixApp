import 'package:flutter/material.dart';
import 'package:sound_tix_admin/api.dart';
import 'package:sound_tix_admin/components/textfield_custom.dart';
import 'package:sound_tix_admin/entity/event.dart';
import 'package:sound_tix_admin/entity/ticket.dart';

class EditTicketWidget extends StatefulWidget {
  final int ticketId;
  const EditTicketWidget({super.key, required this.ticketId});

  @override
  State<EditTicketWidget> createState() => _EditTicketWidgetState();
}

class _EditTicketWidgetState extends State<EditTicketWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _detailInformationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  Ticket? ticket;
  int? priceTicket;
  int? quantityTicket;
  bool _isLoadingEdit = true;
  List<Ticket> tickets = [];
  List<Event> events = [];
  int? selectedEventId;

  @override
  void initState() {
    getInforPage(widget.ticketId);
    super.initState();
  }

  getInforPage(ticketId) async {
    await getDetailTicket(ticketId);
    setInitValue();
  }

  getDetailTicket(ticketId) async {
    var response = await httpGet("http://localhost:8080/ticket/$ticketId");
    setState(() {
      ticket = Ticket.fromMap(response["body"]);
      _isLoadingEdit = false;
    });
  }

  updateTicket() async {
    final ticketData = {
      "name": _nameController.text,
      "detailInformation": _detailInformationController.text,
      "price": priceTicket,
      "quantityAvailable": quantityTicket,
      "event": {"eventId": selectedEventId},
    };

    var response = await httpPatch("http://localhost:8080/ticket/update/${ticket!.ticketId}", ticketData);

    if (response['statusCode'] == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cập nhật thành công!'),
          duration: Duration(seconds: 1),
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cập nhật thất bại!'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  setInitValue() {
    setState(() {
      if (ticket != null) {
        _nameController.text = ticket!.name;
        _detailInformationController.text = ticket!.detailInformation;
        _priceController.text = ticket!.price.toString();
        _quantityController.text = ticket!.quantityAvailable.toString();
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _detailInformationController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoadingEdit
        ? const Center(child: CircularProgressIndicator())
        : AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            scrollable: true,
            titlePadding: const EdgeInsets.all(0),
            contentPadding: const EdgeInsets.all(0),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(30, 20, 30, 10),
                  child: Text("Edit ticket", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Divider(),
                ),
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(child: Text("Ticket name", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                          Expanded(
                            flex: 4,
                            child: InputCustom(controller: _nameController, obscureText: false),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Expanded(child: Text("Detail information", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                          Expanded(flex: 4, child: InputCustom(controller: _detailInformationController, obscureText: false, maxLines: 5)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Expanded(child: Text("Price", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                          Expanded(
                            flex: 4,
                            child: TextField(
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
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Expanded(child: Text("Quantity", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                          Expanded(
                            flex: 4,
                            child: TextField(
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
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Expanded(child: Text("Event", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                          Expanded(
                            flex: 4,
                            child: Wrap(
                              runSpacing: 15,
                              spacing: 15,
                              children: [
                                for (var event in events)
                                  InkWell(
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      setState(() {
                                        selectedEventId = event.eventId;
                                      });
                                    },
                                    child: Tooltip(
                                      message: event.name,
                                      child: Container(
                                        width: 150,
                                        height: 70,
                                        decoration: BoxDecoration(
                                          border: selectedEventId == event.eventId ? Border.all(color: Colors.blue, width: 5) : null,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: Image.asset("images/${event.path}", fit: BoxFit.cover),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 125,
                            child: InkWell(
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Text("Cancel", style: TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.w500)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          SizedBox(
                            width: 125,
                            child: InkWell(
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                updateTicket();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.blue,
                                ),
                                child: const Text("Update", style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
