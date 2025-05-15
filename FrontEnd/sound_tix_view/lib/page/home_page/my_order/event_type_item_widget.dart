import 'package:flutter/material.dart';
import 'package:sound_tix_view/api.dart';
import 'package:sound_tix_view/entity/event_type.dart';

class TicketEventTypeItemWidget extends StatefulWidget {
  final int eventId;
  const TicketEventTypeItemWidget({super.key, required this.eventId});

  @override
  State<TicketEventTypeItemWidget> createState() => _TicketEventTypeItemWidgetState();
}

class _TicketEventTypeItemWidgetState extends State<TicketEventTypeItemWidget> {
  List<EventType> eventTypes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getListEventTypes(widget.eventId);
  }

  getListEventTypes(eventId) async {
    var rawData = await httpPost(context, "http://localhost:8080/event-type/search", {"eventId": eventId});

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
    return _isLoading
        ? const CircularProgressIndicator()
        : Column(
            children: [
              for (var eventType in eventTypes)
                Row(
                  children: [
                    const Icon(Icons.circle, size: 10),
                    const SizedBox(width: 10),
                    Text(eventType.type, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))
                  ],
                ),
            ],
          );
  }
}
