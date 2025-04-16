import 'package:flutter/material.dart';
import 'package:sound_tix_admin/api.dart';
import 'package:sound_tix_admin/entity/event_type.dart';

class EventTypeItemWidget extends StatefulWidget {
  final int? eventId;
  const EventTypeItemWidget({super.key, this.eventId});

  @override
  State<EventTypeItemWidget> createState() => _EventTypeItemWidgetState();
}

class _EventTypeItemWidgetState extends State<EventTypeItemWidget> {
  int currentPage = 0;
  int totalPages = 0;
  List<EventType> eventTypes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getListEventTypes(widget.eventId);
  }

  getListEventTypes(eventId) async {
    var rawData = await httpPost("http://localhost:8080/event-type/search", {'eventId': eventId});

    setState(() {
      eventTypes = [];

      for (var element in rawData["body"]["content"]) {
        var eventType = EventType.fromMap(element);
        eventTypes.add(eventType);
      }
      _isLoading = false;
    });
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    if (eventTypes.isNotEmpty) {
      return _isLoading
          ? const CircularProgressIndicator()
          : Row(
              children: [
                for (var eventType in eventTypes)
                  Container(
                    padding: const EdgeInsets.fromLTRB(6, 1, 6, 1),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: eventType.type == "Concert"
                                ? Colors.green
                                : eventType.type == "Live Show"
                                    ? Colors.orange
                                    : eventType.type == "Mini Show"
                                        ? Colors.blue
                                        : eventType.type == "Festival"
                                            ? Colors.purple
                                            : Colors.brown),
                        borderRadius: BorderRadius.circular(15)),
                    child: Text(
                      eventType.type,
                      style: TextStyle(
                          fontSize: 11,
                          color: eventType.type == "Concert"
                              ? Colors.green
                              : eventType.type == "Live Show"
                                  ? Colors.orange
                                  : eventType.type == "Mini Show"
                                      ? Colors.blue
                                      : eventType.type == "Festival"
                                          ? Colors.purple
                                          : Colors.brown,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
              ],
            );
    }
    return Container();
  }
}
