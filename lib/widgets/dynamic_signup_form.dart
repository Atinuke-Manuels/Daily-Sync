import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/models/dynamic_form_field.dart';
import '../core/utils/form_validation.dart';
import '../view_model/auth_view_model.dart';
import 'custom_dropdown.dart';
import 'custom_text_field.dart';
import 'custom_button.dart';
import '../theme/app_text_styles.dart';

class DynamicForm extends StatefulWidget {
  final List<DynamicFormFields> dynamicFields;
  final Function(Map<String, String>)? onSubmit; // Updated to accept form data

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
  final Map<String, String?> errors = {};
  final Map<String, String?> selectedDropdownValues = {};

  @override
  void initState() {
    super.initState();
    for (var field in widget.dynamicFields) {
      controllers[field.label] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }


  void validateField(String fieldLabel, String value) {
    String label = fieldLabel.toLowerCase().trim();
    String? error;

    if (label.contains("email")) {
      error = validateEmail(value);
    } else if (label == "password") {
      error = validatePassword(value);
    } else if (label.contains("name")) {
      error = validateName(value);
    } else if (label.contains("select")) {
      error = validateDepartment(value);
    } else {
      error = null;
    }

    setState(() {
      errors[fieldLabel] = error;
    });
  }

  void _submitForm() {
    final Map<String, String> formData = {
      for (var field in widget.dynamicFields)
        if (controllers[field.label] != null) field.label: controllers[field.label]!.text
    };

    // Add dropdown values to formData
    for (var field in widget.dynamicFields) {
      if (field.type == 'dropdown' && selectedDropdownValues[field.label] != null) {
        formData[field.label] = selectedDropdownValues[field.label]!;
      }
    }

    // // Print formData for debugging
    // print("Form Data: $formData");

    // Call the onSubmit callback
    widget.onSubmit?.call(formData);
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.dynamicFields.map((field) {
        Widget? fieldWidget;

        if (field.type == 'input') {
          fieldWidget = CustomTextField(
            controller: controllers[field.label]!,
            label: field.label,
            hint: field.hint,
            isObscure: field.label.toLowerCase().contains("password"),
            optionalIcon: field.icon,
            onChanged: (value) => validateField(field.label, value),
          );
        } else if (field.type == 'dropdown') {
          fieldWidget = CustomDropdown(
            label: field.label,
            items: field.options ?? [],
            selectedValue: selectedDropdownValues[field.label],
            onChanged: (value) {
              setState(() {
                selectedDropdownValues[field.label] = value;
              });
            },
          );
        } else if (field.type == 'btn') {
          fieldWidget = authViewModel.isLoading
              ? const Text('Loading...')
              : CustomButton(
            onTap: _submitForm, // Call _submitForm on button tap
            title: field.label,
          );
        } else if (field.type == 'text') {
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
              if (errors[field.label] != null)
                Text(
                  errors[field.label]!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
