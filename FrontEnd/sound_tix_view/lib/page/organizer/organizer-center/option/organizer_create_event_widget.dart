import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sound_tix_view/api.dart';
import 'package:sound_tix_view/components/app_localizations.dart';
import 'package:sound_tix_view/components/custom_input.dart';
import 'package:sound_tix_view/components/image_picker.dart';
import 'package:sound_tix_view/entity/artist.dart';
import 'package:sound_tix_view/entity/event_type.dart';
import 'package:sound_tix_view/entity/ticket.dart';
import 'package:sound_tix_view/entity/user.dart';
import 'package:sound_tix_view/page/organizer/root-organizer/root_organizer_page.dart';

class CreateEventWidget extends StatefulWidget {
  final Function onSubmit;
  const CreateEventWidget({super.key, required this.onSubmit});

  @override
  State<CreateEventWidget> createState() => _CreateEventWidgetState();
}

class _CreateEventWidgetState extends State<CreateEventWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _ticketNameController = TextEditingController();
  final TextEditingController _detailInformationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  int? _selectedEventType;
  String? fileName;
  DateTime _selectedDate = DateTime.now();
  List<EventType> eventTypes = [];
  List<Artist> artists = [];
  List<Artist> selectedArtists = [];
  String currentTab = "Event information";
  int? priceTicket;
  int? quantityTicket;
  int? selectedEventId;
  User? user;
  String organizer = "";
  String organizerDescription = "";
  String organizerAvatar = "";
  List<Ticket> tickets = [];

  @override
  void initState() {
    getInitPage();
    super.initState();
  }

  getInitPage() async {
    await getDetailUser();
    await getListArtists();
    return 0;
  }

  getDetailUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (mounted) {
      var response = await httpGet(context, "http://localhost:8080/user/$userId");
      setState(() {
        user = User.fromMap(response["body"]);
        organizer = user!.fullName;
        organizerDescription = user!.description;
        organizerAvatar = user!.avatar;
      });
    }
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
      ],
      "organizer": organizer,
      "organizerDescription": organizerDescription,
      "organizerAvatar": organizerAvatar,
    };

    final response = await httpPost(context, "http://localhost:8080/event/add", body);
    return response;
  }

  addTicket() async {
    final body = {
      "name": _ticketNameController.text,
      "detailInformation": _detailInformationController.text,
      "price": priceTicket,
      "quantityAvailable": quantityTicket,
      "sold": 0,
      "event": {"eventId": selectedEventId},
      "qrCode": "qrCode_QrCode.png",
    };

    try {
      await httpPost(context, "http://localhost:8080/ticket/add", body);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tạo sự kiện thành công'),
            duration: Duration(seconds: 1),
          ),
        );
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

  searchTicketsAndDisplay(eventId) async {
    var rawData = await httpPost(context, "http://localhost:8080/ticket/search", {
      "event": {"eventId": eventId}
    });

    setState(() {
      tickets = [];

      for (var element in rawData["body"]["content"]) {
        var ticket = Ticket.fromMap(element);
        tickets.add(ticket);
      }
    });
    return 0;
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2026),
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

  void _toggleSelection(Artist artist) {
    setState(() {
      if (selectedArtists.contains(artist)) {
        selectedArtists.remove(artist);
      } else {
        selectedArtists.add(artist);
      }
    });
  }

  bool validateEventFields() {
    return fileName != null &&
        _nameController.text.isNotEmpty &&
        _selectedEventType != null &&
        _descriptionController.text.isNotEmpty &&
        _dateController.text.isNotEmpty &&
        selectedArtists.isNotEmpty;
  }

  bool validateTicketFields() {
    return _ticketNameController.text.isNotEmpty &&
        _detailInformationController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        _quantityController.text.isNotEmpty;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    _ticketNameController.dispose();
    _detailInformationController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RootOrganizerPage(
      currentPage: "Create event",
      child: tabControlWidget(),
    );
  }

  Column tabControlWidget() {
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
      {"name": "Mini Show", "value": 3, "color": const Color(0xFF2DC275)},
      {"name": "Festival", "value": 4, "color": Colors.purple},
      {"name": "EDM Show", "value": 5, "color": Colors.brown},
    ];
    List<Map<dynamic, dynamic>> listTabItem = [
      {
        "name": "Event information",
        "index": "1",
        "widget": Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    RectangleImportImageWidget(
                      nameAvatar: "avatar.jpg",
                      callbackFileName: (newFileName) {
                        setState(() {
                          fileName = newFileName;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text(AppLocalizations.of(context).translate("Name"), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    ),
                    InputCustom(controller: _nameController, obscureText: false),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text(AppLocalizations.of(context).translate("Event type"),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    ),
                    Wrap(
                      runSpacing: 10,
                      spacing: 10,
                      children: listEventTypes.map((option) {
                        return Container(
                          height: 32,
                          width: 110,
                          decoration: BoxDecoration(
                              border: Border.all(color: _selectedEventType == option["value"] ? option["color"] : Colors.grey, width: 2),
                              borderRadius: BorderRadius.circular(99)),
                          child: Center(
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
                                Text(
                                  option["name"],
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: _selectedEventType == option["value"] ? option["color"] : Colors.black,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child:
                          Text(AppLocalizations.of(context).translate("Location"), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    ),
                    Row(
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
                            decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 0.6), borderRadius: BorderRadius.circular(5)),
                            child: Row(
                              children: [
                                Text(
                                  _locationController.text.isEmpty ? "Select city" : _locationController.text,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_drop_down, size: 22),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text(AppLocalizations.of(context).translate("Description"),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    ),
                    InputCustom(controller: _descriptionController, obscureText: false, maxLines: 3),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text(AppLocalizations.of(context).translate("Date time"),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    ),
                    InkWell(
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
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child:
                          Text(AppLocalizations.of(context).translate("Artist"), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    ),
                    Wrap(
                      runSpacing: 10,
                      spacing: 10,
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
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  border: selectedArtists.contains(artist) ? Border.all(color: const Color(0xFF2DC275), width: 3) : null,
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
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 80,
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
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF2DC275)),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text("Cancel", style: TextStyle(fontSize: 14, color: Color(0xFF2DC275), fontWeight: FontWeight.w500)),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: 80,
                  child: InkWell(
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: validateEventFields()
                        ? () async {
                            setState(() {
                              currentTab = "Ticket";
                            });
                            var newEvent = await addEvent();
                            selectedEventId = newEvent["body"]["eventId"];
                            await searchTicketsAndDisplay(selectedEventId);
                          }
                        : null,
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: validateEventFields() ? const Color(0xFF2DC275) : Colors.grey.shade400,
                        ),
                        borderRadius: BorderRadius.circular(5),
                        color: validateEventFields() ? const Color(0xFF2DC275) : Colors.grey.shade400,
                      ),
                      child: const Text("Next", style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      },
      {
        "name": "Ticket",
        "index": "2",
        "widget": Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (tickets.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(AppLocalizations.of(context).translate("Ticket of event"),
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                            ),
                            for (Ticket ticket in tickets)
                              Padding(
                                padding: EdgeInsets.only(bottom: tickets.last != ticket ? 8 : 0),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade300,
                                        blurRadius: 1,
                                        offset: const Offset(0, 1),
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(ticket.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                                      Text("${ticket.price}.000 đ",
                                          style: const TextStyle(color: Color(0xFF2DC275), fontSize: 14, fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text(AppLocalizations.of(context).translate("Ticket name"),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    ),
                    InputCustom(controller: _ticketNameController, obscureText: false),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text(AppLocalizations.of(context).translate("Detail information"),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    ),
                    InputCustom(controller: _detailInformationController, obscureText: false, maxLines: 3),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text(AppLocalizations.of(context).translate("Price"), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    ),
                    TextField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          priceTicket = int.tryParse(value);
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 235, 235, 235),
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
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child:
                          Text(AppLocalizations.of(context).translate("Quantity"), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    ),
                    TextField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          quantityTicket = int.tryParse(value);
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 235, 235, 235),
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
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          child: InkWell(
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: validateTicketFields()
                                ? () async {
                                    await addTicket();
                                    _ticketNameController.clear();
                                    _detailInformationController.clear();
                                    _priceController.clear();
                                    _quantityController.clear();
                                    searchTicketsAndDisplay(selectedEventId);
                                  }
                                : null,
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: validateTicketFields() ? const Color(0xFF2DC275) : Colors.grey.shade400,
                                ),
                                borderRadius: BorderRadius.circular(5),
                                color: validateTicketFields() ? const Color(0xFF2DC275) : Colors.grey.shade400,
                              ),
                              child: const Text("Add", style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 80,
                  child: InkWell(
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      setState(() {
                        currentTab = "Event information";
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF2DC275)),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text("Back", style: TextStyle(fontSize: 14, color: Color(0xFF2DC275), fontWeight: FontWeight.w500)),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: 80,
                  child: InkWell(
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: tickets.isNotEmpty
                        ? () {
                            Navigator.pop(context);
                            widget.onSubmit();
                          }
                        : null,
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: tickets.isNotEmpty ? const Color(0xFF2DC275) : Colors.grey.shade400,
                        ),
                        borderRadius: BorderRadius.circular(5),
                        color: tickets.isNotEmpty ? const Color(0xFF2DC275) : Colors.grey.shade400,
                      ),
                      child: const Text("Submit", style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      },
    ];
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xFFE2E8F0)),
            ),
          ),
          child: Row(
            children: [
              for (var tab in listTabItem)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: InkWell(
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        setState(() {
                          currentTab = tab["name"];
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: tab["name"] == currentTab ? const Color(0xFF2DC275) : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(8, 2.5, 8, 2.5),
                              decoration: BoxDecoration(
                                color: tab["name"] == currentTab ? const Color(0xFF2DC275) : Colors.transparent,
                                border: Border.all(
                                  color: tab["name"] == currentTab ? const Color(0xFF2DC275) : Colors.grey.shade700,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                tab["index"],
                                style: TextStyle(
                                  color: tab["name"] == currentTab ? Colors.white : Colors.grey.shade700,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              tab["name"],
                              style: TextStyle(
                                color: tab["name"] == currentTab ? const Color(0xFF2DC275) : Colors.grey.shade700,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        for (var tab in listTabItem)
          if (currentTab == tab["name"])
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: tab["widget"],
              ),
            ),
      ],
    );
  }
}
