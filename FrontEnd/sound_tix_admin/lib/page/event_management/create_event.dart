import 'package:flutter/material.dart';
import 'package:sound_tix_admin/api.dart';
import 'package:sound_tix_admin/components/image_picker.dart';
import 'package:sound_tix_admin/components/textfield_custom.dart';
import 'package:sound_tix_admin/entity/artist.dart';
import 'package:sound_tix_admin/entity/event_type.dart';

class CreateEventWidget extends StatefulWidget {
  const CreateEventWidget({super.key});

  @override
  State<CreateEventWidget> createState() => _CreateEventWidgetState();
}

class _CreateEventWidgetState extends State<CreateEventWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  int? _selectedEventType;
  String? fileName;
  DateTime _selectedDate = DateTime.now();
  List<EventType> eventTypes = [];
  List<Artist> artists = [];
  List<Artist> selectedArtists = [];

  @override
  void initState() {
    getListArtists();
    super.initState();
  }

  addEvent() async {
    final body = {
      "name": _nameController.text,
      "dateTime": _selectedDate.toIso8601String(),
      "location": _locationController.text,
      "description": _descriptionController.text,
      "path": fileName,
      "eventType": {"eventTypeId": _selectedEventType ?? 0},
      "artists": [
        for (var aritst in selectedArtists) {"artistId": aritst.artistId}
      ]
    };

    try {
      await httpPost(context, "http://localhost:8080/event/add", body);
      if ( mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thêm sự kiện thành công'),
            duration: Duration(seconds: 1),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
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

  getListArtists() async {
    var rawData = await httpPost(context, "http://localhost:8080/artist/search", {});

    setState(() {
      artists = [];

      for (var element in rawData["body"]["content"]) {
        var artist = Artist.fromMap(element);
        artists.add(artist);
      }
    });
    return 0;
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = formatDate(picked);
      });
    }
  }

  String formatDate(DateTime date) {
    return "${date.day}-${date.month}-${date.year}";
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _toggleSelection(Artist artist) {
    setState(() {
      if (selectedArtists.contains(artist)) {
        selectedArtists.remove(artist);
      } else {
        selectedArtists.add(artist);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> vietnamProvincesAndCities = [
      'An Giang',
      'Bà Rịa - Vũng Tàu',
      'Bạc Liêu',
      'Bắc Kạn',
      'Bắc Giang',
      'Bắc Ninh',
      'Bến Tre',
      'Bình Dương',
      'Bình Định',
      'Bình Phước',
      'Bình Thuận',
      'Cà Mau',
      'Cao Bằng',
      'Cần Thơ',
      'Đà Nẵng',
      'Đắk Lắk',
      'Đắk Nông',
      'Điện Biên',
      'Đồng Nai',
      'Đồng Tháp',
      'Gia Lai',
      'Hà Giang',
      'Hà Nam',
      'Hà Nội',
      'Hà Tĩnh',
      'Hải Dương',
      'Hải Phòng',
      'Hậu Giang',
      'Hòa Bình',
      'Hưng Yên',
      'Khánh Hòa',
      'Kiên Giang',
      'Kon Tum',
      'Lai Châu',
      'Lạng Sơn',
      'Lào Cai',
      'Lâm Đồng',
      'Long An',
      'Nam Định',
      'Nghệ An',
      'Ninh Bình',
      'Ninh Thuận',
      'Phú Thọ',
      'Phú Yên',
      'Quảng Bình',
      'Quảng Nam',
      'Quảng Ngãi',
      'Quảng Ninh',
      'Quảng Trị',
      'Sóc Trăng',
      'Sơn La',
      'Tây Ninh',
      'Thái Bình',
      'Thái Nguyên',
      'Thanh Hóa',
      'Thừa Thiên Huế',
      'Tiền Giang',
      'TP. Hồ Chí Minh',
      'Trà Vinh',
      'Tuyên Quang',
      'Vĩnh Long',
      'Vĩnh Phúc',
      'Yên Bái'
    ];
    List listEventTypes = [
      {"name": "Concert", "value": 1, "color": Colors.green},
      {"name": "Live Show", "value": 2, "color": Colors.orange},
      {"name": "Mini Show", "value": 3, "color": Colors.blue},
      {"name": "Festival", "value": 4, "color": Colors.purple},
      {"name": "EDM Show", "value": 5, "color": Colors.brown},
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
            child: Text("Add event", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
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
                          const Expanded(child: Text("Event name", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                          Expanded(
                            flex: 4,
                            child: InputCustom(controller: _nameController, obscureText: false),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Expanded(child: Text("Event type", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                          Expanded(
                            flex: 4,
                            child: Row(
                              children: listEventTypes.map((option) {
                                return Container(
                                  padding: const EdgeInsets.fromLTRB(2, 0, 20, 0),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: _selectedEventType == option["value"] ? option["color"] : Colors.grey, width: 2),
                                      borderRadius: BorderRadius.circular(99)),
                                  margin: const EdgeInsets.only(right: 30),
                                  child: Row(
                                    children: [
                                      Radio<int>(
                                        activeColor: option["color"],
                                        value: option["value"],
                                        groupValue: _selectedEventType,
                                        onChanged: (int? newValue) {
                                          setState(() {
                                            _selectedEventType = newValue!;
                                          });
                                        },
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        option["name"],
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: _selectedEventType == option["value"] ? option["color"] : Colors.black,
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
                          const Expanded(child: Text("Location", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                          Expanded(
                            flex: 4,
                            child: Row(
                              children: [
                                PopupMenuButton<String>(
                                  tooltip: "",
                                  onSelected: (String city) {
                                    setState(() {
                                      _locationController.text = city;
                                    });
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return vietnamProvincesAndCities.map((String city) {
                                      return PopupMenuItem<String>(
                                        value: city,
                                        child: Text(city),
                                      );
                                    }).toList();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.fromLTRB(15, 5, 8, 5),
                                    decoration:
                                        BoxDecoration(border: Border.all(color: Colors.grey, width: 0.6), borderRadius: BorderRadius.circular(3)),
                                    child: Row(
                                      children: [
                                        Text(
                                          _locationController.text.isEmpty ? "Select city" : _locationController.text,
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
                          const Expanded(child: Text("Description", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                          Expanded(flex: 4, child: InputCustom(controller: _descriptionController, obscureText: false, maxLines: 5)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Expanded(child: Text("Date", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                          Expanded(
                            flex: 4,
                            child: InkWell(
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onTap: () => _selectDate(context),
                              child: AbsorbPointer(
                                child: InputCustom(
                                  controller: _dateController,
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
                          const Expanded(child: Text("Artists", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                          Expanded(
                            flex: 4,
                            child: Row(
                              children: [
                                for (var artist in artists)
                                  InkWell(
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      setState(() {
                                        _toggleSelection(artist);
                                      });
                                    },
                                    child: Tooltip(
                                      message: artist.name,
                                      child: Container(
                                        width: 38,
                                        height: 38,
                                        margin: const EdgeInsets.only(right: 15),
                                        decoration: BoxDecoration(
                                          border: selectedArtists.contains(artist) ? Border.all(color: Colors.blue, width: 3) : null,
                                          borderRadius: BorderRadius.circular(99),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(99),
                                          child: Image.asset("images/${artist.avatar}", fit: BoxFit.cover),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
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
                              onTap: () {
                                setState(() {
                                  addEvent();
                                });
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
