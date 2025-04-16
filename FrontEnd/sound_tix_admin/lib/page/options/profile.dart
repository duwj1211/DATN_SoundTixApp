import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sound_tix_admin/api.dart';
import 'package:sound_tix_admin/components/dropdown_text_field.dart';
import 'package:sound_tix_admin/components/image_picker.dart';
import 'package:sound_tix_admin/components/textfield_custom.dart';
import 'package:sound_tix_admin/entity/user.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _birthDayController = TextEditingController();
  String? avatarFileName;
  String? _selectedRole;
  String? _selectedSex;
  DateTime? _selectedBirthDay;
  User? user;
  int userId = 1;
  bool _isLoadingData = true;
  bool isEditGeneralInfo = false;
  bool isEditPersonalInfo = false;
  bool isEditAccountInfo = false;

  @override
  void initState() {
    getDetailUser(userId);
    super.initState();
  }

  getDetailUser(userId) async {
    var response = await httpGet("http://localhost:8080/user/$userId");
    setState(() {
      user = User.fromMap(response["body"]);
      _selectedSex = user!.sex;
      _selectedRole = user!.role;
      _selectedBirthDay = user!.birthDay;
      setInitValue();
      _isLoadingData = false;
    });
  }

  updateUser() async {
    dynamic userData = {
      if (_selectedBirthDay != null) "birthDay": DateFormat('yyyy-MM-dd').format(_selectedBirthDay!),
      if (_phoneNumberController.text != "") "phoneNumber": _phoneNumberController.text,
      if (_emailController.text != "") "email": _emailController.text,
      if (_passwordController.text != "") "passWord": _passwordController.text,
      if (_fullNameController.text != "") "fullName": _fullNameController.text,
      if (_selectedSex != null) "sex": _selectedSex,
      if (_selectedRole != null) "role": _selectedRole,
      if (avatarFileName != null) "avatar": avatarFileName,
    };

    var response = await httpPatch("http://localhost:8080/user/update/${user!.userId}", userData);
    if (response['statusCode'] == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cập nhật thành công!'),
          duration: Duration(seconds: 1),
        ),
      );
      getDetailUser(user!.userId);
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
    List listRole = [
      {"name": "Administrator", "value": "Administrator"},
      {"name": "Organizer", "value": "Organizer"},
      {"name": "Customer", "value": "Customer"},
    ];
    List listSex = [
      {"name": "Nam", "value": "Nam"},
      {"name": "Nữ", "value": "Nữ"},
    ];
    return Scaffold(
      body: _isLoadingData
          ? const CircularProgressIndicator()
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 350),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 50),
                      Row(
                        children: [
                          InkWell(
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {
                              context.go('/home-page');
                            },
                            child: const Icon(
                              Icons.arrow_back_outlined,
                              size: 22,
                              color: Colors.deepPurple,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text("Back to Homepage", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey, width: 0.2),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            isEditGeneralInfo
                                ? Row(
                                    children: [
                                      ImportImageWidget(
                                        nameAvatar: user!.avatar,
                                        isSmall: true,
                                        callbackFileName: (newFileName) {
                                          setState(
                                            () {
                                              avatarFileName = newFileName;
                                            },
                                          );
                                        },
                                      ),
                                      const SizedBox(width: 15),
                                      SizedBox(
                                        width: 350,
                                        child: TextField(
                                          controller: _fullNameController,
                                          onChanged: (value) {
                                            _fullNameController.text = value;
                                          },
                                          decoration: InputDecoration(
                                            contentPadding: const EdgeInsets.all(10),
                                            fillColor: const Color.fromARGB(255, 235, 235, 235),
                                            hintText: "Fullname",
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
                                  )
                                : Row(
                                    children: [
                                      ClipOval(
                                        child: Image.asset(
                                          "images/${user!.avatar}",
                                          height: 60,
                                          width: 60,
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                user!.fullName,
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.grey[800],
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Tooltip(
                                                message: user!.status == "Active" ? "Active" : "Inactive",
                                                child: user!.status == "Active"
                                                    ? const Icon(Icons.check_circle_outline_outlined, color: Colors.green, size: 15)
                                                    : const Icon(Icons.cancel_outlined, color: Colors.red, size: 15),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            "@${user!.userName}",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                            InkWell(
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () {
                                setState(() {
                                  if (isEditGeneralInfo) {
                                    updateUser();
                                    isEditGeneralInfo = false;
                                  } else {
                                    isEditGeneralInfo = true;
                                  }
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey, width: 0.5),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: isEditGeneralInfo
                                    ? Row(
                                        children: [
                                          Icon(
                                            Icons.save_alt_outlined,
                                            size: 19,
                                            color: Colors.grey[600],
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            "Save",
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          Icon(
                                            Icons.edit_note,
                                            size: 19,
                                            color: Colors.grey[600],
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            "Edit",
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey, width: 0.2),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Personal Informations",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                InkWell(
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    setState(() {
                                      if (isEditPersonalInfo) {
                                        updateUser();
                                        isEditPersonalInfo = false;
                                      } else {
                                        isEditPersonalInfo = true;
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey, width: 0.5),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: isEditPersonalInfo
                                        ? Row(
                                            children: [
                                              Icon(
                                                Icons.save_alt_outlined,
                                                size: 19,
                                                color: Colors.grey[600],
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                "Save",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          )
                                        : Row(
                                            children: [
                                              Icon(
                                                Icons.edit_note,
                                                size: 19,
                                                color: Colors.grey[600],
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                "Edit",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: isEditPersonalInfo
                                  ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.all(7),
                                                    decoration: BoxDecoration(
                                                      color: const Color.fromARGB(255, 232, 232, 232),
                                                      borderRadius: BorderRadius.circular(99),
                                                    ),
                                                    child: Icon(
                                                      Icons.email,
                                                      size: 22,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                  const SizedBox(width: 20),
                                                  SizedBox(
                                                    width: 250,
                                                    child: TextField(
                                                      controller: _emailController,
                                                      onChanged: (value) {
                                                        _emailController.text = value;
                                                      },
                                                      decoration: InputDecoration(
                                                        contentPadding: const EdgeInsets.all(10),
                                                        fillColor: const Color.fromARGB(255, 235, 235, 235),
                                                        hintText: "Email",
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
                                            ),
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.all(7),
                                                    decoration: BoxDecoration(
                                                      color: const Color.fromARGB(255, 232, 232, 232),
                                                      borderRadius: BorderRadius.circular(99),
                                                    ),
                                                    child: Icon(
                                                      Icons.phone,
                                                      size: 22,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                  const SizedBox(width: 20),
                                                  SizedBox(
                                                    width: 250,
                                                    child: TextField(
                                                      controller: _phoneNumberController,
                                                      onChanged: (value) {
                                                        _phoneNumberController.text = value;
                                                      },
                                                      decoration: InputDecoration(
                                                        contentPadding: const EdgeInsets.all(10),
                                                        fillColor: const Color.fromARGB(255, 235, 235, 235),
                                                        hintText: "Phone number",
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
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.all(7),
                                                    decoration: BoxDecoration(
                                                      color: const Color.fromARGB(255, 232, 232, 232),
                                                      borderRadius: BorderRadius.circular(99),
                                                    ),
                                                    child: Icon(
                                                      (user!.sex == "Nam") ? Icons.male : Icons.female,
                                                      size: 22,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                  const SizedBox(width: 20),
                                                  SizedBox(
                                                    width: 250,
                                                    child: DynamicDropdownButton(
                                                      value: _selectedSex,
                                                      hintText: "Sex",
                                                      items: listSex.map<DropdownMenuItem<String>>((dynamic result) {
                                                        return DropdownMenuItem(
                                                          key: Key(result["name"]),
                                                          value: result["value"],
                                                          child: Text(result["name"]),
                                                        );
                                                      }).toList(),
                                                      onChanged: (newValue) {
                                                        _selectedSex = newValue;
                                                      },
                                                      isRequiredNotEmpty: true,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.all(7),
                                                    decoration: BoxDecoration(
                                                      color: const Color.fromARGB(255, 232, 232, 232),
                                                      borderRadius: BorderRadius.circular(99),
                                                    ),
                                                    child: Icon(
                                                      Icons.cake,
                                                      size: 22,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                  const SizedBox(width: 20),
                                                  SizedBox(
                                                    width: 250,
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
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  : Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.all(7),
                                                    decoration: BoxDecoration(
                                                      color: const Color.fromARGB(255, 232, 232, 232),
                                                      borderRadius: BorderRadius.circular(99),
                                                    ),
                                                    child: Icon(
                                                      Icons.email,
                                                      size: 22,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                  const SizedBox(width: 20),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        user!.email,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.grey[800],
                                                        ),
                                                      ),
                                                      Text(
                                                        "Mail address",
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.grey[600],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.all(7),
                                                    decoration: BoxDecoration(
                                                      color: const Color.fromARGB(255, 232, 232, 232),
                                                      borderRadius: BorderRadius.circular(99),
                                                    ),
                                                    child: Icon(
                                                      Icons.phone,
                                                      size: 22,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                  const SizedBox(width: 20),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        user!.phoneNumber,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.grey[800],
                                                        ),
                                                      ),
                                                      Text(
                                                        "Phone number",
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.grey[600],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.all(7),
                                                    decoration: BoxDecoration(
                                                      color: const Color.fromARGB(255, 232, 232, 232),
                                                      borderRadius: BorderRadius.circular(99),
                                                    ),
                                                    child: Icon(
                                                      (user!.sex == "Nam") ? Icons.male : Icons.female,
                                                      size: 22,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                  const SizedBox(width: 20),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        user!.sex,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.grey[800],
                                                        ),
                                                      ),
                                                      Text(
                                                        "Sex",
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.grey[600],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.all(7),
                                                    decoration: BoxDecoration(
                                                      color: const Color.fromARGB(255, 232, 232, 232),
                                                      borderRadius: BorderRadius.circular(99),
                                                    ),
                                                    child: Icon(
                                                      Icons.cake,
                                                      size: 22,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                  const SizedBox(width: 20),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        DateFormat("dd-MM-yyyy").format(user!.birthDay),
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.grey[800],
                                                        ),
                                                      ),
                                                      Text(
                                                        "Birthday",
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.grey[600],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
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
                      const SizedBox(height: 25),
                      Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey, width: 0.2),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Account Informations",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  InkWell(
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      setState(() {
                                        if (isEditAccountInfo) {
                                          updateUser();
                                          isEditAccountInfo = false;
                                        } else {
                                          isEditAccountInfo = true;
                                        }
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey, width: 0.5),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: isEditAccountInfo
                                          ? Row(
                                              children: [
                                                Icon(
                                                  Icons.save_alt_outlined,
                                                  size: 19,
                                                  color: Colors.grey[600],
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  "Save",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Row(
                                              children: [
                                                Icon(
                                                  Icons.edit_note,
                                                  size: 19,
                                                  color: Colors.grey[600],
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  "Edit",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    isEditAccountInfo
                                        ? Row(
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets.all(7),
                                                      decoration: BoxDecoration(
                                                        color: const Color.fromARGB(255, 232, 232, 232),
                                                        borderRadius: BorderRadius.circular(99),
                                                      ),
                                                      child: Icon(
                                                        Icons.person,
                                                        size: 22,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                    const SizedBox(width: 20),
                                                    SizedBox(
                                                      width: 250,
                                                      child: DynamicDropdownButton(
                                                        value: _selectedRole,
                                                        hintText: "Role",
                                                        items: listRole.map<DropdownMenuItem<String>>((dynamic result) {
                                                          return DropdownMenuItem(
                                                            key: Key(result["name"]),
                                                            value: result["value"],
                                                            child: Text(result["name"]),
                                                          );
                                                        }).toList(),
                                                        onChanged: (newValue) {
                                                          _selectedRole = newValue;
                                                        },
                                                        isRequiredNotEmpty: true,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets.all(7),
                                                      decoration: BoxDecoration(
                                                        color: const Color.fromARGB(255, 232, 232, 232),
                                                        borderRadius: BorderRadius.circular(99),
                                                      ),
                                                      child: Icon(
                                                        Icons.lock,
                                                        size: 22,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                    const SizedBox(width: 20),
                                                    SizedBox(
                                                      width: 250,
                                                      child: TextField(
                                                        controller: _passwordController,
                                                        onChanged: (value) {
                                                          _passwordController.text = value;
                                                        },
                                                        decoration: InputDecoration(
                                                          contentPadding: const EdgeInsets.all(10),
                                                          fillColor: const Color.fromARGB(255, 235, 235, 235),
                                                          hintText: "Password",
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
                                              ),
                                            ],
                                          )
                                        : Row(
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets.all(7),
                                                      decoration: BoxDecoration(
                                                        color: const Color.fromARGB(255, 232, 232, 232),
                                                        borderRadius: BorderRadius.circular(99),
                                                      ),
                                                      child: Icon(
                                                        Icons.person,
                                                        size: 22,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                    const SizedBox(width: 20),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          user!.role,
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w500,
                                                            color: Colors.grey[800],
                                                          ),
                                                        ),
                                                        Text(
                                                          "Role",
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            color: Colors.grey[600],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets.all(7),
                                                      decoration: BoxDecoration(
                                                        color: const Color.fromARGB(255, 232, 232, 232),
                                                        borderRadius: BorderRadius.circular(99),
                                                      ),
                                                      child: Icon(
                                                        Icons.lock,
                                                        size: 22,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                    const SizedBox(width: 20),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          user!.passWord,
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w500,
                                                            color: Colors.grey[800],
                                                          ),
                                                        ),
                                                        Text(
                                                          "Password",
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            color: Colors.grey[600],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(7),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(255, 232, 232, 232),
                                                  borderRadius: BorderRadius.circular(99),
                                                ),
                                                child: Icon(
                                                  Icons.calendar_month_outlined,
                                                  size: 22,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                              const SizedBox(width: 20),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    DateFormat("dd-MM-yyyy").format(user!.dateAdded),
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.grey[800],
                                                    ),
                                                  ),
                                                  Text(
                                                    "Date created",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(7),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(255, 232, 232, 232),
                                                  borderRadius: BorderRadius.circular(99),
                                                ),
                                                child: Icon(
                                                  Icons.edit_calendar_outlined,
                                                  size: 22,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                              const SizedBox(width: 20),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    DateFormat("dd-MM-yyyy").format(user!.lastUpdated),
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.grey[800],
                                                    ),
                                                  ),
                                                  Text(
                                                    "Date updated",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
