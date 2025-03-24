import '../models/dynamic_form_field.dart';


/// signup form data
final response = {
  "resp_code": "00",
  "resp_message": "success",
  "resp_description": "request successfully",
  "form_data":
  [
    {
      "type": "input",
      "label": "Name",
      "hint": "Enter your full name",
      // "error": ""
    },
    {
      "type": "input",
      "label": "Email Address",
      "hint": "Enter your email",
      // "error": "Invalid email"
    },
    {
      "type": "dropdown",
      "label": "Select Department",
      "hint": "Choose your department",
      "options": ["Mobile Dev", "Product Designer", "CyberSecurity"]
    },
    {
      "type": "input",
      "label": "Password",
      "hint": "Enter your password",
      // "error": "Password too short"
    },
    {
      "type": "input",
      "label": "Confirm Password",
      "hint": "Confirm your password",
      // "error": "Password too short"
    },
    {
      "type": "btn",
      "label": "Create Account",
      // "error": "Password too short"
    },
    // {
    //   "type": "text",
    //   "label": "Have an Account?",
    // },
    // {
    //   "type": "boldText",
    //   "label": "Login?",
    // },
  ],

  "default_data": [
    {
      "type": "text",
      "label":
      "Unable to render form fields",
      "error": ""
    },
    // {
    //   "type": "input",
    //   "label": "Email",
    //   // "error": "Invalid email"
    // },
    // {
    //   "type": "input",
    //   "label": "Name",
    //   // "error": "Invalid email"
    // },

  ]
};

final signupFormFieldList = ((response['form_data'] ??
    response['default_data']) as List)
    .map((data) => DynamicFormFields.fromJson(data))
    .toList();


/// login form data

final login = {
  "resp_code": "00",
  "resp_message": "success",
  "resp_description": "request successfully",
  "form_data":
  [
    {
      "type": "input",
      "label": "Email Address",
      "hint": "Enter your email",
      // "error": "Invalid email"
    },
    {
      "type": "input",
      "label": "Password",
      "hint": "Enter your password",
      // "error": "Password too short"
    },
    {
      "type": "btn",
      "label": "Login",
      // "error": "Password too short"
    },
    // {
    //   "type": "text",
    //   "label": "Have an Account?",
    // },
    // {
    //   "type": "boldText",
    //   "label": "Login?",
    // },
  ],

  "default_data": [
    {
      "type": "text",
      "label":
      "Unable to render form fields",
      "error": ""
    },
    // {
    //   "type": "input",
    //   "label": "Email",
    //   // "error": "Invalid email"
    // },
    // {
    //   "type": "input",
    //   "label": "Name",
    //   // "error": "Invalid email"
    // },

  ]
};

final loginFormFieldList = ((login['form_data'] ??
    response['default_data']) as List)
    .map((data) => DynamicFormFields.fromJson(data))
    .toList();


/// forgot password form data
final forgotPassword = {
  "resp_code": "00",
  "resp_message": "success",
  "resp_description": "request successfully",
  "form_data":
  [
    {
      "type": "input",
      "label": "Email Address",
      "hint": "Enter your email",
      // "error": "Invalid email"
    },

    {
      "type": "btn",
      "label": "Proceed",
      // "error": "Password too short"
    },
    // {
    //   "type": "text",
    //   "label": "Have an Account?",
    // },
    // {
    //   "type": "boldText",
    //   "label": "Login?",
    // },
  ],

  "default_data": [
    {
      "type": "text",
      "label":
      "Unable to render form fields",
      "error": ""
    },
    // {
    //   "type": "input",
    //   "label": "Email",
    //   // "error": "Invalid email"
    // },
    // {
    //   "type": "input",
    //   "label": "Name",
    //   // "error": "Invalid email"
    // },

  ]
};

final forgotPasswordFormFieldList = ((forgotPassword['form_data'] ??
    response['default_data']) as List)
    .map((data) => DynamicFormFields.fromJson(data))
    .toList();