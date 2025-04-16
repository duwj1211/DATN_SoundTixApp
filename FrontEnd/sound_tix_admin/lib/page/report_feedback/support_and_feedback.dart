import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sound_tix_admin/api.dart';
import 'package:sound_tix_admin/components/feedback_item_widget.dart';
import 'package:sound_tix_admin/entity/feedback.dart';

class SupportAndFeedbackWidget extends StatefulWidget {
  const SupportAndFeedbackWidget({super.key});

  @override
  State<SupportAndFeedbackWidget> createState() => _SupportAndFeedbackWidgetState();
}

class _SupportAndFeedbackWidgetState extends State<SupportAndFeedbackWidget> {
  late Future futureFeedback;
  final TextEditingController searchController = TextEditingController();
  int currentPage = 0;
  List<SupportAndFeedback> feedbacks = [];
  var findRequestFeedback = {};
  bool _isLoadingFeedback = true;
  bool _isLoadingCountFeedback = true;
  Timer? _debounceTimer;
  bool? filterByTimeAsc;
  String _selectedTypeFilter = "";
  String _selectedStatusFilter = "";
  int? _selectedStarFilter;
  int totalItems = 0;
  int oneStarCount = 0;
  int twoStarCount = 0;
  int threeStarCount = 0;
  int fourStarCount = 0;
  int fiveStarCount = 0;
  double averageRating = 0.0;

  @override
  void initState() {
    super.initState();
    futureFeedback = getInitPage();
  }

  getInitPage() async {
    await search();
    await countFeedbacks();
    return 0;
  }

  search() {
    var searchRequest = {
      "title": searchController.text,
      "type": _selectedTypeFilter,
      "status": _selectedStatusFilter,
      "starCount": _selectedStarFilter,
      "filterByTimeAsc": filterByTimeAsc,
    };
    findRequestFeedback = searchRequest;
    getListFeedbacks(currentPage, findRequestFeedback);
  }

  getListFeedbacks(page, findRequest) async {
    var rawData = await httpPost("http://localhost:8080/feedback/search?page=$page&size=10", findRequest);

    setState(() {
      feedbacks = [];

      for (var element in rawData["body"]["content"]) {
        var feedback = SupportAndFeedback.fromMap(element);
        feedbacks.add(feedback);
      }

      _isLoadingFeedback = false;
    });
    return 0;
  }

  countFeedbacks() async {
    var rawData = await httpPost("http://localhost:8080/feedback/search", {});

    setState(() {
      totalItems = rawData["body"]["totalItems"];

      oneStarCount = rawData["body"]["oneStarCount"];
      twoStarCount = rawData["body"]["twoStarCount"];
      threeStarCount = rawData["body"]["threeStarCount"];
      fourStarCount = rawData["body"]["fourStarCount"];
      fiveStarCount = rawData["body"]["fiveStarCount"];

      averageRating = (oneStarCount + twoStarCount * 2 + threeStarCount * 3 + fourStarCount * 4 + fiveStarCount * 5) /
          (oneStarCount + twoStarCount + threeStarCount + fourStarCount + fiveStarCount);

      _isLoadingCountFeedback = false;
    });
    return 0;
  }

