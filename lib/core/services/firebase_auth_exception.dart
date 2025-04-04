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
    case 'user-not-found':
      return 'No user found for that email.';
    case 'wrong-password':
      return 'Incorrect password provided.';
    case 'user-disabled':
      return 'This user account has been disabled.';
    case 'invalid-credential':
      return 'wrong email or password.';
    default:
      return 'Error: $errorCode';
  }
}