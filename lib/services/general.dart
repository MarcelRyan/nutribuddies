import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GeneralService {
  Future<void> selectDate(
    BuildContext context,
    DateTime selectedDate,
    Function(DateTime) onDateSelected,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      onDateSelected(picked);
    }
  }

  String formatDate(DateTime dateTime) {
    DateTime today = DateTime.now();
    DateTime yesterday = today.subtract(const Duration(days: 1));
    if (dateTime.day == today.day &&
        dateTime.month == today.month &&
        dateTime.year == today.year) {
      return 'Today';
    } else if (dateTime.day == yesterday.day &&
        dateTime.month == yesterday.month &&
        dateTime.year == yesterday.year) {
      return 'Yesterday';
    } else {
      return DateFormat('d MMMM', 'en_US').format(dateTime);
    }
  }
}
