import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sound_tix_admin/api.dart';
import 'package:sound_tix_admin/components/image_picker.dart';
import 'package:sound_tix_admin/components/textfield_custom.dart';
import 'package:sound_tix_admin/entity/artist.dart';

class EditArtistWidget extends StatefulWidget {
  final int? artistId;
  const EditArtistWidget({super.key, this.artistId});

  @override
  State<EditArtistWidget> createState() => _EditArtistWidgetState();
}

class _EditArtistWidgetState extends State<EditArtistWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _birthDayController = TextEditingController();
  final TextEditingController _debutController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();
  Artist? artist;
  bool _isLoadingEdit = true;
  String? fileName;
  DateTime? _selectedBirthDay;
  DateTime? _selectedDebut;
  String _selectedGenre = "Rap";
  String _selectedSex = 'Nam';

  @override
  void initState() {
    getInforPage(widget.artistId);
    super.initState();
  }

  getInforPage(artistId) {
    getDetailArtist(artistId);
  }

  getDetailArtist(artistId) async {
    var response = await httpGet("http://localhost:8080/artist/$artistId");
    setState(() {
      artist = Artist.fromMap(response["body"]);
      _selectedBirthDay = artist!.birthDay;
      _selectedDebut = artist!.debutDate;
      setInitValue();
      _isLoadingEdit = false;
    });
  }

  updateEvent() async {
    dynamic eventData = {
      "name": _nameController.text,
      "birthDay": DateFormat('yyyy-MM-dd').format(_selectedBirthDay!),
      "bio": _descriptionController.text,
      "avatar": fileName,
      "genre": _selectedGenre,
      'sex': _selectedSex,
      "nationality": _nationalityController.text,
      "debutDate": DateFormat('yyyy-MM-dd').format(_selectedDebut!),
    };

    var response = await httpPatch("http://localhost:8080/artist/update/${artist!.artistId}", eventData);

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

  Future<void> _selectDate(BuildContext context, selectedDate, dateController) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text = formatDate(picked);
      });
    }
  }

  String formatDate(DateTime date) {
    return "${date.day}-${date.month}-${date.year}";
  }

  setInitValue() {
    setState(() {
      if (artist != null) {
        _nameController.text = artist!.name;
        _descriptionController.text = artist!.bio;
        _nationalityController.text = artist!.nationality;
        if (_selectedBirthDay != null) {
          _birthDayController.text = formatDate(_selectedBirthDay!);
        }
        if (_selectedDebut != null) {
          _debutController.text = formatDate(_selectedDebut!);
        }
        _selectedSex = artist!.sex;
        _selectedGenre = artist!.genre;
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _birthDayController.dispose();
    _debutController.dispose();
    _nationalityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> listNationalities = ['Việt Nam', 'Mỹ', 'Anh', 'Pháp', 'Thái Lan', 'Trung Quốc', 'Đức', 'Thụy Sĩ'];
    List listGenres = ['Ballad', 'Rap', 'R&B', 'Pop', 'Indie', 'Opera', 'Rock'];
    List listSex = ["Nam", "Nữ"];
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      scrollable: true,
      titlePadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.all(0),
      content: _isLoadingEdit
          ? const CircularProgressIndicator()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(30, 20, 30, 10),
                  child: Text("Add artist", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
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
                            nameAvatar: artist!.avatar,
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
                                const Expanded(child: Text("Artist name", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                                Expanded(
                                  flex: 4,
                                  child: InputCustom(controller: _nameController, obscureText: false),
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
                                              value: option,
                                              groupValue: _selectedSex,
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  _selectedSex = newValue!;
                                                });
                                              },
                                            ),
                                            const SizedBox(width: 10),
                                            Text(option),
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
                                const Expanded(child: Text("Nationality", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                                Expanded(
                                  flex: 4,
                                  child: Row(
                                    children: [
                                      PopupMenuButton<String>(
                                        tooltip: "",
                                        onSelected: (String city) {
                                          setState(() {
                                            _nationalityController.text = city;
                                          });
                                        },
                                        itemBuilder: (BuildContext context) {
                                          return listNationalities.map((String city) {
                                            return PopupMenuItem<String>(
                                              value: city,
                                              child: Text(city),
                                            );
                                          }).toList();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.fromLTRB(15, 5, 8, 5),
                                          decoration: BoxDecoration(
                                              border: Border.all(color: Colors.grey, width: 0.6), borderRadius: BorderRadius.circular(3)),
                                          child: Row(
                                            children: [
                                              Text(
                                                _nationalityController.text.isEmpty ? "Select country" : _nationalityController.text,
                                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                              ),
                                              const SizedBox(width: 8),
                                              const Icon(Icons.arrow_drop_down, size: 22),
                                            ],
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
                                const Expanded(child: Text("Genre", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                                Expanded(
                                  flex: 4,
                                  child: Row(
                                    children: listGenres.map((option) {
                                      return Container(
                                        padding: const EdgeInsets.fromLTRB(2, 0, 20, 0),
                                        decoration: BoxDecoration(
                                            border: Border.all(color: _selectedGenre == option ? Colors.blue : Colors.grey, width: 2),
                                            borderRadius: BorderRadius.circular(99)),
                                        margin: const EdgeInsets.only(right: 15),
                                        child: Row(
                                          children: [
                                            Radio<String>(
                                              activeColor: Colors.blue,
                                              value: option,
                                              groupValue: _selectedGenre,
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  _selectedGenre = newValue!;
                                                });
                                              },
                                            ),
                                            const SizedBox(width: 3),
                                            Text(
                                              option,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: _selectedGenre == option ? Colors.blue : Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            ),
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
                                    onTap: () => _selectDate(context, _selectedBirthDay, _birthDayController),
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
                                const Expanded(child: Text("Debut", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                                Expanded(
                                  flex: 4,
                                  child: InkWell(
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    onTap: () => _selectDate(context, _selectedDebut, _debutController),
                                    child: AbsorbPointer(
                                      child: InputCustom(
                                        controller: _debutController,
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
                                const Expanded(child: Text("Description", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                                Expanded(flex: 4, child: InputCustom(controller: _descriptionController, obscureText: false, maxLines: 5)),
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
                                    onTap: () {},
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
