import 'package:flutter/material.dart';

class ReactionItemWidget extends StatefulWidget {
  final int selectedReaction;
  final Function? onReactionSelected;
  const ReactionItemWidget({super.key, required this.selectedReaction, this.onReactionSelected});

  @override
  State<ReactionItemWidget> createState() => _ReactionItemWidgetState();
}

class _ReactionItemWidgetState extends State<ReactionItemWidget> {
  bool isHovered = false;
  int? selectedReaction;

  @override
  void initState() {
    super.initState();
    selectedReaction = widget.selectedReaction;
  }

  List<Map<String, dynamic>> listReaction = [
    {"name": "Like", "icon": Icons.thumb_up, "color": const Color(0xFF2196F3), "value": 1},
    {"name": "Favorite", "icon": Icons.favorite, "color": const Color(0xFFE53935), "value": 2},
    {"name": "Haha", "icon": Icons.emoji_emotions, "color": const Color(0xFFFFEB3B), "value": 3},
    {"name": "Sad", "icon": Icons.sentiment_dissatisfied, "color": const Color(0xFF9C27B0), "value": 4},
    {"name": "Angry", "icon": Icons.mood_bad, "color": const Color(0xFF795548), "value": 5},
  ];

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (isHovered)
            Wrap(
              spacing: 10,
              children: listReaction.map((reaction) {
                return InkWell(
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    setState(() {
                      selectedReaction = reaction['value'];
                    });
                    widget.onReactionSelected!(reaction['value']);
                  },
                  child: Tooltip(
                    message: reaction['name'],
                    child: Column(
                      children: [
                        Icon(
                          reaction['icon'],
                          color: reaction['color'],
                          size: 20,
                        ),
                        if (selectedReaction == reaction['value'])
                          Container(
                            margin: const EdgeInsets.only(top: 1),
                            width: 2,
                            height: 2,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          if (!isHovered)
            Icon(
              selectedReaction != 0
                  ? listReaction.firstWhere(
                      (reaction) => reaction['value'] == selectedReaction,
                    )['icon']
                  : Icons.emoji_emotions_outlined,
              color: selectedReaction != 0 ? listReaction.firstWhere((reaction) => reaction['value'] == selectedReaction)['color'] : Colors.grey,
              size: 20,
            ),
        ],
      ),
    );
  }
}
