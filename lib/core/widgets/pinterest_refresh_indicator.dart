import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';

class PinterestRefreshIndicator extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const PinterestRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  State<PinterestRefreshIndicator> createState() =>
      _PinterestRefreshIndicatorState();
}

class _PinterestRefreshIndicatorState extends State<PinterestRefreshIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomRefreshIndicator(
      onRefresh: widget.onRefresh,
      builder:
          (BuildContext context, Widget child, IndicatorController controller) {
            return Stack(
              alignment: Alignment.topCenter,
              children: [
                AnimatedBuilder(
                  animation: controller,
                  builder: (context, _) {
                    return Transform.translate(
                      offset: Offset(0, 120.0 * controller.value),
                      child: child,
                    );
                  },
                ),
                if (!controller.isIdle)
                  Positioned(
                    top: (100.0 * controller.value) / 2 - 20,
                    child: AnimatedBuilder(
                      animation: controller,
                      builder: (context, _) {
                        return _IndicatorSpinner(
                          controller: controller,
                          isDark: isDark,
                        );
                      },
                    ),
                  ),
              ],
            );
          },
      child: widget.child,
    );
  }
}

class _IndicatorSpinner extends StatefulWidget {
  final IndicatorController controller;
  final bool isDark;

  const _IndicatorSpinner({
    required this.controller,
    required this.isDark,
  });

  @override
  State<_IndicatorSpinner> createState() => _IndicatorSpinnerState();
}

class _IndicatorSpinnerState extends State<_IndicatorSpinner> {
  double _rotation = 0.0;
  double _prevValue = 0.0;

  @override
  void initState() {
    super.initState();
    _prevValue = widget.controller.value;
    _rotation = _prevValue * 2 * 3.14159;
  }

  @override
  void didUpdateWidget(_IndicatorSpinner oldWidget) {
    super.didUpdateWidget(oldWidget);
    final current = widget.controller.value;
    
    if (widget.controller.isIdle && current == 0.0) {
      _rotation = 0.0;
      _prevValue = 0.0;
    } else {
      final delta = current - _prevValue;
      _rotation += delta.abs() * 2 * 3.14159;
      _prevValue = current;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: widget.controller.isDragging
          ? widget.controller.value.clamp(0.0, 1.0)
          : 1.0,
      child: Transform.rotate(
        angle: _rotation,
        child: Image.asset('assets/logo/loader.png', height: 80),
      ),
    );
  }
}
