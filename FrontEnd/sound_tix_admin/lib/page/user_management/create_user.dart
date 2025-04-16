import 'dart:async';

import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sound_tix_admin/api.dart';
import 'package:sound_tix_admin/components/image_picker.dart';
import 'package:sound_tix_admin/components/textfield_custom.dart';

class AddUserWidget extends StatefulWidget {
  const AddUserWidget({super.key});

  @override
  State<AddUserWidget> createState() => _AddUserWidgetState();
}

class _AddUserWidgetState extends State<AddUserWidget> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _birthDayController = TextEditingController();
  String? avatarFileName;
  bool _showInvalidError = false;
  bool _showEmptyError = false;
  bool _showEmailFieldError = false;
  String _selectedRole = 'Customer';
  String _selectedSex = 'Nam';
  DateTime? _selectedBirthDay;
  bool _isShowPassword = true;

  addUser() async {
    final body = {
      'userName': _userNameController.text,
      'email': _emailController.text,
      'passWord': _passwordController.text,
      'fullName': _fullNameController.text,
      'phoneNumber': _phoneNumberController.text,
      "birthDay": DateFormat('yyyy-MM-dd').format(_selectedBirthDay!),
      'avatar': avatarFileName,
      'role': _selectedRole,
      'sex': _selectedSex,
      'status': "Active",
      'qrCode': "qrCode_${formatName(_fullNameController.text)}.png",
    };

    try {
      final response = await httpPost("http://localhost:8080/user/add", body);
      if (response.containsKey("body") && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đăng ký thành công.'),
            duration: Duration(seconds: 1),
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đăng ký không thành công.'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      // print(e);
    }
  }

  String formatName(input) {
    return removeDiacritics(input).replaceAll(' ', '');
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

  bool validPassword(String password) {
    final RegExp passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$');
    return passwordRegex.hasMatch(password);
  }

  void checkValidatePassword(String value) {
    setState(() {
      _showInvalidError = !validPassword(value);
    });
  }

  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  void checkEmail(String value) {
    setState(() {
      _showEmailFieldError = !isValidEmail(value);
    });
  }

  bool validateFields() {
    return _emailController.text.isNotEmpty &&
        _userNameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _fullNameController.text.isNotEmpty &&
        _phoneNumberController.text.isNotEmpty &&
        _birthDayController.text.isNotEmpty &&
        avatarFileName != null;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _userNameController.dispose();
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
    return AlertDialog(
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
            child: Text("Add user", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
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
                      nameAvatar: "avatar.jpg",
                      callbackFileName: (newFileName) {
                        setState(() {
                          avatarFileName = newFileName;
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
                          const Expanded(child: Text("Fullname", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                          Expanded(
                            flex: 4,
                            child: InputCustom(
                                controller: _fullNameController,
                                label: const Text("Fullname"),
                                prefixIcon: const Icon(Icons.person_pin_circle_outlined),
                                hintText: "Fullname",
                                obscureText: false),
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
                          const Expanded(child: Text("Username", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                          Expanded(
                            flex: 4,
                            child: InputCustom(
                                controller: _userNameController,
                                label: const Text("Username"),
                                prefixIcon: const Icon(Icons.person_outlined),
                                hintText: "Username",
                                obscureText: false),
                          ),
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
                                InputCustom(
                                  controller: _passwordController,
                                  label: const Text("Password"),
                                  prefixIcon: const Icon(Icons.lock_outlined),
                                  hintText: "Password",
                                  obscureText: _isShowPassword,
                                  onChanged: (value) {
                                    checkValidatePassword(value);
                                  },
                                ),
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
                      if (_showInvalidError)
                        const Column(
                          children: [
                            SizedBox(height: 10),
                            Text("Mật khẩu không hợp lệ", style: TextStyle(color: Colors.red, fontSize: 12)),
                          ],
                        ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Expanded(child: Text("Email", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                          Expanded(
                            flex: 4,
                            child: InputCustom(
                              controller: _emailController,
                              label: const Text("Email"),
                              prefixIcon: const Icon(Icons.email_outlined),
                              hintText: "Email",
                              obscureText: false,
                              onChanged: (value) {
                                checkEmail(value);
                              },
                            ),
                          ),
                        ],
                      ),
                      if (_showEmailFieldError)
                        const Column(
                          children: [
                            SizedBox(height: 10),
                            Text("Địa chỉ email không hợp lệ", style: TextStyle(color: Colors.red, fontSize: 12)),
                          ],
                        ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Expanded(child: Text("Phone number", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                          Expanded(
                            flex: 4,
                            child: InputCustom(
                                controller: _phoneNumberController,
                                label: const Text("Phone number"),
                                prefixIcon: const Icon(Icons.phone),
                                hintText: "Phone number",
                                obscureText: false),
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
                                child: InputCustom(controller: _birthDayController, obscureText: false),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: _showEmptyError ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
                        children: [
                          if (_showEmptyError) const Text("Vui lòng điền đầy đủ thông tin", style: TextStyle(color: Colors.red, fontSize: 12)),
                          Row(
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
                                  onTap: () async {
                                    setState(() {
                                      _showEmptyError = !validateFields();
                                    });
                                    if (validateFields() && !_showInvalidError && !_showEmailFieldError) {
                                      addUser();
                                    }
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.blue),
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.blue,
                                    ),
                                    child: const Text("Submit", style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500)),
                                  ),
                                ),
                              ),
                            ],
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
