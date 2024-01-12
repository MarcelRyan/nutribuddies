import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nutribuddies/constant/colors.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      child: const Center(
        child: SpinKitCircle(
          color: outline,
          size: 50,
        ),
      ),
    );
  }
}
