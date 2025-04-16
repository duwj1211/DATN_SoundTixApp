import 'package:flutter/material.dart';
import 'package:sound_tix_admin/api.dart';
import 'package:sound_tix_admin/components/image_picker.dart';
import 'package:sound_tix_admin/components/textfield_custom.dart';
import 'package:sound_tix_admin/entity/artist.dart';
import 'package:sound_tix_admin/entity/event.dart';
import 'package:sound_tix_admin/entity/event_type.dart';

class EditEventWidget extends StatefulWidget {
  final int? eventId;
  final String eventName;
  const EditEventWidget({super.key, this.eventId, required this.eventName});

  @override
  State<EditEventWidget> createState() => _EditEventWidgetState();
}

class _EditEventWidgetState extends State<EditEventWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  int? _selectedEventType = 0;
  Event? event;
  bool _isLoadingEdit = true;
  String? fileName;
  DateTime _selectedDate = DateTime.now();
  List<EventType> eventTypes = [];
  bool _isLoadingEventType = true;
  List<Artist> artists = [];
  bool _isLoadingArtist = true;
  List<Artist> selectedArtists = [];
  bool _isLoadingSelectedArtist = true;

  @override
  void initState() {
    getInforPage(widget.eventId, widget.eventName);
    super.initState();
  }

  getInforPage(eventId, eventName) async {
    await getDetailEvent(eventId);
    await getListEventTypes(eventId);
    await getListArtists();
    await getSelectedArtists(eventName);
    setInitValue();
  }

  getDetailEvent(eventId) async {
    var response = await httpGet("http://localhost:8080/event/$eventId");
    setState(() {
      event = Event.fromMap(response["body"]);
      _selectedDate = event!.dateTime;
      _isLoadingEdit = false;
    });
  }

  updateEvent() async {
    dynamic eventData = {
      "name": _nameController.text,
      "dateTime": _selectedDate.toIso8601String(),
      "location": _locationController.text,
      "description": _descriptionController.text,
      "path": fileName,
      "eventType": {"eventTypeId": _selectedEventType},
      "artists": [
        for (var aritst in selectedArtists) {"artistId": aritst.artistId}
      ]
    };

    var response = await httpPatch("http://localhost:8080/event/update/${event!.eventId}", eventData);

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

  getListEventTypes(eventId) async {
    var rawData = await httpPost("http://localhost:8080/event-type/search", {'eventId': eventId});

    setState(() {
      eventTypes = [];

      for (var element in rawData["body"]["content"]) {
        var eventType = EventType.fromMap(element);
        eventTypes.add(eventType);
      }
      _isLoadingEventType = false;
    });
    return 0;
  }

  getListArtists() async {
    var rawData = await httpPost("http://localhost:8080/artist/search", {});

    setState(() {
      artists = [];

      for (var element in rawData["body"]["content"]) {
        var artist = Artist.fromMap(element);
        artists.add(artist);
      }
      _isLoadingArtist = false;
    });
    return 0;
  }

  getSelectedArtists(eventName) async {
    var rawData = await httpPost("http://localhost:8080/artist/search", {'event': eventName});

    setState(() {
      selectedArtists = [];

      for (var element in rawData["body"]["content"]) {
        var artist = Artist.fromMap(element);
        selectedArtists.add(artist);
      }
      _isLoadingSelectedArtist = false;
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

  setInitValue() {
    setState(() {
      if (event != null) {
        _nameController.text = event!.name;
        _locationController.text = event!.location;
        _descriptionController.text = event!.description;
        _selectedEventType = eventTypes[0].eventTypeId;
        _dateController.text = formatDate(_selectedDate);
      }
    });
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
    return _isLoadingEdit
        ? const Center(child: CircularProgressIndicator())
        : AlertDialog(
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
                  child: Text("Edit event", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
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
                            nameAvatar: event!.path,
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
                                _isLoadingEventType
                                    ? const CircularProgressIndicator()
                                    : Expanded(
                                        flex: 4,
                                        child: Row(
                                          children: listEventTypes.map((option) {
                                            return Container(
                                              padding: const EdgeInsets.fromLTRB(2, 0, 20, 0),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: _selectedEventType == option["value"] ? option["color"] : Colors.grey, width: 2),
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
                                          decoration: BoxDecoration(
                                              border: Border.all(color: Colors.grey, width: 0.6), borderRadius: BorderRadius.circular(3)),
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
                                  child: _isLoadingArtist
                                      ? const CircularProgressIndicator()
                                      : _isLoadingSelectedArtist
                                          ? const CircularProgressIndicator()
                                          : Row(
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
                                        updateEvent();
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
                                      child: const Text("Update", style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500)),
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
