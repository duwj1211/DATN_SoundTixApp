import 'package:flutter/material.dart';

class InputCustom extends StatefulWidget {
  final String? hintText;
  final String? errorText;
  final Widget? label;
  final Widget? prefixIcon;
  final TextEditingController? controller;
  final bool obscureText;
  final int? maxLines;
  final Function(String)? onChanged;
  const InputCustom(
      {super.key,
      this.hintText,
      this.errorText,
      this.label,
      this.prefixIcon,
      this.controller,
      required this.obscureText,
      this.onChanged,
      this.maxLines = 1});

  @override
  State<InputCustom> createState() => _InputCustomState();
}

class _InputCustomState extends State<InputCustom> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.obscureText,
      onChanged: widget.onChanged,
      maxLines: widget.maxLines,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10),
        filled: true,
        fillColor: const Color.fromARGB(255, 235, 235, 235),
        label: widget.label,
        hintText: widget.hintText,
        errorText: widget.errorText,
        prefixIcon: widget.prefixIcon,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(5),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}
