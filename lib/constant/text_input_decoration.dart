import 'package:flutter/material.dart';
import 'package:nutribuddies/constant/colors.dart';

const textInputDecoration = InputDecoration(
  fillColor: white,
  filled: true,
  hintStyle: TextStyle(color: onSurfaceVariant),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(4)),
    borderSide: BorderSide(color: Colors.lightBlue, width: 2),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(4)),
    borderSide: BorderSide(color: error, width: 2),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(4)),
    borderSide: BorderSide(color: outline, width: 1),
  ),
  disabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(4)),
    borderSide: BorderSide(color: outline, width: 1),
  ),
);
