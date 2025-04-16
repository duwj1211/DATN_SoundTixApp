import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class DynamicDropdownButton extends StatefulWidget {
  final dynamic value;
  final String? hintText;
  final List<DropdownMenuItem>? items;
  final Function(dynamic newValue)? onChanged;
  final bool isRequiredNotEmpty;
  final String? labelText;
  final bool enabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool hasClearIcon;
  final void Function(FocusNode)? onErrorFocus;
  final FocusNode? focusNode;
  const DynamicDropdownButton({
    this.value,
    this.hintText,
    this.items,
    this.onChanged,
    this.isRequiredNotEmpty = false,
    super.key,
    this.labelText,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.hasClearIcon = true,
    this.onErrorFocus,
    this.focusNode,
  });

  @override
  State<DynamicDropdownButton> createState() => _DynamicDropdownButtonState();
}

class _DynamicDropdownButtonState extends State<DynamicDropdownButton> {
  TextEditingController searchController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !widget.enabled,
      child: DropdownButtonFormField2<dynamic>(
        focusNode: widget.focusNode ?? _focusNode,
        isExpanded: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          hoverColor: Colors.transparent,
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 199, 199, 199),
            ),
          ),
          contentPadding: const EdgeInsets.all(0),
          hintText: widget.hintText,
          labelText: widget.labelText,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromRGBO(196, 200, 223, 1),
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue,
            ),
          ),
        ),
        value: widget.value,
        onChanged: widget.onChanged,
        items: widget.items,
        hint: Text(widget.hintText ?? ""),
      ),
    );
  }
}
