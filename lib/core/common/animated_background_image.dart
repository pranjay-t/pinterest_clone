import 'package:flutter/material.dart';
class AnimatedBackgroundImage extends StatefulWidget {
  final String imagePath;
  final double height;
  final double width;
  final int animationDurationMs;
  final double scaleBegin;
  final double scaleEnd;
  final int startDelayMs;
  final double borderRadius;

  const AnimatedBackgroundImage({
    super.key,
    required this.imagePath,
    required this.height,
    required this.width,
    this.animationDurationMs = 2000,
    this.scaleBegin = 1.0,
    this.scaleEnd = 0.9,
    this.startDelayMs = 0,
    this.borderRadius = 20.0,
  });

  @override
  State<AnimatedBackgroundImage> createState() =>
      _AnimatedBackgroundImageState();
}

class _AnimatedBackgroundImageState extends State<AnimatedBackgroundImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.animationDurationMs),
    );

    _scaleAnimation = Tween<double>(
      begin: widget.scaleBegin,
      end: widget.scaleEnd,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    if (widget.startDelayMs > 0) {
      Future.delayed(Duration(milliseconds: widget.startDelayMs), () {
        if (mounted) {
          _controller.repeat(reverse: true);
        }
      });
    } else {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: Image.asset(
          widget.imagePath,
          height: widget.height,
          width: widget.width,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
