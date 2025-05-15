import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sound_tix_view/api.dart';
import 'package:sound_tix_view/components/app_localizations.dart';
import 'package:sound_tix_view/components/custom_input.dart';
import 'package:sound_tix_view/entity/user.dart';
import 'package:sound_tix_view/model/model.dart';

class ChangePasswordWidget extends StatefulWidget {
  final int userId;
  final Function onCompleted;
  const ChangePasswordWidget({super.key, required this.userId, required this.onCompleted});

  @override
  State<ChangePasswordWidget> createState() => _ChangePasswordWidgetState();
}

class _ChangePasswordWidgetState extends State<ChangePasswordWidget> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController = TextEditingController();
  User? user;
  bool _isLoadingEdit = true;
  bool _isIncorrectPassword = false;
  bool _isNotMatchPassword = false;
  bool isShowOldPassword = true;
  bool isShowNewPassword = true;
  bool isShowConfirmNewPassword = true;

  @override
  void initState() {
    getDetailUser(widget.userId);
    super.initState();
  }

  getDetailUser(userId) async {
    var response = await httpGet(context, "http://localhost:8080/user/$userId");
    setState(() {
      user = User.fromMap(response["body"]);
      _isLoadingEdit = false;
    });
  }

  updateUser() async {
    dynamic userData = {
      "passWord": _newPasswordController.text,
    };
try {
    await httpPatch(context, "http://localhost:8080/user/update/${user!.userId}", userData);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).translate('Change password successful')),
          duration: const Duration(seconds: 1),
        ),
      );
      Navigator.pop(context);
      widget.onCompleted();
    }}catch(e) {
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
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChangeThemeModel>(builder: (context, changeThemeModel, child) {
      return Scaffold(
        body: _isLoadingEdit
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Container(
                    color: const Color(0xFF2DC275),
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              color: const Color(0xFF2DC275),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white, width: 0.7)),
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
                        Text(AppLocalizations.of(context).translate("Change password"),
                            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context).translate("Old password"),
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w500, color: changeThemeModel.isDark ? Colors.white : Colors.black),
                                ),
                                const SizedBox(height: 5),
                                Stack(
                                  children: [
                                    InputCustom(
                                      controller: _oldPasswordController,
                                      obscureText: isShowOldPassword,
                                      maxLines: 1,
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
                                            isShowOldPassword = !isShowOldPassword;
                                          });
                                        },
                                        child: isShowOldPassword ? const Icon(Icons.remove_red_eye_outlined) : const Icon(Icons.remove_red_eye),
                                      ),
                                    ),
                                  ],
                                ),
                                if (_isIncorrectPassword)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(AppLocalizations.of(context).translate("Incorrect password"),
                                        style: const TextStyle(color: Colors.red, fontSize: 12)),
                                  ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context).translate("New password"),
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w500, color: changeThemeModel.isDark ? Colors.white : Colors.black),
                                ),
                                const SizedBox(height: 5),
                                Stack(
                                  children: [
                                    InputCustom(
                                      controller: _newPasswordController,
                                      obscureText: isShowNewPassword,
                                      maxLines: 1,
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
                                            isShowNewPassword = !isShowNewPassword;
                                          });
                                        },
                                        child: isShowNewPassword ? const Icon(Icons.remove_red_eye_outlined) : const Icon(Icons.remove_red_eye),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context).translate("Confirm new password"),
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w500, color: changeThemeModel.isDark ? Colors.white : Colors.black),
                                ),
                                const SizedBox(height: 5),
                                Stack(
                                  children: [
                                    InputCustom(
                                      controller: _confirmNewPasswordController,
                                      onChanged: (value) {
                                        setState(() {
                                          if (_confirmNewPasswordController.text != _newPasswordController.text) {
                                            _isNotMatchPassword = true;
                                          } else {
                                            _isNotMatchPassword = false;
                                          }
                                        });
                                      },
                                      obscureText: isShowConfirmNewPassword,
                                      maxLines: 1,
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
                                            isShowConfirmNewPassword = !isShowConfirmNewPassword;
                                          });
                                        },
                                        child:
                                            isShowConfirmNewPassword ? const Icon(Icons.remove_red_eye_outlined) : const Icon(Icons.remove_red_eye),
                                      ),
                                    ),
                                  ],
                                ),
                                if (_isNotMatchPassword)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(AppLocalizations.of(context).translate("Password does not match"),
                                        style: const TextStyle(color: Colors.red, fontSize: 12)),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
        bottomSheet: Container(
          alignment: Alignment.center,
          height: 60,
          color: changeThemeModel.isDark ? const Color.fromARGB(255, 42, 42, 42) : Colors.white,
          padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
          child: InkWell(
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            focusColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              setState(() {
                if (_oldPasswordController.text != user!.passWord) {
                  _isIncorrectPassword = true;
                } else {
                  _isIncorrectPassword = false;
                }
              });
              if (!_isIncorrectPassword && !_isNotMatchPassword) {
                updateUser();
              }
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(color: const Color(0xFF2DC275), borderRadius: BorderRadius.circular(99)),
              child: Text(AppLocalizations.of(context).translate("Save change"),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15)),
            ),
          ),
        ),
      );
    });
  }
}
