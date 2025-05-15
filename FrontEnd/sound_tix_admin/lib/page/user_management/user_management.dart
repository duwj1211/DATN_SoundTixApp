import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sound_tix_admin/api.dart';
import 'package:sound_tix_admin/components/pagination.dart';
import 'package:sound_tix_admin/entity/user.dart';
import 'package:intl/intl.dart';
import 'package:sound_tix_admin/page/user_management/create_user.dart';
import 'package:sound_tix_admin/page/user_management/edit_user.dart';

class UserManagementWidget extends StatefulWidget {
  const UserManagementWidget({super.key});

  @override
  State<UserManagementWidget> createState() => _UserManagementWidgetState();
}

class _UserManagementWidgetState extends State<UserManagementWidget> {
  late Future futureUser;
  final TextEditingController searchController = TextEditingController();
  int currentPage = 0;
  int totalPages = 0;
  int totalItems = 0;
  List<User> users = [];
  var findRequestUser = {};
  int administratorCount = 0;
  int organizerCount = 0;
  int customerCount = 0;
  double administratorPercentage = 0.0;
  double organizerPercentage = 0.0;
  double customerPercentage = 0.0;
  Timer? _debounceTimer;
  bool isShowUserFilter = false;
  bool? sortByDateAddedAsc;
  String _selectedRoleFilter = '';
  String _selectedStatusFilter = '';

  @override
  void initState() {
    super.initState();
    futureUser = getInitPage();
  }

  getInitPage() async {
    await search();
    await countUsers();
    return 0;
  }

  search() {
    var searchRequest = {
      "fullName": searchController.text,
      "role": _selectedRoleFilter,
      "status": _selectedStatusFilter,
      "sortByDateAddedAsc": sortByDateAddedAsc,
    };
    findRequestUser = searchRequest;
    getListUsers(currentPage, findRequestUser);
  }

  getListUsers(int page, findRequest) async {
    var rawData = await httpPost(context, "http://localhost:8080/user/search?page=$page&size=10", findRequest);
    setState(() {
      users = [];
      for (var element in rawData["body"]["content"]) {
        var user = User.fromMap(element);
        users.add(user);
      }
      totalPages = (rawData["body"]["totalItems"] / 10).ceil();
    });
    return 0;
  }

  countUsers() async {
    var rawData = await httpPost(context, "http://localhost:8080/user/search", {});
    setState(() {
      totalItems = rawData["body"]["totalItems"];

      administratorCount = rawData["body"]["administratorCount"];
      organizerCount = rawData["body"]["organizerCount"];
      customerCount = rawData["body"]["customerCount"];

      administratorPercentage = (administratorCount / totalItems) * 100;
      organizerPercentage = (organizerCount / totalItems) * 100;
      customerPercentage = (customerCount / totalItems) * 100;
    });
    return 0;
  }

