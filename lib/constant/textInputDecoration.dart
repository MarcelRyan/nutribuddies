import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlue, width: 2),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 2),
  ),
);
