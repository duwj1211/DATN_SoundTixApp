import 'dart:async';
import 'dart:io';

import 'package:excel/excel.dart' hide Border;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sound_tix_admin/api.dart';
import 'package:sound_tix_admin/components/pagination.dart';
import 'package:sound_tix_admin/entity/booking.dart';
import 'package:sound_tix_admin/entity/payment.dart';
import 'package:sound_tix_admin/entity/ticket.dart';
import 'package:sound_tix_admin/entity/user.dart';

class OrderTrackerWidget extends StatefulWidget {
  const OrderTrackerWidget({super.key});

  @override
  State<OrderTrackerWidget> createState() => _OrderTrackerWidgetState();
}

class _OrderTrackerWidgetState extends State<OrderTrackerWidget> {
  late Future futureOrder;
  final TextEditingController searchController = TextEditingController();
  final TextEditingController startTotalPriceController = TextEditingController();
  final TextEditingController endTotalPriceController = TextEditingController();
  List<Booking> bookings = [];
  var findRequestBooking = {};
  bool _isLoadingBooking = true;
  bool _isLoadingCountBooking = true;
  int currentPage = 0;
  int totalPages = 0;
  int totalItems = 0;
  int pendingOrders = 0;
  int successOrders = 0;
  int failedOrders = 0;
  double pendingPercentage = 0.0;
  double successPercentage = 0.0;
  double failedPercentage = 0.0;
  Timer? _debounceTimer;
  dynamic dataExport;
  bool isShowOrderFilter = false;
  bool? sortByCreateAtAsc;
  String _selectedPaymentMethodFilter = '';
  int? startTotalPrice;
  int? endTotalPrice;

  @override
  void initState() {
    super.initState();
    futureOrder = getInitPage();
  }

  getInitPage() async {
    await search();
    await countBookings();
    await getDataExport();
    return 0;
  }

  search() {
    var searchRequest = {
      "user": searchController.text,
      "startTotalPrice": startTotalPrice,
      "endTotalPrice": endTotalPrice,
      "paymentMethod": _selectedPaymentMethodFilter,
      "sortByCreateAtAsc": sortByCreateAtAsc,
    };
    findRequestBooking = searchRequest;
    getListBookings(currentPage, findRequestBooking);
  }

  getListBookings(page, findRequest) async {
    var rawData = await httpPost(context, "http://localhost:8080/booking/search?page=$page&size=10", findRequest);

    setState(() {
      bookings = [];

      for (var element in rawData["body"]["content"]) {
        var booking = Booking.fromMap(element);
        bookings.add(booking);
      }

      totalPages = (rawData["body"]["totalItems"] / 10).ceil();

      _isLoadingBooking = false;
    });
    return 0;
  }

  countBookings() async {
    var rawData = await httpPost(context, "http://localhost:8080/booking/search", {});

    setState(() {
      bookings = [];

      for (var element in rawData["body"]["content"]) {
        var booking = Booking.fromMap(element);
        bookings.add(booking);
      }

      totalItems = rawData["body"]["totalItems"];

      pendingOrders = rawData["body"]["pendingCount"];
      successOrders = rawData["body"]["paidCount"];
      failedOrders = rawData["body"]["canceledCount"] + rawData["body"]["refundedCount"];

      pendingPercentage = (pendingOrders / totalItems) * 100;
      successPercentage = (successOrders / totalItems) * 100;
      failedPercentage = (failedOrders / totalItems) * 100;

      _isLoadingCountBooking = false;
    });
    return 0;
  }

  getDataExport() async {
    var rawData = await httpPost(context, "http://localhost:8080/booking/search", {});

    setState(() {
      dataExport = rawData["body"]["content"];
    });
    return 0;
  }

