String? validateName(String? value) {
  value = value?.trim() ?? " ";
  if (value.isEmpty) {
    return 'Name is required';
  } else if (value.length < 3) {
    return 'Name should be at least 3 characters long';
  } else {
    return null;
  }
}

String? validateEmail(String? value) {
  value = value?.trim() ?? "";
  final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  if (value.isEmpty) {
    return 'Email is required';
  } else if (!emailRegex.hasMatch(value)) {
    return 'Invalid email format';
  } else {
    return null;
  }
}


String? validateDepartment(String? value) {
  value = value ?? "";
  if (value.isEmpty) {
    return 'Select a department';
  } else {
    return null;
  }
}

String? validatePassword(String? value) {
  value = value ?? "";
  final passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$');
  if (value.isEmpty) {
    return 'Password is required';
  } else if (!passwordRegex.hasMatch(value)) {
    return 'Password must be at least 8 characters long, \ncontain at least 1 uppercase letter, \n1 lowercase letter, \n1 number, and 1 special character';
  } else {
    return null;
  }
}