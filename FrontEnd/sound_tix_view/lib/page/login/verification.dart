import 'package:diacritic/diacritic.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:image/image.dart' as img;
import 'dart:io';
import 'package:sound_tix_view/api.dart';
import 'package:sound_tix_view/components/app_localizations.dart';
import 'package:sound_tix_view/model/model.dart';

class Otp extends StatelessWidget {
  final TextEditingController otpController;
  final TextStyle style;
  const Otp({super.key, required this.otpController, required this.style});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: TextFormField(
        controller: otpController,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: style,
        inputFormatters: [LengthLimitingTextInputFormatter(1), FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty) {
            FocusScope.of(context).previousFocus();
          }
        },
        decoration: const InputDecoration(
          hintText: (""),
        ),
        onSaved: (value) {},
      ),
    );
  }
}

class OtpScreen extends StatefulWidget {
  final EmailOTP myauth;
  final String type;
  final dynamic registerBody;
  final String? email;
  final int? userId;
  const OtpScreen({super.key, required this.myauth, required this.type, this.registerBody, this.email, this.userId});
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otp1Controller = TextEditingController();
  TextEditingController otp2Controller = TextEditingController();
  TextEditingController otp3Controller = TextEditingController();
  TextEditingController otp4Controller = TextEditingController();
  TextEditingController otp5Controller = TextEditingController();
  TextEditingController otp6Controller = TextEditingController();

  registerAccount(registerBody) async {
    try {
      final response = await httpPost("http://localhost:8080/user/add", registerBody);
      if (response.containsKey("body") && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).translate('Account registration successful')),
            duration: const Duration(seconds: 1),
          ),
        );
        generateAndSaveQRCode(registerBody["fullName"]);
        context.go('/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).translate('Registration failed')),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      // print(e);
    }
  }

  deleteAccount(userId) async {
    var response = await httpDelete("http://localhost:8080/user/delete/$userId");
    if (response['statusCode'] == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).translate('Account deleted successfully')),
          duration: const Duration(seconds: 1),
        ),
      );
      context.go('/delete-account-successful');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).translate('Account deletion failed')),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  lockAccount(userId) async {
    var response = await httpPatch("http://localhost:8080/user/update/$userId", {"status": "Inactive"});

    if (response['statusCode'] == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).translate('Account locked successfully')),
          duration: const Duration(seconds: 1),
        ),
      );
      context.go('/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).translate('Account lock failed')),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  Future<void> generateAndSaveQRCode(fullName) async {
    const qrData = 'https://www.facebook.com/duwj1211';
    final fileName = 'qrCode_${convertFullName(fullName)}.png';
    const outputPath = 'C:/Project/FrontEnd/sound_tix_view/images';

    try {
      // Tạo mã QR
      final qrPainter = QrPainter(
        data: qrData,
        version: QrVersions.auto,
        gapless: true,
        color: Colors.black,
        emptyColor: Colors.white,
      );

      // Kết xuất mã QR ra byte buffer
      final picData = await qrPainter.toImageData(300); // 300 là kích thước ảnh
      if (picData == null) throw Exception('Không tạo được dữ liệu ảnh');

      // Chuyển dữ liệu sang định dạng hình ảnh PNG
      final img.Image image = img.decodeImage(picData.buffer.asUint8List())!;
      final pngBytes = img.encodePng(image);

      // Lưu ảnh vào thư mục
      final dir = Directory(outputPath);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(pngBytes);

      debugPrint('Ảnh QR Code đã được lưu tại: ${file.path}');
    } catch (e) {
      debugPrint('Lỗi khi tạo ảnh QR Code: $e');
    }
  }

  String convertFullName(input) {
    return removeDiacritics(input).replaceAll(' ', '');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChangeThemeModel>(builder: (context, changeThemeModel, child) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.info),
            ),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 10),
            const Icon(Icons.verified_user_outlined, size: 60, color: Colors.green),
            const SizedBox(height: 30),
            Text(
              AppLocalizations.of(context).translate("Enter OTP code"),
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500, color: changeThemeModel.isDark ? Colors.white : Colors.black),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Otp(otpController: otp1Controller, style: TextStyle(color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                Otp(otpController: otp2Controller, style: TextStyle(color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                Otp(otpController: otp3Controller, style: TextStyle(color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                Otp(otpController: otp4Controller, style: TextStyle(color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                Otp(otpController: otp5Controller, style: TextStyle(color: changeThemeModel.isDark ? Colors.white : Colors.black)),
                Otp(otpController: otp6Controller, style: TextStyle(color: changeThemeModel.isDark ? Colors.white : Colors.black)),
              ],
            ),
            const SizedBox(height: 35),
            InkWell(
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () async {
                if (await EmailOTP.verifyOTP(
                        otp: otp1Controller.text +
                            otp2Controller.text +
                            otp3Controller.text +
                            otp4Controller.text +
                            otp5Controller.text +
                            otp6Controller.text) ==
                    true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context).translate("OTP is verified")),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                  Future.delayed(const Duration(seconds: 3), () {
                    if (widget.type == "forgotPassword") {
                      context.go(
                        '/reset-password/${widget.email}',
                        extra: {"oldUrl": GoRouter.of(context).routerDelegate.currentConfiguration.matches.last.matchedLocation},
                      );
                    } else if (widget.type == "deleteAccount") {
                      deleteAccount(widget.userId);
                    } else if (widget.type == "lockAccount") {
                      lockAccount(widget.userId);
                    } else {
                      registerAccount(widget.registerBody);
                    }
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context).translate("Invalid OTP")),
                      duration: const Duration(seconds: 1),
                    ),
                  );
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
                child: Text(AppLocalizations.of(context).translate("CONFIRM"), style: const TextStyle(fontSize: 16, color: Colors.white)),
              ),
            )
          ],
        ),
      );
    });
  }
}
