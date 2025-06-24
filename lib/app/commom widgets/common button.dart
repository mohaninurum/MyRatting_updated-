import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final TextStyle textStyle;
  final double width;
  final double height;

  const CommonButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.blue, // Default color
    this.textStyle = const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
    this.width = double.infinity,
    this.height = 50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          minimumSize: Size(width, height),
        ),
        onPressed: onPressed,
        child: Text(text, style: textStyle),
      ),
    );
  }
}
