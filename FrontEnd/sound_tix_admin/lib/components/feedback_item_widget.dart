import 'package:flutter/material.dart';
import 'package:sound_tix_admin/api.dart';
import 'package:sound_tix_admin/components/reaction_item.dart';
import 'package:sound_tix_admin/entity/feedback.dart';
import 'package:sound_tix_admin/entity/user.dart';

class FeedbackItemWidget extends StatefulWidget {
  final int feedbackId;
  final Function? onReply;
  final Function? onReact;
  const FeedbackItemWidget({super.key, required this.feedbackId, this.onReply, this.onReact});

  @override
  State<FeedbackItemWidget> createState() => _FeedbackItemWidgetState();
}

class _FeedbackItemWidgetState extends State<FeedbackItemWidget> {
  TextEditingController replyController = TextEditingController();
  SupportAndFeedback? feedback;
  bool _isLoadingFeedback = true;
  List<User> users = [];
  bool _isLoadingUser = true;
  bool isEditReply = false;

  @override
  void initState() {
    getFeedback(widget.feedbackId);
    super.initState();
  }

  getFeedback(feedbackId) async {
    var response = await httpGet("http://localhost:8080/feedback/$feedbackId");
    setState(() {
      feedback = SupportAndFeedback.fromMap(response["body"]);
      searchUsersAndDisplay(feedback!.feedbackId);
      _isLoadingFeedback = false;
    });
  }

  void searchUsersAndDisplay(feedbackId) async {
    var rawData = await httpPost("http://localhost:8080/user/search", {"feedbackId": feedbackId});

    setState(() {
      users = [];

      for (var element in rawData["body"]["content"]) {
        var user = User.fromMap(element);
        users.add(user);
      }

      _isLoadingUser = false;
    });
  }

  String timeAgoFromDate(feedbackTime) {
    DateTime now = DateTime.now();

    Duration difference = now.difference(feedbackTime);

    if (difference.inDays >= 1) {
      return "${difference.inDays} ngày trước";
    } else if (difference.inHours >= 1) {
      return "${difference.inHours} giờ trước";
    } else if (difference.inMinutes >= 1) {
      return "${difference.inMinutes} phút trước";
    } else {
      return "${difference.inSeconds} giây trước";
    }
  }

  @override
  void dispose() {
    replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoadingFeedback
        ? const CircularProgressIndicator()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 0.2),
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _isLoadingUser
                        ? const CircularProgressIndicator()
                        : Column(
                            children: [
                              for (var user in users)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(99),
                                          child: Image.asset("images/${user.avatar}", fit: BoxFit.cover, width: 38, height: 38),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(user.fullName, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                                        const SizedBox(width: 30),
                                        const Padding(
                                          padding: EdgeInsets.only(top: 2),
                                          child: Icon(Icons.circle, size: 10, color: Colors.grey),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(timeAgoFromDate(feedback!.feedbackTime), style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.fromLTRB(25, 8, 25, 8),
                                          decoration: BoxDecoration(
                                              color: feedback!.status == "Responded" ? Colors.green[400] : Colors.grey,
                                              borderRadius: BorderRadius.circular(20)),
                                          child: Text(feedback!.status,
                                              style: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500)),
                                        ),
                                        const SizedBox(width: 15),
                                        Container(
                                          padding: const EdgeInsets.fromLTRB(25, 8, 25, 8),
                                          decoration: BoxDecoration(
                                              color: feedback!.type == "Đánh giá"
                                                  ? const Color(0xFF10DAA9)
                                                  : feedback!.type == "Báo cáo lỗi"
                                                      ? Colors.red
                                                      : Colors.deepPurple,
                                              borderRadius: BorderRadius.circular(20)),
                                          child: Text(feedback!.type,
                                              style: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                            ],
                          ),
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          5,
                          (index) {
                            return Icon(
                              Icons.star,
                              color: index < feedback!.starCount ? Colors.amber : Colors.grey,
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(feedback!.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 15),
                    Text(feedback!.content, style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
              (feedback!.reply != null)
                  ? isEditReply
                      ? TextField(
                          controller: replyController,
                          onChanged: (value) {
                            setState(() {});
                          },
                          maxLines: null,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                            hintText: "Edit reply",
                            suffixIcon: InkWell(
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  setState(() {
                                    isEditReply = false;
                                  });
                                  widget.onReply!({"reply": replyController.text});
                                },
                                child: const Icon(Icons.send, size: 20)),
                            filled: true,
                            fillColor: Colors.grey[200],
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey, width: 0.2),
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey, width: 0.2),
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                            ),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey, width: 0.2),
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                            ),
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 0.2),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(99),
                                child: Image.asset("images/soundtix_logo.png", fit: BoxFit.cover, width: 38, height: 38),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const SizedBox(height: 6),
                                            const Text("SoundTix", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                            const SizedBox(width: 20),
                                            const Padding(
                                              padding: EdgeInsets.only(top: 2),
                                              child: Icon(Icons.circle, size: 10, color: Colors.grey),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(timeAgoFromDate(feedback!.replyTime), style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                                            const SizedBox(width: 20),
                                            Container(
                                              padding: const EdgeInsets.fromLTRB(12, 3, 12, 3),
                                              decoration: BoxDecoration(
                                                color: const Color.fromARGB(255, 210, 234, 255),
                                                borderRadius: BorderRadius.circular(3),
                                              ),
                                              child: const Text(
                                                "Administrator",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        InkWell(
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          splashColor: Colors.transparent,
                                          onTap: () {
                                            setState(() {
                                              isEditReply = true;
                                              replyController.text = feedback!.reply!;
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.grey, width: 0.5),
                                              borderRadius: BorderRadius.circular(3),
                                            ),
                                            child: const Icon(
                                              Icons.edit,
                                              size: 15,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(feedback!.reply ?? "", style: const TextStyle(fontSize: 15)),
                                    const SizedBox(height: 12),
                                    Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey, width: 0.5),
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: ReactionItemWidget(
                                        selectedReaction: feedback!.reaction ?? 0,
                                        onReactionSelected: (reaction) {
                                          widget.onReact!({"reaction": reaction});
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                  : TextField(
                      controller: replyController,
                      onChanged: (value) {
                        setState(() {});
                      },
                      maxLines: null,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: "Reply feedback",
                        suffixIcon: InkWell(
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {
                              widget.onReply!({"reply": replyController.text});
                            },
                            child: const Icon(Icons.send, size: 20)),
                        filled: true,
                        fillColor: Colors.grey[200],
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 0.2),
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 0.2),
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 0.2),
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                        ),
                      ),
                    ),
            ],
          );
  }
}
