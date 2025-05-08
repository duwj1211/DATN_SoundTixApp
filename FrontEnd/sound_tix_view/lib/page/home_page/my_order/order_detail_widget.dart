import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:sound_tix_view/api.dart';
import 'package:sound_tix_view/components/app_localizations.dart';
import 'package:sound_tix_view/entity/booking.dart';
import 'package:sound_tix_view/entity/event.dart';
import 'package:sound_tix_view/entity/payment.dart';
import 'package:sound_tix_view/entity/ticket.dart';
import 'package:sound_tix_view/page/home_page/my_order/ticket_item_widget.dart';

class OrderDetailWidget extends StatefulWidget {
  final Booking booking;
  const OrderDetailWidget({super.key, required this.booking});

  @override
  State<OrderDetailWidget> createState() => _OrderDetailWidgetState();
}

class _OrderDetailWidgetState extends State<OrderDetailWidget> {
  List<Ticket> tickets = [];
  List<Payment> payments = [];
  List<Event> events = [];

  @override
  void initState() {
    super.initState();
    getListTickets();
    getPayment();
  }

  getListTickets() async {
    var rawData = await httpPost("http://localhost:8080/ticket/search", {"bookingId": widget.booking.bookingId});

    setState(() {
      tickets = [];

      for (var element in rawData["body"]["content"]) {
        var ticket = Ticket.fromMap(element);
        tickets.add(ticket);
        getListEvents(ticket.name);
      }
    });
    return 0;
  }

  getListEvents(name) async {
    var rawData = await httpPost("http://localhost:8080/event/search", {"ticket": name});

    setState(() {
      var event = Event.fromMap(rawData["body"]["content"][0]);
      events.add(event);
    });
    return 0;
  }

  getPayment() async {
    var rawData = await httpPost("http://localhost:8080/payment/search", {"bookingId": widget.booking.bookingId});

    setState(() {
      payments = [];

      for (var element in rawData["body"]["content"]) {
        var payment = Payment.fromMap(element);
        payments.add(payment);
      }
    });
    return 0;
  }

