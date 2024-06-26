import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:feedback_fusion/utils/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController scaleController;
  late Animation<double> scaleAnimation;
  bool isAnimating = false;

  startTime() {
    return Timer(const Duration(seconds: 3), () {
      setState(() {
        isAnimating = true;
      });

      scaleController.forward();
    });
  }

  @override
  void initState() {
    super.initState();
    scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Timer(
            const Duration(milliseconds: 300),
            () {},
          );
        }
      });
    scaleAnimation = Tween<double>(begin: 0.0, end: 15).animate(scaleController);

    startTime();
  }

  @override
  void dispose() {
    scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.blue,
        body: Center(
          child: _splashbody(),
        ));
  }

  Widget _splashbody() {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Center(
              child: AvatarGlow(
                glowRadiusFactor: 1.8,
                glowColor: Colors.blue,
                glowShape: BoxShape.circle,
                duration: const Duration(milliseconds: 1000),
                repeat: true,
                glowCount: 2,
                curve: Curves.easeOutQuad,
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: isAnimating
                      ? AnimatedBuilder(
                          animation: scaleAnimation,
                          builder: (c, child) => Transform.scale(
                            scale: scaleAnimation.value,
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        )
                      : const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 40,
                        ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            isAnimating
                ? Container()
                : Text(
                    GlobalConfiguration().getValue<String>('appName'),
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
