String getFirebaseErrorMessage(String errorCode) {
  switch (errorCode) {
    case "email-already-in-use":
      return "This email is already registered. Try logging in.";
    case "invalid-email":
      return "Please enter a valid email address.";
    case "weak-password":
      return "Your password is too weak. Try a stronger one.";
    case "operation-not-allowed":
      return "Email/password accounts are not enabled.";
    default:
      return "An error occurred. Please try again.";
  }
}