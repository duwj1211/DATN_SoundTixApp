import 'package:flutter/material.dart';
import 'package:sound_tix_view/components/app_localizations.dart';

class TicketWidget extends StatefulWidget {
  final String ticketName;
  final int price;
  final int quantityAvailable;
  final Function callbackQuantityAndMoney;
  const TicketWidget(
      {super.key, required this.ticketName, required this.price, required this.quantityAvailable, required this.callbackQuantityAndMoney});

  @override
  State<TicketWidget> createState() => _TicketWidgetState();
}

class _TicketWidgetState extends State<TicketWidget> {
  int quantityPick = 0;
  int totalMoney = 0;
  void _incrementQuantity() {
    setState(() {
      if (quantityPick < widget.quantityAvailable) {
        quantityPick++;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
            content: Text(AppLocalizations.of(context).translate('Not enough tickets left')),
            duration: const Duration(seconds: 1),
          ),
        );
      }
      totalMoney = quantityPick * widget.price;
      widget.callbackQuantityAndMoney(quantityPick, totalMoney);
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (quantityPick > 0) quantityPick--;
      totalMoney = quantityPick * widget.price;
      widget.callbackQuantityAndMoney(quantityPick, totalMoney);
    });
  }

  void _updateQuantity(String value) {
    setState(() {
      quantityPick = int.tryParse(value) ?? 0;
      totalMoney = quantityPick * widget.price;
      widget.callbackQuantityAndMoney(quantityPick, totalMoney);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.ticketName, style: const TextStyle(fontSize: 16, color: Color(0xFF2DC275), fontWeight: FontWeight.w700)),
              Text("${widget.price}.000 đ", style: const TextStyle(fontSize: 14, color: Colors.white)),
            ],
          ),
          Row(
            children: [
              InkWell(
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                focusColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: _decrementQuantity,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 15),
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: const Icon(Icons.remove, color: Colors.green, size: 20),
                ),
              ),
              const SizedBox(width: 3),
              Container(
                padding: const EdgeInsets.fromLTRB(2, 0, 0, 16),
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.black),
                  controller: TextEditingController(text: quantityPick.toString()),
                  onChanged: _updateQuantity,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(width: 3),
              InkWell(
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                focusColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: _incrementQuantity,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 15),
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: const Icon(Icons.add, color: Colors.green, size: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
