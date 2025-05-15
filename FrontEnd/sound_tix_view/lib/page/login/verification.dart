import 'package:diacritic/diacritic.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:sound_tix_view/api.dart';
import 'package:sound_tix_view/components/app_localizations.dart';
import 'package:sound_tix_view/model/model.dart';
import 'package:sound_tix_view/page/login/reset_password.dart';

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
  const OtpScreen({super.key, required this.myauth, required this.type, this.registerBody});
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
  int? userId;

  @override
  void initState() {
    super.initState();
    loadUserId();
  }

  Future<void> loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId');
    });
  }

  registerAccount(body) async {
    try {
      await httpPost(context, "http://localhost:8080/api/auth/register", body);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đăng ký thành công.'),
            duration: Duration(seconds: 1),
          ),
        );

        generateAndSaveQRCode(body["qrCode"]);
        context.go('/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã xảy ra lỗi, vui lòng thử lại.'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    }
  }

  deleteAccount() async {
    try {
      await httpDelete(context, "http://localhost:8080/user/delete/$userId");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).translate('Xóa tài khoản thành công')),
            duration: const Duration(seconds: 1),
          ),
        );
        context.go('/delete-account-successful');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString().contains('Phiên đăng nhập')
                  ? AppLocalizations.of(context).translate('Session expired. Please log in again.')
                  : AppLocalizations.of(context).translate('Đã xảy ra lỗi, vui lòng thử lại'),
            ),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    }
  }

  lockAccount() async {
    try {
      await httpPatch(context, "http://localhost:8080/user/update/$userId", {"status": "Inactive"});

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).translate('Khóa tài khoản thành công')),
            duration: const Duration(seconds: 1),
          ),
        );
        context.go('/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString().contains('Phiên đăng nhập')
                  ? AppLocalizations.of(context).translate('Session expired. Please log in again.')
                  : AppLocalizations.of(context).translate('Đã xảy ra lỗi, vui lòng thử lại'),
            ),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    }
  }

  Future<void> generateAndSaveQRCode(qrCode) async {
    const qrData = 'https://www.facebook.com/duwj1211';
    final fileName = qrCode;
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
                    true && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context).translate("OTP is verified")),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                  Future.delayed(const Duration(seconds: 3), () {
                    if (widget.type == "forgotPassword") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ResetPage(),
                        ),
                      );
                    } else if (widget.type == "deleteAccount") {
                      deleteAccount();
                    } else if (widget.type == "lockAccount") {
                      lockAccount();
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
