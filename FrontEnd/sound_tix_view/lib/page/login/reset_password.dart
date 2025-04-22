import 'package:flutter/material.dart';
import 'package:sound_tix_view/components/app_localizations.dart';
import 'package:sound_tix_view/components/close_button.dart';
import 'package:sound_tix_view/components/custom_input.dart';
import 'package:sound_tix_view/entity/user.dart';

class ResetPage extends StatefulWidget {
  final String? email;
  const ResetPage({super.key, this.email});

  @override
  State<ResetPage> createState() => _ResetPageState();
}

class _ResetPageState extends State<ResetPage> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isShowNewPassword = true;
  bool _isShowConfirmPassword = true;
  bool _isMatch = false;
  bool _showMismatchMessage = false;
  bool _showInvalidPasswordMessage = false;
  bool _showEmptyPasswordError = false;
  List<User> users = [];

  @override
  void initState() {
    // searchUsersAndDisplay(widget.email);
    super.initState();
  }

  // void searchUsersAndDisplay(String? email) async {
  //   users = await searchUsers(email);
  // }

  // updateUser() async {
  //   User userData = User(passWord: _newPasswordController.text, userName: '', email: '', fullName: '');

  //   await httpPatch("http://localhost:8080/user/update/${users[0].userId}", userData, headers: {'Content-Type': 'application/json; charset=UTF-8'});

  //   context.go('/verified');

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(
  //       content: Text('Cập nhật mật khẩu thành công!'),
  //       duration: Duration(seconds: 1),
  //     ),
  //   );
  //   // if (response.statusCode == 200) {
  //   //   setState(() {
  //   //     // _isUpdated = true;
  //   //   });
  //   // } else {
  //   //   // _isUpdated = false;
  //   // }
  // }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void checkMatch(String value) {
    setState(() {
      _showEmptyPasswordError = !validatePasswordFields();
      _isMatch = _newPasswordController.text == value;
      if (_confirmPasswordController.text.isNotEmpty) {
        _showMismatchMessage = !_isMatch;
      } else {
        _showMismatchMessage = false;
      }
    });
  }

  bool isValidPassword(String password) {
    final RegExp passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$');
    return passwordRegex.hasMatch(password);
  }

  void validatePassword(String value) {
    setState(() {
      _showInvalidPasswordMessage = !isValidPassword(value);
    });
  }

  bool validatePasswordFields() {
    return _newPasswordController.text.isNotEmpty && _confirmPasswordController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          Container(
            color: const Color(0xFF2DC275),
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Row(
              children: [
                const ButtonBack(),
                const SizedBox(width: 20),
                Text(AppLocalizations.of(context).translate("Reset Password"),
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(AppLocalizations.of(context).translate("Reset Password"), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
                const SizedBox(height: 10),
                Text(
                  AppLocalizations.of(context).translate("At least 8 characters, including numbers, letters and at least 1 special character."),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 25),
                Stack(
                  children: [
                    InputCustom(
                      controller: _newPasswordController,
                      label: Text(AppLocalizations.of(context).translate("New Password")),
                      prefixIcon: const Icon(Icons.lock_outlined),
                      hintText: AppLocalizations.of(context).translate("New Password"),
                      obscureText: _isShowNewPassword,
                      onChanged: (value) {
                        validatePassword(value);
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
                            _isShowNewPassword = !_isShowNewPassword;
                          });
                        },
                        child: _isShowNewPassword ? const Icon(Icons.remove_red_eye_outlined) : const Icon(Icons.remove_red_eye),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (_showInvalidPasswordMessage)
                  Text(AppLocalizations.of(context).translate("Invalid password"), style: const TextStyle(color: Colors.red, fontSize: 12)),
                const SizedBox(height: 15),
                Stack(
                  children: [
                    InputCustom(
                      controller: _confirmPasswordController,
                      label: Text(AppLocalizations.of(context).translate("Confirm Password")),
                      prefixIcon: const Icon(Icons.lock_outlined),
                      hintText: AppLocalizations.of(context).translate("Confirm Password"),
                      obscureText: _isShowConfirmPassword,
                      onChanged: (value) {
                        setState(() {
                          checkMatch(value);
                        });
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
                            _isShowConfirmPassword = !_isShowConfirmPassword;
                          });
                        },
                        child: _isShowConfirmPassword ? const Icon(Icons.remove_red_eye_outlined) : const Icon(Icons.remove_red_eye),
                      ),
                    ),
                  ],
                ),
                if (_showMismatchMessage && !_isMatch)
                  Column(
                    children: [
                      const SizedBox(height: 10),
                      Text(AppLocalizations.of(context).translate("Passwords do not match"), style: const TextStyle(color: Colors.red, fontSize: 12)),
                    ],
                  ),
                if (_showEmptyPasswordError)
                  Column(
                    children: [
                      const SizedBox(height: 10),
                      Text(AppLocalizations.of(context).translate("Please fill in all information"),
                          style: const TextStyle(color: Colors.red, fontSize: 12)),
                    ],
                  ),
                const SizedBox(height: 35),
                Center(
                  child: InkWell(
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      if (isValidPassword(_newPasswordController.text) && _isMatch && validatePasswordFields()) {
                        // updateUser();
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.fromLTRB(0, 11, 0, 11),
                      width: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(99),
                        color: const Color(0xFF2DC275),
                      ),
                      child: Text(AppLocalizations.of(context).translate("CONTINUE"), style: const TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
