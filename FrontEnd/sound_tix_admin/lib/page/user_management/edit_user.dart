import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sound_tix_admin/api.dart';
import 'package:sound_tix_admin/components/image_picker.dart';
import 'package:sound_tix_admin/components/textfield_custom.dart';
import 'package:sound_tix_admin/entity/user.dart';

class EditUserWidget extends StatefulWidget {
  final int? userId;
  const EditUserWidget({super.key, this.userId});

  @override
  State<EditUserWidget> createState() => _EditUserWidgetState();
}

class _EditUserWidgetState extends State<EditUserWidget> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _birthDayController = TextEditingController();
  User? user;
  bool _isLoadingEdit = true;
  String? fileName;
  String _selectedSex = 'Nam';
  String _selectedRole = 'Customer';
  String _selectedStatus = 'Active';
  DateTime? _selectedBirthDay;
  bool _isShowPassword = true;

  @override
  void initState() {
    getDetailUser(widget.userId);
    super.initState();
  }

  getDetailUser(userId) async {
    var response = await httpGet("http://localhost:8080/user/$userId");
    setState(() {
      user = User.fromMap(response["body"]);
      _selectedSex = user!.sex;
      _selectedRole = user!.role;
      _selectedStatus = user!.status;
      _selectedBirthDay = user!.birthDay;
      setInitValue();
      _isLoadingEdit = false;
    });
  }

  updateUser() async {
    dynamic userData = {
      "phoneNumber": _phoneNumberController.text,
      "email": _emailController.text,
      "passWord": _passwordController.text,
      "fullName": _fullNameController.text,
      "role": _selectedRole,
      "sex": _selectedSex,
      "birthDay": DateFormat('yyyy-MM-dd').format(_selectedBirthDay!),
      "status": _selectedStatus,
      "avatar": fileName
    };

    var response = await httpPatch("http://localhost:8080/user/update/${user!.userId}", userData);

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

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDay ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedBirthDay) {
      setState(() {
        _selectedBirthDay = picked;
        _birthDayController.text = formatDate(picked);
      });
    }
  }

  String formatDate(DateTime date) {
    return "${date.day}-${date.month}-${date.year}";
  }

  setInitValue() {
    setState(() {
      if (user != null) {
        _fullNameController.text = user!.fullName;
        _emailController.text = user!.email;
        _phoneNumberController.text = user!.phoneNumber;
        _passwordController.text = user!.passWord;
        if (_selectedBirthDay != null) {
          _birthDayController.text = formatDate(_selectedBirthDay!);
        }
      }
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _birthDayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List listSex = [
      {"name": "Nam", "value": "Nam"},
      {"name": "Nữ", "value": "Nữ"},
    ];
    List listRole = [
      {"name": "Administrator", "value": "Administrator"},
      {"name": "Organizer", "value": "Organizer"},
      {"name": "Customer", "value": "Customer"},
    ];
    List listStatus = [
      {"name": "Active", "value": "Active"},
      {"name": "Inactive", "value": "Inactive"},
    ];
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
                  child: Text("Edit user", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Divider(),
                ),
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ImportImageWidget(
                            nameAvatar: user!.avatar,
                            callbackFileName: (newFileName) {
                              setState(() {
                                fileName = newFileName;
                              });
                            }),
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Expanded(child: Text("Full name", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                                Expanded(
                                  flex: 4,
                                  child: InputCustom(controller: _fullNameController, obscureText: false),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                const Expanded(child: Text("Sex", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                                Expanded(
                                  flex: 4,
                                  child: Row(
                                    children: listSex.map((option) {
                                      return Container(
                                        alignment: Alignment.centerLeft,
                                        width: 150,
                                        child: Row(
                                          children: [
                                            Radio<String>(
                                              activeColor: Colors.blue,
                                              value: option["value"],
                                              groupValue: _selectedSex,
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  _selectedSex = newValue!;
                                                });
                                              },
                                            ),
                                            const SizedBox(width: 10),
                                            Text(option["name"]),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                const Expanded(child: Text("Email", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                                Expanded(flex: 4, child: InputCustom(controller: _emailController, obscureText: false)),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                const Expanded(child: Text("Phone number", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                                Expanded(flex: 4, child: InputCustom(controller: _phoneNumberController, obscureText: false)),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                const Expanded(child: Text("Password", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                                Expanded(
                                  flex: 4,
                                  child: Stack(
                                    children: [
                                      InputCustom(controller: _passwordController, obscureText: _isShowPassword),
                                      Positioned(
                                        top: 15,
                                        right: 15,
                                        child: InkWell(
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          onTap: () {
                                            setState(() {
                                              _isShowPassword = !_isShowPassword;
                                            });
                                          },
                                          child: _isShowPassword ? const Icon(Icons.remove_red_eye_outlined) : const Icon(Icons.remove_red_eye),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                const Expanded(child: Text("Role", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                                Expanded(
                                  flex: 4,
                                  child: Row(
                                    children: listRole.map((option) {
                                      return Container(
                                        alignment: Alignment.centerLeft,
                                        width: 150,
                                        child: Row(
                                          children: [
                                            Radio<String>(
                                              activeColor: Colors.blue,
                                              value: option["value"],
                                              groupValue: _selectedRole,
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  _selectedRole = newValue!;
                                                });
                                              },
                                            ),
                                            const SizedBox(width: 10),
                                            Text(option["name"]),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                const Expanded(child: Text("Birth day", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                                Expanded(
                                  flex: 4,
                                  child: InkWell(
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    onTap: () => _selectDate(context),
                                    child: AbsorbPointer(
                                      child: InputCustom(
                                        controller: _birthDayController,
                                        obscureText: false,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                const Expanded(child: Text("Status", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                                Expanded(
                                  flex: 4,
                                  child: Row(
                                    children: listStatus.map((option) {
                                      return Container(
                                        alignment: Alignment.centerLeft,
                                        width: 150,
                                        child: Row(
                                          children: [
                                            Radio<String>(
                                              activeColor: Colors.blue,
                                              value: option["value"],
                                              groupValue: _selectedStatus,
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  _selectedStatus = newValue!;
                                                });
                                              },
                                            ),
                                            const SizedBox(width: 10),
                                            Text(option["name"]),
                                          ],
                                        ),
                                      );
                                    }).toList(),
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
                                      setState(() {
                                        updateUser();
                                      });
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
                ),
              ],
            ),
          );
  }
}
