import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ImportImageWidget extends StatefulWidget {
  final String nameAvatar;
  final Function callbackFileName;
  final bool? isSmall;
  const ImportImageWidget({super.key, required this.nameAvatar, required this.callbackFileName, this.isSmall = false});

  @override
  State<ImportImageWidget> createState() => _ImportImageWidgetState();
}

class _ImportImageWidgetState extends State<ImportImageWidget> {
  Uint8List? image;
  String? fileName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Stack(
            children: [
              (image != null)
                  ? ClipOval(
                      child: Image.memory(
                        image!,
                        width: widget.isSmall! ? 60 : 150,
                        height: widget.isSmall! ? 60 : 150,
                        fit: BoxFit.cover,
                      ),
                    )
                  : ClipOval(
                      child: Image.asset(
                        "images/${widget.nameAvatar}",
                        height: widget.isSmall! ? 60 : 150,
                        width: widget.isSmall! ? 60 : 150,
                        fit: BoxFit.cover,
                      ),
                    ),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    setState(() {
                      image = null;
                      fileName = null;
                    });
                    showImagePickerOption(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(widget.isSmall! ? 5 : 10),
                    decoration: BoxDecoration(color: Colors.grey[500], borderRadius: BorderRadius.circular(99)),
                    child: Icon(
                      Icons.camera_alt,
                      size: widget.isSmall! ? 12 : 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void showImagePickerOption(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.grey[200],
      context: context,
      builder: (builder) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 10,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _pickImageFromGallery();
                        },
                        child: const SizedBox(
                          child: Column(
                            children: [
                              Icon(
                                Icons.image,
                                size: 50,
                              ),
                              Text("Thư viện"),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _pickImageFromCamera();
                        },
                        child: const SizedBox(
                          child: Column(
                            children: [
                              Icon(
                                Icons.camera_alt,
                                size: 50,
                              ),
                              Text("Camera"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? returnImage = await picker.pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;
    _processImage(returnImage);
    Navigator.pop(context);
  }

  Future<void> _pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? returnImage = await picker.pickImage(source: ImageSource.camera);
    if (returnImage == null) return;
    _processImage(returnImage);
    Navigator.pop(context);
  }

  void _processImage(XFile imageFile) async {
    setState(() {
      image = File(imageFile.path).readAsBytesSync();
    });

    await _saveImageToLocalDirectory(imageFile);
  }

  Future<void> _saveImageToLocalDirectory(XFile imageFile) async {
    try {
      const folderPath = 'C:/Project/FrontEnd/sound_tix_admin/images';
      final folder = Directory(folderPath);
      if (!folder.existsSync()) {
        folder.createSync(recursive: true);
      }

      DateTime now = DateTime.now();
      DateFormat formatter = DateFormat('HHmmssddMMyyyy');
      String formattedDate = formatter.format(now);

      String newFileName = 'image_$formattedDate.png';
      final newPath = '$folderPath/$newFileName';

      await File(imageFile.path).copy(newPath);

      setState(() {
        fileName = newFileName;
        widget.callbackFileName(fileName);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tải ảnh lên thất bại.'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }
}
