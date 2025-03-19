
import 'package:flutter/material.dart';

class DynamicFormFields {
  final String type;
  final String label;
  final String? error;
  final String? hint;
  final bool isObscure;
  final IconData? icon;

  DynamicFormFields({
    required this.type,
    required this.label,
    this.error,
    this.hint,
    this.isObscure = false,
    this.icon,
  });

  factory DynamicFormFields.fromJson(Map<String, dynamic> json) {
    return DynamicFormFields(
      type: json['type'],
      label: json['label'],
      error: json['error'],
      hint: json['hint'],
      isObscure: json['isObscure'] ?? false,
    );
  }



}
