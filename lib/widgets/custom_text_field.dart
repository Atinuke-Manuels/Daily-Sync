import 'package:daily_sync/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/utils/responsive_helper.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final Function(String)? onChanged;
  final bool isObscure;
  final IconData? optionalIcon;
  final FormFieldValidator<String>? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.onChanged,
    this.isObscure = false,
    this.hint,
    this.optionalIcon,
    this.validator,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isPasswordVisible = false;

  void togglePassword() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorStyle = Theme.of(context).colorScheme;
    final responsive = Provider.of<ResponsiveHelper>(context, listen: false);

    return SizedBox(
      width: responsive.width(342, context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label, style: AppTextStyles.labelSmall(context)),
          const SizedBox(height: 6),
          TextFormField(
            controller: widget.controller,
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: TextStyle(fontSize: 14, color: colorStyle.secondary),
              fillColor: Colors.white,
              filled: true,
              suffixIcon: widget.isObscure
                  ? GestureDetector(
                onTap: togglePassword,
                child: Icon(
                  isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey.shade300,
                ),
              )
                  : widget.optionalIcon != null
                  ? GestureDetector(
                onTap: () {},
                child: Icon(
                  widget.optionalIcon,
                  color: Colors.grey.shade300,
                ),
              )
                  : null,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colorStyle.inverseSurface,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colorStyle.inverseSurface, // Consistent with enabledBorder
                  width: 1,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.red, // Or use colorStyle.error if defined
                  width: 1,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.red, // Or use colorStyle.error if defined
                  width: 1,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colorStyle.inverseSurface,
                  width: 1,
                ),
              ),
            ),
            obscureText: widget.isObscure && !isPasswordVisible,
            onChanged: widget.onChanged,
            validator: widget.validator, // Pass the validator here
          ),
          SizedBox(height: 4,),
        ],
      ),
    );
  }
}