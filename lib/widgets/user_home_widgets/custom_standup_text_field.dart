import 'package:flutter/material.dart';

import '../../theme/app_text_styles.dart';

class CustomStandUpTextField extends StatelessWidget {
  final String title;

  const CustomStandUpTextField({
    super.key,
    required TextEditingController yesterdayController,
    required this.title,

  }) : _yesterdayController = yesterdayController;

  final TextEditingController _yesterdayController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.labelSmall(context),),
          TextField(
            controller: _yesterdayController,
            decoration: InputDecoration(
              hintText: 'start typing...',
              hintStyle: AppTextStyles.displayTiny(context),
              filled: true,
              fillColor: Theme.of(context).colorScheme.onError,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 30),
              border: OutlineInputBorder( // This only affects when no other border is set
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none, // Removes default thick border
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xFFC1C0C0), // Light grey border
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xFFC1C0C0), // Light grey border when focused
                  width: 1,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xFFC1C0C0), // Light grey border when disabled
                  width: 1,
                ),
              ),
            ),
            minLines: 1,
            maxLines: 10,
            keyboardType: TextInputType.multiline,
          ),

        ],
      ),

    );
  }
}