  deleteUser(userId) async {
    try {
     await httpDelete(context, "http://localhost:8080/user/delete/$userId");
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Xóa người dùng thành công'),
          duration: Duration(seconds: 1),
        ),
      );
      Navigator.pop(context);
    } }catch(e) {
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

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List listDateAddedFilter = [
      {"name": "Last added date", "value": false},
      {"name": "First added date", "value": true},
    ];
    List listRoleFilter = [
      {"name": "Administrator", "value": "Administrator"},
      {"name": "Organizer", "value": "Organizer"},
      {"name": "Customer", "value": "Customer"},
    ];
    List listStatusFilter = [
      {"name": "Active", "value": "Active"},
      {"name": "Inactive", "value": "Inactive"},
    ];
    return FutureBuilder(
      future: futureUser,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            body: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 8,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(35, 25, 35, 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("User management", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          const Text("Management your team members and their account permissions here.", style: TextStyle(fontSize: 16)),
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
                                      Text("General customers", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[600])),
                                      const SizedBox(height: 10),
                                      Text("$totalItems", style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold))
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
                                      Text("Administrators", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[600])),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text("$administratorCount", style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                                          Container(
                                            padding: const EdgeInsets.fromLTRB(8, 1, 8, 1),
                                            decoration: BoxDecoration(
                                                color: const Color.fromARGB(255, 157, 241, 162), borderRadius: BorderRadius.circular(3)),
                                            child: Text("${administratorPercentage.toStringAsFixed(2)} %", style: const TextStyle(fontSize: 13)),
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
                                      Text("Organizers", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[600])),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text("$organizerCount", style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                                          Container(
                                            padding: const EdgeInsets.fromLTRB(8, 1, 8, 1),
                                            decoration: BoxDecoration(
                                                color: const Color.fromARGB(255, 242, 187, 106), borderRadius: BorderRadius.circular(3)),
                                            child: Text("${organizerPercentage.toStringAsFixed(2)} %", style: const TextStyle(fontSize: 13)),
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
                                      Text("Customers", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[600])),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text("$customerCount", style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                                          Container(
                                            padding: const EdgeInsets.fromLTRB(8, 1, 8, 1),
                                            decoration: BoxDecoration(
                                                color: const Color.fromARGB(255, 213, 213, 213), borderRadius: BorderRadius.circular(3)),
                                            child: Text("${customerPercentage.toStringAsFixed(2)} %", style: const TextStyle(fontSize: 13)),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              const Text(
                                "All users",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Expanded(
                                child: Row(
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
                                          hintStyle: const TextStyle(fontSize: 14),
                                          prefixIcon: const Icon(Icons.search, size: 20),
                                          suffixIcon: searchController.text != ""
                                              ? InkWell(
                                                  hoverColor: Colors.transparent,
                                                  highlightColor: Colors.transparent,
                                                  focusColor: Colors.transparent,
                                                  splashColor: Colors.transparent,
                                                  onTap: () {
                                                    setState(() {
                                                      searchController.clear();
                                                    });
                                                    search();
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
                                          if (isShowUserFilter) {
                                            isShowUserFilter = false;
                                            sortByDateAddedAsc = null;
                                            _selectedRoleFilter = '';
                                            _selectedStatusFilter = '';
                                          } else {
                                            isShowUserFilter = true;
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
                                            Text(isShowUserFilter ? "Hide Filters" : "Filters",
                                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))
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
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return const AddUserWidget();
                                            });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                        decoration: BoxDecoration(
                                            color: Colors.blue, border: Border.all(color: Colors.blue), borderRadius: BorderRadius.circular(5)),
                                        child: const Row(
                                          children: [
                                            Icon(Icons.add, size: 20, color: Colors.white),
                                            SizedBox(width: 8),
                                            Text("Add user", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(
                            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
                                  decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 235, 235, 235),
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8))),
                                  child: const Row(
                                    children: [
                                      Expanded(flex: 4, child: Text("Name", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                                      Expanded(flex: 2, child: Text("Role", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                                      Expanded(flex: 2, child: Text("Status", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                                      Expanded(flex: 2, child: Text("Date added", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                                      Expanded(flex: 2, child: Text("Last updated", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                                      Expanded(child: Text("Action", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    for (var user in users)
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 4,
                                              child: Row(
                                                children: [
                                                  ClipOval(
                                                    child: Image.asset("images/${user.avatar}", height: 38, width: 38),
                                                  ),
                                                  const SizedBox(width: 15),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(user.fullName,
                                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[700])),
                                                      Text(user.email, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Container(
                                                    padding: const EdgeInsets.fromLTRB(15, 3, 15, 3),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: user.role == "Administrator"
                                                                ? Colors.green
                                                                : user.role == "Organizer"
                                                                    ? Colors.orange
                                                                    : const Color.fromARGB(255, 108, 108, 108)),
                                                        borderRadius: BorderRadius.circular(6)),
                                                    child: Text(
                                                      user.role,
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: user.role == "Administrator"
                                                              ? Colors.green
                                                              : user.role == "Organizer"
                                                                  ? Colors.orange
                                                                  : const Color.fromARGB(255, 108, 108, 108),
                                                          fontWeight: FontWeight.w700),
                                                    )),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                user.status,
                                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(DateFormat('MMM d, yyyy').format(user.dateAdded),
                                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[700])),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(DateFormat('MMM d, yyyy').format(user.lastUpdated),
                                                  style: TextStyle(fontSize: 16, color: Colors.grey[700], fontWeight: FontWeight.w500)),
                                            ),
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Tooltip(
                                                    message: "Edit",
                                                    child: InkWell(
                                                      hoverColor: Colors.transparent,
                                                      highlightColor: Colors.transparent,
                                                      focusColor: Colors.transparent,
                                                      splashColor: Colors.transparent,
                                                      onTap: () {
                                                        showDialog(
                                                            context: context,
                                                            builder: (BuildContext context) {
                                                              return EditUserWidget(userId: user.userId);
                                                            });
                                                      },
                                                      child: Icon(Icons.edit, size: 19, color: Colors.grey[700]),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 20),
                                                  Tooltip(
                                                    message: "Delete",
                                                    child: InkWell(
                                                      hoverColor: Colors.transparent,
                                                      highlightColor: Colors.transparent,
                                                      focusColor: Colors.transparent,
                                                      splashColor: Colors.transparent,
                                                      onTap: () {
                                                        showDialog(
                                                            context: context,
                                                            builder: (BuildContext context) {
                                                              return Dialog(
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(5),
                                                                ),
                                                                child: SingleChildScrollView(
                                                                  scrollDirection: Axis.horizontal,
                                                                  child: SingleChildScrollView(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(20),
                                                                      child: Column(
                                                                        children: [
                                                                          RichText(
                                                                            text: TextSpan(
                                                                              children: [
                                                                                const TextSpan(
                                                                                    text: "Are you sure you want to delete user \"",
                                                                                    style: TextStyle(
                                                                                        fontSize: 15,
                                                                                        fontWeight: FontWeight.w500,
                                                                                        color: Colors.black)),
                                                                                TextSpan(
                                                                                    text: user.fullName,
                                                                                    style: const TextStyle(
                                                                                        fontSize: 15,
                                                                                        fontWeight: FontWeight.w500,
                                                                                        color: Colors.red)),
                                                                                const TextSpan(
                                                                                    text: "\"?",
                                                                                    style: TextStyle(
                                                                                        fontSize: 15,
                                                                                        fontWeight: FontWeight.w500,
                                                                                        color: Colors.black)),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          const SizedBox(height: 30),
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              InkWell(
                                                                                hoverColor: Colors.transparent,
                                                                                highlightColor: Colors.transparent,
                                                                                focusColor: Colors.transparent,
                                                                                splashColor: Colors.transparent,
                                                                                onTap: () {
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: Container(
                                                                                  alignment: Alignment.center,
                                                                                  width: 75,
                                                                                  padding: const EdgeInsets.fromLTRB(15, 3, 15, 3),
                                                                                  decoration: BoxDecoration(
                                                                                    border:
                                                                                        Border.all(color: const Color.fromARGB(255, 37, 138, 221)),
                                                                                    borderRadius: BorderRadius.circular(5),
                                                                                  ),
                                                                                  child: const Text("Không",
                                                                                      style: TextStyle(
                                                                                          color: Color.fromARGB(255, 37, 138, 221),
                                                                                          fontSize: 13,
                                                                                          fontWeight: FontWeight.w500)),
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
                                                                                    deleteUser(user.userId);
                                                                                  });
                                                                                },
                                                                                child: Container(
                                                                                  alignment: Alignment.center,
                                                                                  width: 75,
                                                                                  padding: const EdgeInsets.fromLTRB(15, 3, 15, 3),
                                                                                  decoration: BoxDecoration(
                                                                                    color: const Color.fromARGB(255, 37, 138, 221),
                                                                                    border:
                                                                                        Border.all(color: const Color.fromARGB(255, 37, 138, 221)),
                                                                                    borderRadius: BorderRadius.circular(5),
                                                                                  ),
                                                                                  child: const Text("Có",
                                                                                      style: TextStyle(
                                                                                          color: Colors.white,
                                                                                          fontSize: 13,
                                                                                          fontWeight: FontWeight.w500)),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            });
                                                      },
                                                      child: Icon(Icons.delete_outlined, size: 21, color: Colors.grey[700]),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          PaginationWidget(
                            totalPages: totalPages,
                            onPageChanged: (newCurrentPage) {
                              setState(() {
                                futureUser = getListUsers(newCurrentPage, findRequestUser);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (isShowUserFilter)
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                      decoration: const BoxDecoration(
                        border: Border(
                          left: BorderSide(color: Colors.grey),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      onTap: () {
                                        setState(() {
                                          isShowUserFilter = false;
                                          sortByDateAddedAsc = null;
                                          _selectedRoleFilter = '';
                                          _selectedStatusFilter = '';
                                        });
                                        search();
                                      },
                                      child: const Icon(Icons.close, size: 22),
                                    ),
                                  ],
                                ),
                                const Text("Filter", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Text("Choose from options below and we will filter items for you",
                                    style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                                const SizedBox(height: 35),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Date added", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                    const Padding(padding: EdgeInsets.fromLTRB(0, 2, 0, 10), child: Divider(thickness: 1)),
                                    Row(
                                      children: listDateAddedFilter.map((option) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 4),
                                          decoration: BoxDecoration(
                                              border: Border.all(color: sortByDateAddedAsc == option["value"] ? Colors.blue : Colors.grey, width: 2),
                                              borderRadius: BorderRadius.circular(99)),
                                          margin: const EdgeInsets.only(right: 7),
                                          child: Row(
                                            children: [
                                              Radio<bool>(
                                                activeColor: Colors.blue,
                                                value: option["value"],
                                                groupValue: sortByDateAddedAsc,
                                                onChanged: (bool? newValue) {
                                                  setState(() {
                                                    sortByDateAddedAsc = newValue!;
                                                  });
                                                },
                                              ),
                                              Text(option["name"],
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      color: sortByDateAddedAsc == option["value"] ? Colors.blue : Colors.black,
                                                      fontWeight: FontWeight.w500)),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 35),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Role", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                    const Padding(padding: EdgeInsets.fromLTRB(0, 2, 0, 10), child: Divider(thickness: 1)),
                                    Row(
                                      children: listRoleFilter.map((option) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 4),
                                          decoration: BoxDecoration(
                                              border: Border.all(color: _selectedRoleFilter == option["value"] ? Colors.blue : Colors.grey, width: 2),
                                              borderRadius: BorderRadius.circular(99)),
                                          margin: const EdgeInsets.only(right: 7),
                                          child: Row(
                                            children: [
                                              Radio<String>(
                                                activeColor: Colors.blue,
                                                value: option["value"],
                                                groupValue: _selectedRoleFilter,
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    _selectedRoleFilter = newValue!;
                                                  });
                                                },
                                              ),
                                              Text(option["name"],
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      color: _selectedRoleFilter == option["value"] ? Colors.blue : Colors.black,
                                                      fontWeight: FontWeight.w500)),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 35),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Status", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                    const Padding(padding: EdgeInsets.fromLTRB(0, 2, 0, 10), child: Divider(thickness: 1)),
                                    Row(
                                      children: listStatusFilter.map((option) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 4),
                                          decoration: BoxDecoration(
                                              border:
                                                  Border.all(color: _selectedStatusFilter == option["value"] ? Colors.blue : Colors.grey, width: 2),
                                              borderRadius: BorderRadius.circular(99)),
                                          margin: const EdgeInsets.only(right: 7),
                                          child: Row(
                                            children: [
                                              Radio<String>(
                                                activeColor: Colors.blue,
                                                value: option["value"],
                                                groupValue: _selectedStatusFilter,
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    _selectedStatusFilter = newValue!;
                                                  });
                                                },
                                              ),
                                              Text(option["name"],
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      color: _selectedStatusFilter == option["value"] ? Colors.blue : Colors.black,
                                                      fontWeight: FontWeight.w500)),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
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
                                    sortByDateAddedAsc = null;
                                    _selectedRoleFilter = '';
                                    _selectedStatusFilter = '';
                                  });
                                  search();
                                },
                                child: Container(
                                  width: 110,
                                  padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                                  decoration: BoxDecoration(border: Border.all(color: Colors.blue), borderRadius: BorderRadius.circular(5)),
                                  child: const Center(
                                      child: Text("Reset", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.blue))),
                                ),
                              ),
                              const SizedBox(width: 30),
                              InkWell(
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  search();
                                },
                                child: Container(
                                  width: 110,
                                  padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                                  decoration: BoxDecoration(
                                      color: Colors.blue, border: Border.all(color: Colors.blue), borderRadius: BorderRadius.circular(5)),
                                  child: const Center(
                                      child: Text("Apply", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white))),
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
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
