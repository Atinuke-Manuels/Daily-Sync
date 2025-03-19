import 'package:daily_sync/theme/app_text_styles.dart';
import 'package:daily_sync/widgets/custom_button.dart';
import 'package:flutter/material.dart';

import '../core/models/dynamic_form_field.dart';
import '../core/utils/form_validation.dart';
import 'custom_text_field.dart';

class DynamicForm extends StatefulWidget {
  final List<DynamicFormFields> dynamicFields;
  final VoidCallback? onSubmit;

  const DynamicForm({
    super.key,
    required this.dynamicFields,
    this.onSubmit,
  });

  @override
  _DynamicFormState createState() => _DynamicFormState();
}

class _DynamicFormState extends State<DynamicForm> {
  final Map<String, TextEditingController> controllers = {};
  final Map<String, String?> errors = {}; // To store errors for each field

  // This method will be called on text field change to validate the input
  void validateField(String fieldLabel, String value) {
    String? error;

    switch (fieldLabel.toLowerCase()) {
      case 'email':
        error = validateEmail(value);
        break;
      case 'password':
        error = validatePassword(value);
        break;
      case 'name':
      default:
        error = validateName(value);
        break;
    }

    setState(() {
      errors[fieldLabel] = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Initialize controllers for each field
    widget.dynamicFields.forEach((field) {
      controllers.putIfAbsent(field.label, () => TextEditingController());
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.dynamicFields.map((field) {
        // Render based on type
        Widget fieldWidget;
        if (field.type == 'input') {
          fieldWidget = CustomTextField(
            controller: controllers[field.label]!,
            label: field.label,
            hint: field.hint,
            isObscure: field.label.toLowerCase().contains("password"),
            optionalIcon: field.icon,
            onChanged: (value) {
              validateField(field.label, value);
            },
          );
        } else if (field.type == 'btn') {
          // Render button
          fieldWidget =
              CustomButton(onTap: widget.onSubmit ?? () {}, title: field.label);
        } else if (field.type == 'text') {
          // Render label or text
          fieldWidget = Text(
            field.label,
            style: AppTextStyles.bodyMedium(context),
          );
        } else {
          fieldWidget = Container();
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              fieldWidget,

              // this helps to display the error message
              if (errors[field.label] != null)
                Text(
                  errors[field.label]!, // Show error message if any
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
