import 'package:flutter/material.dart';

Widget MyTextField(
  BuildContext context,
  TextEditingController controller,
  String label, {
  bool obscure = false,
  IconData? prefixIcon,
  bool readOnly = false,
  VoidCallback? onTap,
  String? Function(String?)? validator,
  TextInputType keyboardType = TextInputType.text,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8),
    child: TextFormField(
      controller: controller,
      obscureText: obscure,
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboardType,
      validator: validator,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: Colors.white)
            : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.blueAccent.withOpacity(0.7),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    ),
  );
}