  Future<void> exportToExcel(String type, dynamic data) async {
    try {
      String? selectedPath = await FilePicker.platform.getDirectoryPath();

      if (selectedPath == null) {
        return;
      }

      var excel = Excel.createExcel();
      var sheet = excel['Sheet1'];

      sheet.appendRow([
        TextCellValue("Date"),
        TextCellValue("Customer"),
        TextCellValue("Items"),
        TextCellValue("Payment"),
        TextCellValue("Total (VNĐ)"),
        TextCellValue("Status"),
      ]);

      if (type == "All") {
        for (var booking in data) {
          String date = booking["createAt"] ?? "Unknown";
          String customer = booking["user"]?["fullName"] ?? "Unknown";
          int items = booking["tickets"]?.length ?? 0;
          String payment = booking["payment"]?["paymentMethod"] ?? "Unknown";
          int total = booking["totalPrice"]?.toInt() * 1000 ?? 0;
          String status = booking["bookingStatus"] ?? "Unknown";

          sheet.appendRow([
            TextCellValue(date),
            TextCellValue(customer),
            IntCellValue(items),
            TextCellValue(payment),
            IntCellValue(total),
            TextCellValue(status),
          ]);
        }
      } else {
        String date = data["createAt"] ?? "Unknown";
        String customer = data["user"]?["fullName"] ?? "Unknown";
        int items = data["tickets"]?.length ?? 0;
        String payment = data["payment"]?["paymentMethod"] ?? "Unknown";
        int total = data["totalPrice"]?.toInt() * 1000 ?? 0;
        String status = data["bookingStatus"] ?? "Unknown";

        sheet.appendRow([
          TextCellValue(date),
          TextCellValue(customer),
          IntCellValue(items),
          TextCellValue(payment),
          IntCellValue(total),
          TextCellValue(status),
        ]);
      }

      String filePath = (type == "All")
          ? "$selectedPath/Bookings_${DateFormat('dd_MM_yyyy').format(DateTime.now())}.xlsx"
          : "$selectedPath/Booking${data["bookingId"]}_${DateFormat('dd_MM_yyyy').format(DateTime.now())}.xlsx";

      File(filePath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(excel.save()!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Xuất file thành công'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lỗi khi xuất file'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List listCreateAtFilter = [
      {"name": "Last create date", "value": false},
      {"name": "First create date", "value": true},
    ];
    List listPaymentMethodFilter = [
      {"name": "E-Banking", "value": "E-Banking"},
      {"name": "E-Wallet", "value": "E-Wallet"},
      {"name": "Credit Card", "value": "Credit Card"},
      {"name": "QR Code", "value": "QR Code"},
    ];
    return FutureBuilder(
      future: futureOrder,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return DefaultTabController(
            length: 5,
            child: Scaffold(
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(35, 25, 28, 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Order Tracker", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      const Text("Effortlessly manage your invoices and stay on top of payments.", style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 50),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(color: const Color.fromARGB(255, 235, 235, 235), borderRadius: BorderRadius.circular(5)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Total orders", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[700])),
                                  const SizedBox(height: 20),
                                  _isLoadingCountBooking
                                      ? const CircularProgressIndicator()
                                      : Text("$totalItems", style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold))
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(color: const Color.fromARGB(255, 235, 235, 235), borderRadius: BorderRadius.circular(5)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Pending Orders", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[700])),
                                  const SizedBox(height: 20),
                                  _isLoadingCountBooking
                                      ? const CircularProgressIndicator()
                                      : Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text("$pendingOrders", style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                                            Container(
                                              padding: const EdgeInsets.fromLTRB(8, 1, 8, 1),
                                              decoration: BoxDecoration(
                                                  color: const Color.fromARGB(255, 249, 187, 94), borderRadius: BorderRadius.circular(3)),
                                              child: Text("${pendingPercentage.toStringAsFixed(2)} %", style: const TextStyle(fontSize: 13)),
                                            ),
                                          ],
                                        )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(color: const Color.fromARGB(255, 235, 235, 235), borderRadius: BorderRadius.circular(5)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Success Orders", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[700])),
                                  const SizedBox(height: 20),
                                  _isLoadingCountBooking
                                      ? const CircularProgressIndicator()
                                      : Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text("$successOrders", style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                                            Container(
                                              padding: const EdgeInsets.fromLTRB(8, 1, 8, 1),
                                              decoration: BoxDecoration(
                                                  color: const Color.fromARGB(255, 157, 241, 162), borderRadius: BorderRadius.circular(3)),
                                              child: Text("${successPercentage.toStringAsFixed(2)} %", style: const TextStyle(fontSize: 13)),
                                            ),
                                          ],
                                        ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(color: const Color.fromARGB(255, 235, 235, 235), borderRadius: BorderRadius.circular(5)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Failed Orders", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[700])),
                                  const SizedBox(height: 20),
                                  _isLoadingCountBooking
                                      ? const CircularProgressIndicator()
                                      : Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text("$failedOrders", style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                                            Container(
                                              padding: const EdgeInsets.fromLTRB(8, 1, 8, 1),
                                              decoration: BoxDecoration(
                                                  color: const Color.fromARGB(255, 251, 146, 139), borderRadius: BorderRadius.circular(3)),
                                              child: Text("${failedPercentage.toStringAsFixed(2)} %", style: const TextStyle(fontSize: 13)),
                                            ),
                                          ],
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (isShowOrderFilter)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            const Text("Filter", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text("Choose from options below and we will filter items for you",
                                style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 0.5), borderRadius: BorderRadius.circular(5)),
                              child: Column(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Create At", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                      const Padding(padding: EdgeInsets.fromLTRB(0, 2, 0, 10), child: Divider(thickness: 1)),
                                      Row(
                                        children: listCreateAtFilter.map((option) {
                                          return Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 4),
                                            decoration: BoxDecoration(
                                                border: Border.all(color: sortByCreateAtAsc == option["value"] ? Colors.blue : Colors.grey, width: 2),
                                                borderRadius: BorderRadius.circular(99)),
                                            margin: const EdgeInsets.only(right: 7),
                                            child: Row(
                                              children: [
                                                Radio<bool>(
                                                  activeColor: Colors.blue,
                                                  value: option["value"],
                                                  groupValue: sortByCreateAtAsc,
                                                  onChanged: (bool? newValue) {
                                                    setState(() {
                                                      sortByCreateAtAsc = newValue!;
                                                    });
                                                  },
                                                ),
                                                Text(option["name"],
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: sortByCreateAtAsc == option["value"] ? Colors.blue : Colors.black,
                                                        fontWeight: FontWeight.w500)),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Payment Method", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                      const Padding(padding: EdgeInsets.fromLTRB(0, 2, 0, 10), child: Divider(thickness: 1)),
                                      Row(
                                        children: listPaymentMethodFilter.map((option) {
                                          return Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 4),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: _selectedPaymentMethodFilter == option["value"] ? Colors.blue : Colors.grey, width: 2),
                                                borderRadius: BorderRadius.circular(99)),
                                            margin: const EdgeInsets.only(right: 7),
                                            child: Row(
                                              children: [
                                                Radio<String>(
                                                  activeColor: Colors.blue,
                                                  value: option["value"],
                                                  groupValue: _selectedPaymentMethodFilter,
                                                  onChanged: (String? newValue) {
                                                    setState(() {
                                                      _selectedPaymentMethodFilter = newValue!;
                                                    });
                                                  },
                                                ),
                                                Text(option["name"],
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: _selectedPaymentMethodFilter == option["value"] ? Colors.blue : Colors.black,
                                                        fontWeight: FontWeight.w500)),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Total Price", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                      const Padding(padding: EdgeInsets.fromLTRB(0, 2, 0, 10), child: Divider(thickness: 1)),
                                      Row(
                                        children: [
                                          const Text("From", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                          const SizedBox(width: 10),
                                          SizedBox(
                                            width: 120,
                                            height: 35,
                                            child: TextField(
                                              controller: startTotalPriceController,
                                              keyboardType: TextInputType.number,
                                              onChanged: (value) {
                                                setState(() {
                                                  startTotalPrice = int.tryParse(value);
                                                });
                                              },
                                              decoration: InputDecoration(
                                                contentPadding: const EdgeInsets.all(5),
                                                hintText: "From...",
                                                hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                                                suffixIcon: startTotalPriceController.text.isNotEmpty
                                                    ? InkWell(
                                                        hoverColor: Colors.transparent,
                                                        highlightColor: Colors.transparent,
                                                        focusColor: Colors.transparent,
                                                        splashColor: Colors.transparent,
                                                        onTap: () {
                                                          setState(() {
                                                            startTotalPriceController.clear();
                                                            startTotalPrice = null;
                                                          });
                                                        },
                                                        child: const Icon(Icons.clear, size: 15),
                                                      )
                                                    : null,
                                                filled: true,
                                                fillColor: Colors.white,
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(color: Colors.grey),
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(color: Colors.grey),
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: const BorderSide(color: Colors.grey),
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          const Text("To", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                          const SizedBox(width: 10),
                                          SizedBox(
                                            width: 120,
                                            height: 35,
                                            child: TextField(
                                              controller: endTotalPriceController,
                                              keyboardType: TextInputType.number,
                                              onChanged: (value) {
                                                setState(() {
                                                  endTotalPrice = int.tryParse(value);
                                                });
                                              },
                                              decoration: InputDecoration(
                                                contentPadding: const EdgeInsets.all(5),
                                                hintText: "To...",
                                                hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                                                suffixIcon: endTotalPriceController.text.isNotEmpty
                                                    ? InkWell(
                                                        hoverColor: Colors.transparent,
                                                        highlightColor: Colors.transparent,
                                                        focusColor: Colors.transparent,
                                                        splashColor: Colors.transparent,
                                                        onTap: () {
                                                          setState(() {
                                                            endTotalPriceController.clear();
                                                            endTotalPrice = null;
                                                          });
                                                        },
                                                        child: const Icon(Icons.clear, size: 15),
                                                      )
                                                    : null,
                                                filled: true,
                                                fillColor: Colors.white,
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(color: Colors.grey),
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(color: Colors.grey),
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: const BorderSide(color: Colors.grey),
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
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
                                          setState(() {
                                            sortByCreateAtAsc = null;
                                            _selectedPaymentMethodFilter = '';
                                            startTotalPriceController.clear();
                                            endTotalPriceController.clear();
                                            startTotalPrice = null;
                                            endTotalPrice = null;
                                            search();
                                          });
                                        },
                                        child: Container(
                                          width: 90,
                                          padding: const EdgeInsets.symmetric(vertical: 6),
                                          decoration: BoxDecoration(border: Border.all(color: Colors.blue), borderRadius: BorderRadius.circular(5)),
                                          child: const Center(
                                              child: Text("Reset", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.blue))),
                                        ),
                                      ),
                                      const SizedBox(width: 30),
                                      InkWell(
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        onTap: () {
                                          setState(() {
                                            search();
                                          });
                                        },
                                        child: Container(
                                          width: 90,
                                          padding: const EdgeInsets.symmetric(vertical: 6),
                                          decoration: BoxDecoration(
                                              color: Colors.blue, border: Border.all(color: Colors.blue), borderRadius: BorderRadius.circular(5)),
                                          child: const Center(
                                              child: Text("Apply", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white))),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 30),
                      const TabBar(
                        dividerColor: Color.fromARGB(255, 215, 215, 215),
                        isScrollable: true,
                        overlayColor: WidgetStateColor.transparent,
                        tabAlignment: TabAlignment.start,
                        labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        tabs: [
                          Padding(padding: EdgeInsets.symmetric(horizontal: 15), child: Tab(text: "All Orders")),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 15), child: Tab(text: "Pending")),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 15), child: Tab(text: "Paid")),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 15), child: Tab(text: "Canceled")),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 15), child: Tab(text: "Refunded")),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: MediaQuery.of(context).size.height - 100,
                        child: TabBarView(
                          children: [
                            _buildOrderList(bookings),
                            _buildOrderList(bookings.where((booking) => booking.bookingStatus == "Pending").toList()),
                            _buildOrderList(bookings.where((booking) => booking.bookingStatus == "Paid").toList()),
                            _buildOrderList(bookings.where((booking) => booking.bookingStatus == "Canceled").toList()),
                            _buildOrderList(bookings.where((booking) => booking.bookingStatus == "Refunded").toList()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }

  Widget _buildOrderList(bookings) {
    if (bookings.isEmpty) {
      return const Center(child: Text("No orders available.", style: TextStyle(fontSize: 16)));
    }
    return _isLoadingBooking
        ? const CircularProgressIndicator()
        : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 220,
                    height: 33,
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        setState(() {
                          searchController.text;
                        });
                        if (_debounceTimer?.isActive ?? false) {
                          _debounceTimer?.cancel();
                        }

                        _debounceTimer = Timer(const Duration(milliseconds: 500), () {
                          search();
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(5),
                        hintText: "Search",
                        hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                        prefixIcon: const Icon(Icons.search, size: 20, color: Colors.grey),
                        suffixIcon: searchController.text != ""
                            ? InkWell(
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  setState(() {
                                    searchController.clear();
                                    search();
                                  });
                                },
                                child: const Icon(Icons.clear, size: 15))
                            : null,
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
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
                    onTap: () {
                      setState(() {
                        if (isShowOrderFilter) {
                          isShowOrderFilter = false;
                          sortByCreateAtAsc = null;
                          _selectedPaymentMethodFilter = '';
                          startTotalPriceController.clear();
                          endTotalPriceController.clear();
                          startTotalPrice = null;
                          endTotalPrice = null;
                        } else {
                          isShowOrderFilter = true;
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        children: [
                          const Icon(Icons.filter_list, size: 18),
                          const SizedBox(width: 8),
                          Text(isShowOrderFilter ? "Hide Filters" : "Filters", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))
                        ],
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
                      await exportToExcel("All", dataExport);
                    },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(5)),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Icon(Icons.system_update_alt_rounded, size: 17),
                          SizedBox(width: 8),
                          Text("Export", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 230, 230, 230),
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8))),
                      child: const Row(
                        children: [
                          Expanded(flex: 4, child: Text("Date", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                          Expanded(flex: 4, child: Text("Customer", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                          Expanded(flex: 2, child: Text("Items", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                          Expanded(flex: 3, child: Text("Payment", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                          Expanded(flex: 3, child: Text("Total (VNĐ)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                          Expanded(flex: 3, child: Text("Status", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                          Expanded(child: Text("Action", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          for (var i = 0; i < bookings.length; i++)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 4,
                                      child: Text(DateFormat('MMMM d, yyyy').format(bookings[i].createAt),
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[700]))),
                                  Expanded(flex: 4, child: CusTomerName(bookingId: bookings[i].bookingId)),
                                  Expanded(flex: 2, child: TicketCount(bookingId: bookings[i].bookingId)),
                                  Expanded(flex: 3, child: PaymentMethod(bookingId: bookings[i].bookingId)),
                                  Expanded(
                                      flex: 3,
                                      child: Text("${NumberFormat("#,###").format(bookings[i].totalPrice)},000",
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[700]))),
                                  Expanded(
                                    flex: 3,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        padding: const EdgeInsets.fromLTRB(15, 3, 15, 3),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(6),
                                            border: Border.all(
                                                color: bookings[i].bookingStatus == "Pending"
                                                    ? Colors.green
                                                    : bookings[i].bookingStatus == "Paid"
                                                        ? Colors.purple
                                                        : bookings[i].bookingStatus == "Canceled"
                                                            ? Colors.blue
                                                            : Colors.grey)),
                                        child: Text(bookings[i].bookingStatus,
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
                                                color: bookings[i].bookingStatus == "Pending"
                                                    ? Colors.green
                                                    : bookings[i].bookingStatus == "Paid"
                                                        ? Colors.purple
                                                        : bookings[i].bookingStatus == "Canceled"
                                                            ? Colors.blue
                                                            : Colors.grey)),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Tooltip(
                                    message: "Export",
                                    child: InkWell(
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      onTap: () async {
                                        await exportToExcel(
                                            "Only", dataExport.firstWhere((element) => element["bookingId"] == bookings[i].bookingId));
                                      },
                                      child: Icon(Icons.system_update_alt_rounded, size: 18, color: Colors.grey[700]),
                                    ),
                                  )),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              PaginationWidget(
                  totalPages: totalPages,
                  onPageChanged: (newCurrentPage) {
                    setState(() {
                      getListBookings(newCurrentPage, findRequestBooking);
                    });
                  }),
            ],
          );
  }
}

class CusTomerName extends StatefulWidget {
  final int? bookingId;
  const CusTomerName({super.key, this.bookingId});

  @override
  State<CusTomerName> createState() => _CusTomerNameState();
}

class _CusTomerNameState extends State<CusTomerName> {
  List<User> users = [];
  bool _isLoadingUser = true;

  @override
  void initState() {
    searchUserAndDisplay(widget.bookingId);
    super.initState();
  }

  void searchUserAndDisplay(bookingId) async {
    var rawData = await httpPost(context, "http://localhost:8080/user/search", {"bookingId": bookingId});

    setState(() {
      users = [];

      for (var element in rawData["body"]["content"]) {
        var user = User.fromMap(element);
        users.add(user);
      }

      _isLoadingUser = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoadingUser
        ? const CircularProgressIndicator()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var user in users) Text(user.fullName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[700])),
            ],
          );
  }
}

class PaymentMethod extends StatefulWidget {
  final int? bookingId;
  const PaymentMethod({super.key, this.bookingId});

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  List<Payment> payments = [];
  bool _isLoadingPayment = true;

  @override
  void initState() {
    searchPaymentAndDisplay(widget.bookingId);
    super.initState();
  }

  void searchPaymentAndDisplay(bookingId) async {
    var rawData = await httpPost(context, "http://localhost:8080/payment/search", {"bookingId": bookingId});

    setState(() {
      payments = [];

      for (var element in rawData["body"]["content"]) {
        var payment = Payment.fromMap(element);
        payments.add(payment);
      }

      _isLoadingPayment = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoadingPayment
        ? const CircularProgressIndicator()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var payment in payments)
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 3, 15, 3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                          color: payment.paymentMethod == "E-Banking"
                              ? Colors.green
                              : payment.paymentMethod == "Credit Card"
                                  ? Colors.purple
                                  : payment.paymentMethod == "E-Wallet"
                                      ? Colors.blue
                                      : Colors.grey)),
                  child: Text(payment.paymentMethod,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: payment.paymentMethod == "E-Banking"
                              ? Colors.green
                              : payment.paymentMethod == "Credit Card"
                                  ? Colors.purple
                                  : payment.paymentMethod == "E-Wallet"
                                      ? Colors.blue
                                      : Colors.grey)),
                ),
            ],
          );
  }
}

class TicketCount extends StatefulWidget {
  final int? bookingId;
  const TicketCount({super.key, this.bookingId});

  @override
  State<TicketCount> createState() => _TicketCountState();
}

class _TicketCountState extends State<TicketCount> {
  List<Ticket> tickets = [];
  bool _isLoadingTicket = true;

  @override
  void initState() {
    searchTicketAndDisplay(widget.bookingId);
    super.initState();
  }

  void searchTicketAndDisplay(bookingId) async {
    var rawData = await httpPost(context, "http://localhost:8080/ticket/search", {"bookingId": bookingId});

    setState(() {
      tickets = [];

      for (var element in rawData["body"]["content"]) {
        var ticket = Ticket.fromMap(element);
        tickets.add(ticket);
      }

      _isLoadingTicket = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoadingTicket
        ? const CircularProgressIndicator()
        : Text("${tickets.length}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[700]));
  }
}