  updateFeedback(feedbackId, result, type) async {
    var response = await httpPatch("http://localhost:8080/feedback/update/$feedbackId", result);

    if (response['statusCode'] == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: type == "Reply" ? const Text('Trả lời thành công!') : const Text('Thả cảm xúc thành công!'),
          duration: const Duration(seconds: 1),
        ),
      );
      getListFeedbacks(currentPage, findRequestFeedback);
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: type == "Reply" ? const Text('Trả lời thất bại!') : const Text('Thả cảm xúc thất bại!'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int maxCount = [oneStarCount, twoStarCount, threeStarCount, fourStarCount, fiveStarCount].reduce((a, b) => a > b ? a : b);
    List listFeedbackTimeFilter = [
      {"name": "Lastest date", "value": true},
      {"name": "Oldest date", "value": false},
    ];
    List<String> listTypeFilter = ["Đánh giá", "Góp ý", "Báo cáo lỗi"];
    List<String> listStatusFilter = ["Responded", "Unresponded"];
    List listStarFilter = [
      {"name": "1 sao", "value": 1},
      {"name": "2 sao", "value": 2},
      {"name": "3 sao", "value": 3},
      {"name": "4 sao", "value": 4},
      {"name": "5 sao", "value": 5},
    ];
    return FutureBuilder(
      future: futureFeedback,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            body: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 7,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(35, 25, 28, 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Support & Feedback", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          const Text("Manage and review team reports and feedback for continuous improvement.", style: TextStyle(fontSize: 16)),
                          const SizedBox(height: 50),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 150,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(color: const Color.fromARGB(255, 235, 235, 235), borderRadius: BorderRadius.circular(5)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Total Feedbacks", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey[700])),
                                      const SizedBox(height: 20),
                                      _isLoadingCountFeedback
                                          ? const CircularProgressIndicator()
                                          : Text("$totalItems", style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Container(
                                  height: 150,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(color: const Color.fromARGB(255, 235, 235, 235), borderRadius: BorderRadius.circular(5)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Average Rating", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey[700])),
                                      const SizedBox(height: 20),
                                      Row(
                                        children: [
                                          _isLoadingCountFeedback
                                              ? const CircularProgressIndicator()
                                              : Text(averageRating.toStringAsFixed(2),
                                                  style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
                                          const SizedBox(width: 20),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: List.generate(5, (index) {
                                              if (index < averageRating.floor()) {
                                                return const Icon(Icons.star, color: Colors.amber, size: 22);
                                              } else if (index == averageRating.floor() && averageRating % 1 != 0) {
                                                return Stack(
                                                  children: [
                                                    const Icon(Icons.star, color: Colors.grey, size: 22),
                                                    ClipRect(
                                                      clipper: _PartialClipper(averageRating % 1),
                                                      child: const Icon(Icons.star, color: Colors.amber, size: 22),
                                                    ),
                                                  ],
                                                );
                                              } else {
                                                return const Icon(Icons.star, color: Colors.grey, size: 22);
                                              }
                                            }),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Container(
                                  height: 150,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(color: const Color.fromARGB(255, 235, 235, 235), borderRadius: BorderRadius.circular(5)),
                                  child: _isLoadingCountFeedback
                                      ? const Center(child: CircularProgressIndicator())
                                      : Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            _buildRatingBar(1, oneStarCount, maxCount, Colors.teal.shade300),
                                            const SizedBox(height: 5),
                                            _buildRatingBar(2, twoStarCount, maxCount, Colors.purple.shade300),
                                            const SizedBox(height: 5),
                                            _buildRatingBar(3, threeStarCount, maxCount, Colors.orange.shade300),
                                            const SizedBox(height: 5),
                                            _buildRatingBar(4, fourStarCount, maxCount, Colors.blue.shade300),
                                            const SizedBox(height: 5),
                                            _buildRatingBar(5, fiveStarCount, maxCount, Colors.red.shade400),
                                          ],
                                        ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          _isLoadingFeedback
                              ? const CircularProgressIndicator()
                              : Column(
                                  children: [
                                    Wrap(
                                      runSpacing: 20,
                                      children: [
                                        for (var feedback in feedbacks)
                                          FeedbackItemWidget(
                                            feedbackId: feedback.feedbackId!,
                                            onReply: (replyResult) {
                                              updateFeedback(feedback.feedbackId!, replyResult, "Reply");
                                            },
                                            onReact: (reactResult) {
                                              updateFeedback(feedback.feedbackId!, reactResult, "React");
                                            },
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(2, 80, 35, 25),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 42,
                          child: TextField(
                            controller: searchController,
                            onChanged: (value) {
                              setState(() {
                                searchController.text;
                              });
                              if (_debounceTimer?.isActive ?? false) {
                                _debounceTimer?.cancel();
                              }

                              _debounceTimer = Timer(const Duration(milliseconds: 500), () {
                                search();
                              });
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(5),
                              hintText: "Search feedback",
                              hintStyle: const TextStyle(fontSize: 15),
                              prefixIcon: const Icon(Icons.search, size: 20),
                              suffixIcon: searchController.text != ""
                                  ? InkWell(
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      onTap: () {
                                        setState(() {
                                          searchController.clear();
                                          search();
                                        });
                                      },
                                      child: const Icon(Icons.clear, size: 18))
                                  : null,
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(top: 22),
                            decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 0.3), borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                                  decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                                  child: const Row(
                                    children: [
                                      Text("Filter", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Text("Feedback time", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                                  const Padding(padding: EdgeInsets.fromLTRB(0, 2, 0, 10), child: Divider(thickness: 1)),
                                                  Row(
                                                    children: listFeedbackTimeFilter.map((option) {
                                                      return Container(
                                                        padding: const EdgeInsets.fromLTRB(2, 0, 8, 0),
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: filterByTimeAsc == option["value"] ? Colors.blue : Colors.grey, width: 2),
                                                            borderRadius: BorderRadius.circular(99)),
                                                        margin: const EdgeInsets.only(right: 10),
                                                        child: Row(
                                                          children: [
                                                            Radio<bool>(
                                                              activeColor: Colors.blue,
                                                              value: option["value"],
                                                              groupValue: filterByTimeAsc,
                                                              onChanged: (bool? newValue) {
                                                                setState(() {
                                                                  filterByTimeAsc = newValue!;
                                                                });
                                                              },
                                                            ),
                                                            Text(option["name"],
                                                                style: TextStyle(
                                                                    fontSize: 12,
                                                                    color: filterByTimeAsc == option["value"] ? Colors.blue : Colors.black,
                                                                    fontWeight: FontWeight.w500)),
                                                          ],
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 15),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Text("Type", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                                  const Padding(padding: EdgeInsets.fromLTRB(0, 2, 0, 10), child: Divider(thickness: 1)),
                                                  Row(
                                                    children: listTypeFilter.map((option) {
                                                      return Container(
                                                        padding: const EdgeInsets.fromLTRB(2, 0, 8, 0),
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: _selectedTypeFilter == option ? Colors.blue : Colors.grey, width: 2),
                                                            borderRadius: BorderRadius.circular(99)),
                                                        margin: const EdgeInsets.only(right: 10),
                                                        child: Row(
                                                          children: [
                                                            Radio<String>(
                                                              activeColor: Colors.blue,
                                                              value: option,
                                                              groupValue: _selectedTypeFilter,
                                                              onChanged: (String? newValue) {
                                                                setState(() {
                                                                  _selectedTypeFilter = newValue!;
                                                                });
                                                              },
                                                            ),
                                                            Text(option,
                                                                style: TextStyle(
                                                                    fontSize: 12,
                                                                    color: _selectedTypeFilter == option ? Colors.blue : Colors.black,
                                                                    fontWeight: FontWeight.w500)),
                                                          ],
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 15),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Text("Status", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                                  const Padding(padding: EdgeInsets.fromLTRB(0, 2, 0, 10), child: Divider(thickness: 1)),
                                                  Row(
                                                    children: listStatusFilter.map((option) {
                                                      return Container(
                                                        padding: const EdgeInsets.fromLTRB(2, 0, 8, 0),
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: _selectedStatusFilter == option ? Colors.blue : Colors.grey, width: 2),
                                                            borderRadius: BorderRadius.circular(99)),
                                                        margin: const EdgeInsets.only(right: 10),
                                                        child: Row(
                                                          children: [
                                                            Radio<String>(
                                                              activeColor: Colors.blue,
                                                              value: option,
                                                              groupValue: _selectedStatusFilter,
                                                              onChanged: (String? newValue) {
                                                                setState(() {
                                                                  _selectedStatusFilter = newValue!;
                                                                });
                                                              },
                                                            ),
                                                            Text(option,
                                                                style: TextStyle(
                                                                    fontSize: 12,
                                                                    color: _selectedStatusFilter == option ? Colors.blue : Colors.black,
                                                                    fontWeight: FontWeight.w500)),
                                                          ],
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 15),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Text("Star", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                                  const Padding(padding: EdgeInsets.fromLTRB(0, 2, 0, 10), child: Divider(thickness: 1)),
                                                  Wrap(
                                                    runSpacing: 10,
                                                    children: listStarFilter.map((option) {
                                                      return Container(
                                                        width: 80,
                                                        padding: const EdgeInsets.fromLTRB(2, 0, 8, 0),
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: _selectedStarFilter == option["value"] ? Colors.blue : Colors.grey, width: 2),
                                                            borderRadius: BorderRadius.circular(99)),
                                                        margin: const EdgeInsets.only(right: 10),
                                                        child: Row(
                                                          children: [
                                                            Radio<int>(
                                                              activeColor: Colors.blue,
                                                              value: option["value"],
                                                              groupValue: _selectedStarFilter,
                                                              onChanged: (int? newValue) {
                                                                setState(() {
                                                                  _selectedStarFilter = newValue!;
                                                                });
                                                              },
                                                            ),
                                                            Text(option["name"],
                                                                style: TextStyle(
                                                                    fontSize: 12,
                                                                    color: _selectedStarFilter == option["value"] ? Colors.blue : Colors.black,
                                                                    fontWeight: FontWeight.w500)),
                                                          ],
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              hoverColor: Colors.transparent,
                                              highlightColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              splashColor: Colors.transparent,
                                              onTap: () {
                                                setState(() {
                                                  filterByTimeAsc = null;
                                                  _selectedTypeFilter = '';
                                                  _selectedStatusFilter = '';
                                                  _selectedStarFilter = null;
                                                  search();
                                                });
                                              },
                                              child: Container(
                                                width: 85,
                                                padding: const EdgeInsets.fromLTRB(18, 6, 18, 6),
                                                decoration:
                                                    BoxDecoration(border: Border.all(color: Colors.blue), borderRadius: BorderRadius.circular(5)),
                                                child: const Center(
                                                    child: Text("Reset",
                                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.blue))),
                                              ),
                                            ),
                                            const SizedBox(width: 25),
                                            InkWell(
                                              hoverColor: Colors.transparent,
                                              highlightColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              splashColor: Colors.transparent,
                                              onTap: () {
                                                setState(() {
                                                  search();
                                                });
                                              },
                                              child: Container(
                                                width: 85,
                                                padding: const EdgeInsets.fromLTRB(18, 6, 18, 6),
                                                decoration: BoxDecoration(
                                                    color: Colors.blue,
                                                    border: Border.all(color: Colors.blue),
                                                    borderRadius: BorderRadius.circular(5)),
                                                child: const Center(
                                                    child: Text("Apply",
                                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white))),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }

  Widget _buildRatingBar(int number, int count, int maxCount, Color color) {
    return Row(
      children: [
        const Icon(Icons.star, size: 12, color: Colors.grey),
        const SizedBox(width: 3),
        Text("$number", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(width: 12),
        Expanded(
          flex: count,
          child: Container(height: 5, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20))),
        ),
        Expanded(
          flex: maxCount - count,
          child: Container(
              height: 5, decoration: BoxDecoration(color: const Color.fromARGB(255, 235, 235, 235), borderRadius: BorderRadius.circular(20))),
        ),
      ],
    );
  }
}

class _PartialClipper extends CustomClipper<Rect> {
  final double percent;

  _PartialClipper(this.percent);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0.0, 0.0, size.width * percent, size.height);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return false;
  }
}
