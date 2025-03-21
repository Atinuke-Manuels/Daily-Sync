
import 'package:flutter/material.dart';

class ShowMessage{
  void showSuccessMsg(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: TextStyle(color: Theme.of(context).colorScheme.onError, fontWeight: FontWeight.bold),), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }


  void showErrorMsg(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: TextStyle(color: Theme.of(context).colorScheme.onError, fontWeight: FontWeight.bold)), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }
}