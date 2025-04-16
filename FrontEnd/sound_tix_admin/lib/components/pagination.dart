import 'package:flutter/material.dart';

class PaginationWidget extends StatefulWidget {
  final int totalPages;
  final Function(int) onPageChanged;
  const PaginationWidget({super.key, required this.totalPages, required this.onPageChanged});

  @override
  State<PaginationWidget> createState() => _PaginationWidgetState();
}

class _PaginationWidgetState extends State<PaginationWidget> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return widget.totalPages > 0
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                focusColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  setState(() {
                    if (currentPage > 0) {
                      currentPage--;
                    }
                    widget.onPageChanged(currentPage);
                  });
                },
                child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(3)),
                    child: Icon(Icons.keyboard_arrow_left, size: 22, color: (currentPage > 0) ? Colors.black : Colors.grey.shade500)),
              ),
              const SizedBox(width: 5),
              for (int i = 0; i < widget.totalPages; i++)
                InkWell(
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    setState(() {
                      currentPage = i;
                      widget.onPageChanged(currentPage);
                    });
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                        color: currentPage == i ? Colors.blue : Colors.transparent,
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(color: currentPage == i ? Colors.blue : Colors.grey)),
                    child: Center(
                      child: Text('${i + 1}',
                          style: TextStyle(
                              color: currentPage == i ? Colors.white : Colors.black,
                              fontSize: 14,
                              fontWeight: currentPage == i ? FontWeight.bold : null)),
                    ),
                  ),
                ),
              const SizedBox(width: 5),
              InkWell(
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                focusColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  setState(() {
                    if (currentPage < widget.totalPages - 1) {
                      currentPage++;
                    }
                    widget.onPageChanged(currentPage);
                  });
                },
                child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(3)),
                    child: Icon(Icons.keyboard_arrow_right, size: 22, color: (currentPage < widget.totalPages - 1) ? Colors.black : Colors.grey)),
              ),
            ],
          )
        : Container();
  }
}