  Future<void> generatePDF() async {
    Map<String, PdfColor> mapBookingStatusColor = {
      "Pending": PdfColors.green,
      "Paid": PdfColors.purple,
      "Canceled": PdfColors.blue,
      "Refunded": PdfColors.grey,
    };
    List<pw.Widget> ticketWidgets = [];

    for (var i = 0; i < tickets.length; i++) {
      final ticket = tickets[i];
      final event = events[i];
      ticketWidgets.add(await buildTicketItemForPDF(ticket, event));
    }
    // Tạo một document PDF
    final pdf = pw.Document();

    // Thêm nội dung vào PDF
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey, width: 0.5),
              borderRadius: pw.BorderRadius.circular(5),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          "Order",
                          style: pw.TextStyle(
                            fontSize: 20,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          "#${widget.booking.bookingId}",
                          style: const pw.TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 12,
                      ),
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: mapBookingStatusColor[widget.booking.bookingStatus]!, width: 0.5),
                        borderRadius: pw.BorderRadius.circular(3),
                      ),
                      child: pw.Text(
                        widget.booking.bookingStatus,
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                          color: mapBookingStatusColor[widget.booking.bookingStatus],
                        ),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 6),
                pw.Row(
                  children: [
                    pw.Text(
                      "Create at: ",
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      DateFormat('EEE, MM/dd/yyyy h\'h\':mm a').format(widget.booking.createAt),
                      style: const pw.TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Container(
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey, width: 0.5),
                    borderRadius: pw.BorderRadius.circular(5),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        "Tickets",
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      ...ticketWidgets,
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Container(
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey, width: 0.5),
                    borderRadius: pw.BorderRadius.circular(5),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        "Payment",
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      for (Payment payment in payments)
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text(
                                  "Payment method",
                                  style: pw.TextStyle(
                                    fontSize: 14,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                                pw.Text(
                                  payment.paymentMethod,
                                  style: const pw.TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            pw.SizedBox(height: 5),
                            pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text(
                                  "Payment status",
                                  style: pw.TextStyle(
                                    fontSize: 14,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                                pw.Text(
                                  payment.paymentStatus,
                                  style: const pw.TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            pw.SizedBox(height: 5),
                            pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text(
                                  "Payment time",
                                  style: pw.TextStyle(
                                    fontSize: 14,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                                pw.Text(
                                  DateFormat('EEE, MM/dd/yyyy h\'h\':mm a').format(payment.paymentTime),
                                  style: const pw.TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            pw.SizedBox(height: 10),
                          ],
                        ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text(
                      "Total: ${NumberFormat('#,###', 'vi_VN').format(widget.booking.totalPrice)}.000 VNĐ",
                      style: pw.TextStyle(
                        fontSize: 15,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.red,
                        font: pw.Font.helvetica(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory == null) {
      return;
    }

    final filePath = '$selectedDirectory/Order_${widget.booking.bookingId}.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).translate('Billing successful')),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> exportETicket() async {
    final imageBytes = await loadImageForPDF(tickets[0].qrCode);
    // Tạo một document PDF
    final pdf = pw.Document();

    // Thêm nội dung vào PDF
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  "E-ticket of '${tickets[0].name}'",
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                "Quantity: ${widget.booking.quantity}",
                style: const pw.TextStyle(fontSize: 12),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                "The qrCode is used to check in to the event. Do not reveal it, otherwise we will not be responsible. Thank you!",
                style: const pw.TextStyle(fontSize: 12),
              ),
              pw.SizedBox(height: 30),
              pw.Center(
                child: pw.Container(
                  width: 150,
                  height: 150,
                  child: pw.Image(pw.MemoryImage(imageBytes)),
                ),
              ),
            ],
          );
        },
      ),
    );

    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory == null) {
      return;
    }

    final filePath = '$selectedDirectory/E-Ticket_${tickets[0].name}.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).translate('Export e-ticket successful')),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<pw.Widget> buildTicketItemForPDF(Ticket ticket, Event event) async {
    final imageBytes = await loadImageForPDF(event.path);
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          margin: const pw.EdgeInsets.only(bottom: 10),
          padding: const pw.EdgeInsets.all(5),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey, width: 0.2),
            borderRadius: pw.BorderRadius.circular(5),
          ),
          child: pw.Row(
            children: [
              pw.Container(
                width: 72,
                height: 72,
                child: pw.Image(pw.MemoryImage(imageBytes)),
              ),
              pw.SizedBox(width: 5),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      event.name,
                      style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(
                          color: ticket.name == "Vé Thường"
                              ? PdfColors.green
                              : ticket.name == "Vé VIP"
                                  ? PdfColors.orange
                                  : ticket.name == "Vé VVIP"
                                      ? PdfColors.blue
                                      : PdfColors.purple,
                        ),
                        borderRadius: pw.BorderRadius.circular(3),
                      ),
                      child: pw.Text(
                        ticket.name,
                        style: pw.TextStyle(
                          fontSize: 10,
                          color: ticket.name == "Vé Thường"
                              ? PdfColors.green
                              : ticket.name == "Vé VIP"
                                  ? PdfColors.orange
                                  : ticket.name == "Vé VVIP"
                                      ? PdfColors.blue
                                      : PdfColors.purple,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          "x ${widget.booking.quantity}",
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.normal,
                          ),
                        ),
                        pw.Text(
                          "${ticket.price}.000 VNĐ",
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<Uint8List> loadImageForPDF(String imagePath) async {
    final ByteData data = await rootBundle.load("images/$imagePath");
    return data.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: const Color(0xFF2DC275),
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        color: const Color(0xFF2DC275), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white, width: 0.7)),
                    child: InkWell(
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.arrow_back, size: 20, color: Colors.white)),
                  ),
                  const SizedBox(width: 20),
                  Text(AppLocalizations.of(context).translate("Order detail"),
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context).translate("Order"),
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "#${widget.booking.bookingId}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(12, 2, 12, 2),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              border: Border.all(
                                  color: widget.booking.bookingStatus == "Pending"
                                      ? Colors.green
                                      : widget.booking.bookingStatus == "Paid"
                                          ? Colors.purple
                                          : widget.booking.bookingStatus == "Canceled"
                                              ? Colors.blue
                                              : Colors.grey)),
                          child: Text(widget.booking.bookingStatus,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: widget.booking.bookingStatus == "Pending"
                                      ? Colors.green
                                      : widget.booking.bookingStatus == "Paid"
                                          ? Colors.purple
                                          : widget.booking.bookingStatus == "Canceled"
                                              ? Colors.blue
                                              : Colors.grey)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          AppLocalizations.of(context).translate("Create at: "),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          DateFormat('EEE, MM/dd/yyyy h\'h\':mm a').format(widget.booking.createAt),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context).translate("Tickets"),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          for (Ticket ticket in tickets) TicketItemWidget(ticket: ticket, quantity: widget.booking.quantity),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context).translate("Payment"),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          for (Payment payment in payments)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context).translate("Payment method"),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      payment.paymentMethod,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context).translate("Payment status"),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      payment.paymentStatus,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context).translate("Payment time"),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      DateFormat('EEE, MM/dd/yyyy h\'h\':mm a').format(payment.paymentTime),
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          AppLocalizations.of(context)
                              .translate("Total: totalPrice")
                              .replaceAll("{totalPrice}", NumberFormat('#,###', 'vi_VN').format(widget.booking.totalPrice)),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () async {
                            await exportETicket();
                          },
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFF2DC275),
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              AppLocalizations.of(context).translate("E-Ticket"),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF2DC275),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        InkWell(
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () async {
                            await generatePDF();
                          },
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blue,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              AppLocalizations.of(context).translate("Export bill"),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue,
                              ),
                            ),
                          ),
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
  }
}
