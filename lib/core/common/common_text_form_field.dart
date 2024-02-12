import 'package:flutter/material.dart';

class CommonTextFormField extends StatelessWidget {
  final String? hintText;
  final String? initial;
  final IconData? icon;
  final bool readOnly;
  final int maxLines;
  final void Function()? onTap;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  const CommonTextFormField({
    super.key,
    this.hintText,
    this.icon,
    this.readOnly = false,
    this.maxLines = 1,
    this.onTap,
    this.controller,
    this.validator,
    this.onChanged,
    this.initial,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initial,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: onChanged,
      maxLines: maxLines,
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        filled: true,
      ),
      readOnly: readOnly,
      onTap: onTap,
    );
  }
}
