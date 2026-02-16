import 'package:flutter/material.dart';
import 'package:pinterest_clone/core/common/animated_background_image.dart';
import 'package:pinterest_clone/features/login/data/constants/login_constants.dart';


class LoginBackground extends StatelessWidget {
  const LoginBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Positioned(
          left: size.width * 0.4,
          top: size.height * 0.12,
          child: AnimatedBackgroundImage(
            imagePath: LoginConstants.backgroundImages[5],
            height: size.height * 0.14,
            width: size.width * 0.4,
            animationDurationMs: LoginConstants.animationDurations[5],
            scaleBegin: LoginConstants.scaleBegin,
            scaleEnd: LoginConstants.scaleEnd,
            startDelayMs: LoginConstants.staggerDelayMs * 5,
            borderRadius: LoginConstants.imageBorderRadius,
          ),
        ),
        Positioned(
          left: size.width * 0.3,
          top: size.height * 0.06,
          child: AnimatedBackgroundImage(
            imagePath: LoginConstants.backgroundImages[0],
            height: size.height * 0.28,
            width: size.width * 0.4,
            animationDurationMs: LoginConstants.animationDurations[0],
            scaleBegin: LoginConstants.scaleBegin,
            scaleEnd: LoginConstants.scaleEnd,
            startDelayMs: 0,
            borderRadius: LoginConstants.imageBorderRadius,
          ),
        ),
        Positioned(
          left: -15,
          top: -40,
          child: AnimatedBackgroundImage(
            imagePath: LoginConstants.backgroundImages[2],
            height: size.height * 0.2,
            width: size.width * 0.3,
            animationDurationMs: LoginConstants.animationDurations[2],
            scaleBegin: LoginConstants.scaleBegin,
            scaleEnd: LoginConstants.scaleEnd,
            startDelayMs: LoginConstants.staggerDelayMs * 2,
            borderRadius: LoginConstants.imageBorderRadius,
          ),
        ),
        Positioned(
          left: -35,
          top: size.height * 0.25,
          child: AnimatedBackgroundImage(
            imagePath: LoginConstants.backgroundImages[1],
            height: size.height * 0.2,
            width: size.width * 0.3,
            animationDurationMs: LoginConstants.animationDurations[1],
            scaleBegin: LoginConstants.scaleBegin,
            scaleEnd: LoginConstants.scaleEnd,
            startDelayMs: LoginConstants.staggerDelayMs,
            borderRadius: LoginConstants.imageBorderRadius,
          ),
        ),
        Positioned(
          right: -40,
          top: size.height * 0.25,
          child: AnimatedBackgroundImage(
            imagePath: LoginConstants.backgroundImages[3],
            height: size.height * 0.15,
            width: size.width * 0.25,
            animationDurationMs: LoginConstants.animationDurations[3],
            scaleBegin: LoginConstants.scaleBegin,
            scaleEnd: LoginConstants.scaleEnd,
            startDelayMs: LoginConstants.staggerDelayMs * 3,
            borderRadius: LoginConstants.imageBorderRadius,
          ),
        ),
        Positioned(
          right: -20,
          top: -80,
          child: AnimatedBackgroundImage(
            imagePath: LoginConstants.backgroundImages[4],
            height: size.height * 0.15,
            width: size.width * 0.25,
            animationDurationMs: LoginConstants.animationDurations[4],
            scaleBegin: LoginConstants.scaleBegin,
            scaleEnd: LoginConstants.scaleEnd,
            startDelayMs: LoginConstants.staggerDelayMs * 4,
            borderRadius: LoginConstants.imageBorderRadius,
          ),
        ),
      ],
    );
  }
}
