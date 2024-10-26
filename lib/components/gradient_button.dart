import 'package:flutter/material.dart';
import 'package:horizon/constants/index.dart';

class GradientButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final double? width;

  const GradientButton({
    super.key,
    required this.onTap,
    required this.text,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        height: 50,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [black, white],
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: white,
            ),
          ),
        ),
      ),
    );
  }
}
