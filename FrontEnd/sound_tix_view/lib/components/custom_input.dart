import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sound_tix_view/model/model.dart';

class InputCustom extends StatefulWidget {
  final String? hintText;
  final String? errorText;
  final Widget? label;
  final Widget? prefixIcon;
  final int? maxLines;
  final TextEditingController? controller;
  final bool obscureText;
  final Function(String)? onChanged;
  const InputCustom({
    super.key,
    this.hintText,
    this.errorText,
    this.label,
    this.prefixIcon,
    this.maxLines,
    this.controller,
    required this.obscureText,
    this.onChanged,
  });

  @override
  State<InputCustom> createState() => _InputCustomState();
}

class _InputCustomState extends State<InputCustom> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChangeThemeModel>(builder: (context, changeThemeModel, child) {
      return TextField(
        controller: widget.controller,
        obscureText: widget.obscureText,
        onChanged: widget.onChanged,
        style: TextStyle(color: changeThemeModel.isDark ? Colors.white : Colors.black),
        maxLines: widget.maxLines,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          filled: true,
          fillColor: changeThemeModel.isDark ? Colors.grey[700] : const Color.fromARGB(255, 235, 235, 235),
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
    });
  }
}
