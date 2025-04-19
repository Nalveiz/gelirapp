import 'package:flutter/material.dart';

class FancySpinner extends StatefulWidget {
  const FancySpinner({super.key});

  @override
  State<FancySpinner> createState() => _FancySpinnerState();
}

class _FancySpinnerState extends State<FancySpinner> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    )..repeat(); // infinite rotate
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Rotating outer circle
          RotationTransition(
            turns: _controller,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade800, width: 2),
                boxShadow: const [
                  BoxShadow(color: Color(0xff6359f8), offset: Offset(-10, -10), blurRadius: 10),
                  BoxShadow(color: Color(0xff9c32e2), offset: Offset(0, -10), blurRadius: 10),
                  BoxShadow(color: Color(0xfff36896), offset: Offset(10, -10), blurRadius: 10),
                  BoxShadow(color: Color(0xffff0b0b), offset: Offset(10, 0), blurRadius: 10),
                  BoxShadow(color: Color(0xffff5500), offset: Offset(10, 10), blurRadius: 10),
                  BoxShadow(color: Color(0xffff9500), offset: Offset(0, 10), blurRadius: 10),
                  BoxShadow(color: Color(0xffffb700), offset: Offset(-10, 10), blurRadius: 10),
                ],
              ),
            ),
          ),

          // Inner circle
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              border: Border.all(color: Colors.grey.shade800, width: 2),
            ),
          ),
        ],
      ),
    );
  }
}
