import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sound_tix_view/api.dart';
import 'package:sound_tix_view/components/app_localizations.dart';
import 'package:sound_tix_view/components/custom_input.dart';
import 'package:sound_tix_view/components/image_picker.dart';
import 'package:sound_tix_view/entity/user.dart';
import 'package:sound_tix_view/model/model.dart';

class EditProfileWidget extends StatefulWidget {
  final int userId;
  final Function onCompleted;
  const EditProfileWidget({super.key, required this.userId, required this.onCompleted});

  @override
  State<EditProfileWidget> createState() => _EditProfileWidgetState();
}

class _EditProfileWidgetState extends State<EditProfileWidget> {
  User? user;
  bool _isLoadingEdit = true;
  String? fileName;
  String _selectedSex = '';
  DateTime? _selectedBirthDay;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _birthDayController = TextEditingController();

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
      _selectedBirthDay = user!.birthDay;
      _isLoadingEdit = false;
      setInitValue();
    });
  }

  updateUser() async {
    dynamic userData = {
      "birthDay": DateFormat('yyyy-MM-dd').format(_selectedBirthDay!),
      "phoneNumber": _phoneNumberController.text,
      "email": _emailController.text,
      "fullName": _fullNameController.text,
      "sex": _selectedSex,
      "avatar": fileName
    };

    var response = await httpPatch("http://localhost:8080/user/update/${user!.userId}", userData);
    if (response['statusCode'] == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).translate('Update successful')),
          duration: const Duration(seconds: 1),
        ),
      );
      Navigator.pop(context);
      widget.onCompleted();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).translate('Update failed')),
          duration: const Duration(seconds: 1),
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
    _birthDayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List listSex = [
      {"name": "Nam", "value": "Nam"},
      {"name": "Nữ", "value": "Nữ"},
    ];
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
                        Text(AppLocalizations.of(context).translate("Update information"),
                            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          ImportImageWidget(
                              nameAvatar: user!.avatar,
                              callbackFileName: (newFileName) {
                                setState(() {
                                  fileName = newFileName;
                                });
                              }),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context).translate("Full name"),
                                      style: TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.w500, color: changeThemeModel.isDark ? Colors.white : Colors.black),
                                    ),
                                    const SizedBox(height: 5),
                                    InputCustom(controller: _fullNameController, obscureText: false)
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context).translate("Phone number"),
                                      style: TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.w500, color: changeThemeModel.isDark ? Colors.white : Colors.black),
                                    ),
                                    const SizedBox(height: 5),
                                    InputCustom(controller: _phoneNumberController, obscureText: false)
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context).translate("Email"),
                                      style: TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.w500, color: changeThemeModel.isDark ? Colors.white : Colors.black),
                                    ),
                                    const SizedBox(height: 5),
                                    InputCustom(controller: _emailController, obscureText: false)
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context).translate("Date of birth"),
                                      style: TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.w500, color: changeThemeModel.isDark ? Colors.white : Colors.black),
                                    ),
                                    const SizedBox(height: 5),
                                    InkWell(
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
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context).translate("Sex"),
                                      style: TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.w500, color: changeThemeModel.isDark ? Colors.white : Colors.black),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: listSex.map((option) {
                                        return Container(
                                          alignment: Alignment.centerLeft,
                                          width: 150,
                                          child: Row(
                                            children: [
                                              Radio<String>(
                                                fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                                                  if (states.contains(WidgetState.selected)) {
                                                    return const Color(0xFF2DC275);
                                                  }
                                                  return changeThemeModel.isDark ? Colors.white : Colors.black;
                                                }),
                                                value: option["value"],
                                                groupValue: _selectedSex,
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    _selectedSex = newValue!;
                                                  });
                                                },
                                              ),
                                              const SizedBox(width: 10),
                                              Text(option["name"], style: TextStyle(color: changeThemeModel.isDark ? Colors.white : Colors.black)),
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
                          const SizedBox(height: 20),
                          InkWell(
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
                              padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2DC275),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                AppLocalizations.of(context).translate("Update"),
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      );
    });
  }
}
