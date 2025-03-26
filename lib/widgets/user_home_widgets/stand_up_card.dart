import 'package:flutter/material.dart';

Widget standUpCard(BuildContext context, Widget child) {
  ColorScheme colors = Theme.of(context).colorScheme;
  return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: colors.secondary,
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      color: colors.onError,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: child,
      ));
}
