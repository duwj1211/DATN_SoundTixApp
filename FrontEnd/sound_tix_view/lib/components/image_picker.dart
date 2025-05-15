import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sound_tix_view/components/app_localizations.dart';

class ImportImageWidget extends StatefulWidget {
  final String nameAvatar;
  final Function callbackFileName;
  const ImportImageWidget({super.key, required this.nameAvatar, required this.callbackFileName});

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
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    )
                  : ClipOval(
                      child: Image.asset(
                        "images/${widget.nameAvatar}",
                        height: 150,
                        width: 150,
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
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.grey[500], borderRadius: BorderRadius.circular(99)),
                    child: const Icon(Icons.camera_alt),
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
                        child: SizedBox(
                          child: Column(
                            children: [
                              const Icon(
                                Icons.image,
                                size: 50,
                              ),
                              Text(AppLocalizations.of(context).translate("Library"))
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          // _pickImageFromCamera();
                        },
                        child: SizedBox(
                          child: Column(
                            children: [
                              const Icon(
                                Icons.camera_alt,
                                size: 50,
                              ),
                              Text(AppLocalizations.of(context).translate("Camera"))
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

  // Future<void> _pickImageFromGallery() async {
  //   final ImagePicker picker = ImagePicker();
  //   final XFile? returnImage = await picker.pickImage(source: ImageSource.gallery);
  //   if (returnImage == null) return;
  //   _processImage(returnImage);
  //   Navigator.pop(context);
  // }

  Future<void> _pickImageFromGallery() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      _processImage(result.files.single.bytes!, result.files.single.path);
      Navigator.pop(context);
    }
  }

  // Future<void> _pickImageFromCamera() async {
  //   final ImagePicker picker = ImagePicker();
  //   final XFile? returnImage = await picker.pickImage(source: ImageSource.camera);
  //   if (returnImage == null) return;
  //   _processImage(returnImage);
  //   Navigator.pop(context);
  // }

  // void _processImage(XFile imageFile) async {
  //   setState(() {
  //     image = File(imageFile.path).readAsBytesSync();
  //   });

  //   await _saveImageToLocalDirectory(imageFile);
  // }

  void _processImage(Uint8List imageBytes, String? path) async {
    setState(() {
      image = imageBytes;
    });

    if (path != null) {
      await _saveImageToLocalDirectory(File(path));
    }
  }

  Future<void> _saveImageToLocalDirectory(File imageFile) async {
    try {
      const folderPath = 'C:/Project/FrontEnd/sound_tix_view/images';
      final folder = Directory(folderPath);
      if (!folder.existsSync()) {
        folder.createSync(recursive: true);
      }

      String newFileName = 'image_${DateTime.now().toIso8601String().replaceAll(":", "-")}.png';
      final newPath = '$folderPath/$newFileName';

      await File(imageFile.path).copy(newPath);

      setState(() {
        fileName = newFileName;
        widget.callbackFileName(fileName);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).translate("Image upload failed")),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    }
  }
}

class RectangleImportImageWidget extends StatefulWidget {
  final String nameAvatar;
  final Function callbackFileName;
  const RectangleImportImageWidget({super.key, required this.nameAvatar, required this.callbackFileName});

  @override
  State<RectangleImportImageWidget> createState() => _RectangleImportImageWidgetState();
}

class _RectangleImportImageWidgetState extends State<RectangleImportImageWidget> {
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
                  ? Image.memory(
                      image!,
                      width: 250,
                      height: 150,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      "images/${widget.nameAvatar}",
                      height: 150,
                      width: 250,
                      fit: BoxFit.cover,
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
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.grey[500], borderRadius: BorderRadius.circular(99)),
                    child: const Icon(Icons.camera_alt),
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
                        child: SizedBox(
                          child: Column(
                            children: [
                              const Icon(
                                Icons.image,
                                size: 50,
                              ),
                              Text(AppLocalizations.of(context).translate("Library"))
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          // _pickImageFromCamera();
                        },
                        child: SizedBox(
                          child: Column(
                            children: [
                              const Icon(
                                Icons.camera_alt,
                                size: 50,
                              ),
                              Text(AppLocalizations.of(context).translate("Camera"))
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

  // Future<void> _pickImageFromGallery() async {
  //   final ImagePicker picker = ImagePicker();
  //   final XFile? returnImage = await picker.pickImage(source: ImageSource.gallery);
  //   if (returnImage == null) return;
  //   _processImage(returnImage);
  //   Navigator.pop(context);
  // }

  Future<void> _pickImageFromGallery() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      _processImage(result.files.single.bytes!, result.files.single.path);
      Navigator.pop(context);
    }
  }

  // Future<void> _pickImageFromCamera() async {
  //   final ImagePicker picker = ImagePicker();
  //   final XFile? returnImage = await picker.pickImage(source: ImageSource.camera);
  //   if (returnImage == null) return;
  //   _processImage(returnImage);
  //   Navigator.pop(context);
  // }

  // void _processImage(XFile imageFile) async {
  //   setState(() {
  //     image = File(imageFile.path).readAsBytesSync();
  //   });

  //   await _saveImageToLocalDirectory(imageFile);
  // }

  void _processImage(Uint8List imageBytes, String? path) async {
    setState(() {
      image = imageBytes;
    });

    if (path != null) {
      await _saveImageToLocalDirectory(File(path));
    }
  }

  Future<void> _saveImageToLocalDirectory(File imageFile) async {
    try {
      const folderPath = 'C:/Project/FrontEnd/sound_tix_view/images';
      final folder = Directory(folderPath);
      if (!folder.existsSync()) {
        folder.createSync(recursive: true);
      }

      String newFileName = 'image_${DateTime.now().toIso8601String().replaceAll(":", "-")}.png';
      final newPath = '$folderPath/$newFileName';

      await File(imageFile.path).copy(newPath);

      setState(() {
        fileName = newFileName;
        widget.callbackFileName(fileName);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).translate("Image upload failed")),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    }
  }
}
