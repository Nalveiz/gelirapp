import 'package:flutter/material.dart';

class LavaLampLoading extends StatefulWidget {
  const LavaLampLoading({super.key});

  @override
  State<LavaLampLoading> createState() => _LavaLampLoadingState();
}

class _LavaLampLoadingState extends State<LavaLampLoading> with TickerProviderStateMixin {
  late final List<AnimationController> controllers;
  late final List<Animation<double>> animations;
  final List<int> durations = [5000, 3000, 4000, 6000];

  @override
  void initState() {
    super.initState();

    controllers = List.generate(
      4,
      (i) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: durations[i]),
      )..repeat(reverse: true),
    );

    animations = controllers.map((controller) {
      return Tween<double>(begin: 0, end: 80).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();
  }

  @override
  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Stack(
        children: List.generate(4, (index) {
          return AnimatedBuilder(
            animation: animations[index],
            builder: (context, child) {
              return Positioned(
                top: animations[index].value,
                left: [15.0, 1.0, 30.0, 20.0][index],
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: _bubbleColors(index),
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  List<Color> _bubbleColors(int index) {
    switch (index) {
      case 0:
        return [Color(0xffe64980), Color(0xffff8787)];
      case 1:
        return [Color(0xff82c91e), Color(0xff3bc9db)];
      case 2:
        return [Color(0xff7950f2), Color(0xfff783ac)];
      case 3:
        return [Color(0xff4481eb), Color(0xff04befe)];
      default:
        return [Colors.white, Colors.grey];
    }
  }
}
