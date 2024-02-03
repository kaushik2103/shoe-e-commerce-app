import 'package:ecommerce/colors.dart';
import 'package:ecommerce/views/shared/appstyle.dart';
import 'package:flutter/material.dart';

class checkButton extends StatelessWidget {
  const checkButton({super.key, required this.onTap, required this.label});

  final void Function()? onTap;
  final label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          decoration: const BoxDecoration(
              color: Color(kPrimaryColor),
              borderRadius: BorderRadius.all(Radius.circular(12))),
          height: 44,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Center(
            child: Text(
              "$label",
              style: appstyle(18, Colors.white, FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}
