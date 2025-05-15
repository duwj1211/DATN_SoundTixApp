import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sound_tix_view/api.dart';
import 'package:sound_tix_view/entity/event.dart';
import 'package:sound_tix_view/model/model.dart';
import 'package:sound_tix_view/page/organizer/root-organizer/root_organizer_page.dart';

class ReportManagementWidget extends StatefulWidget {
  const ReportManagementWidget({super.key});

  @override
  State<ReportManagementWidget> createState() => _ReportManagementWidgetState();
}

class _ReportManagementWidgetState extends State<ReportManagementWidget> {
  late Future futureReports;
  int currentIndex = 0;
  int currentPage = 0;
  int currentSize = 5;
  List<Event> events = [];
  var findRequestReport = {};

  @override
  void initState() {
    super.initState();
    futureReports = getInitPage();
  }

  getInitPage() async {
    await getListEvents(currentPage, currentSize, findRequestReport);
    return 0;
  }

  getListEvents(page, size, findRequest) async {
    var rawData = await httpPost(context, "http://localhost:8080/event/search?page=$page&size=$size", findRequest);

    setState(() {
      events = [];

      for (var element in rawData["body"]["content"]) {
        var event = Event.fromMap(element);
        events.add(event);
      }
    });
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChangeThemeModel>(builder: (context, changeThemeModel, child) {
      return FutureBuilder(
        future: futureReports,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const RootOrganizerPage(
              currentPage: "Report management",
              child: Column(
                children: [],
              ),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      );
    });
  }
}
