import 'package:flutter/material.dart';

class BottomDrawerGestureDetector extends StatelessWidget {
  static const int AXIS_X = 0;
  static const int AXIS_Y = 1;
  static const int AXIS_BOTH = 2;

  final int axis;
  final Widget child;
  final double velocity;
  final Function onSwipeUp;
  final Function onSwipeDown;
  final Function onSwipeLeft;
  final Function onSwipeRight;

  BottomDrawerGestureDetector(
      {@required this.child,
      @required this.velocity,
      this.onSwipeLeft,
      this.onSwipeRight,
      this.onSwipeUp,
      this.onSwipeDown,
      @required this.axis});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onPanEnd: (details) {
          Offset v = details.velocity.pixelsPerSecond;

          try {
            if ((axis == AXIS_Y) || axis == AXIS_BOTH) {
              if (v.dy > velocity) {
                onSwipeDown();
              } else if (v.dy < -velocity) {
                onSwipeUp();
              }
            }
            if ((axis == AXIS_X) || axis == AXIS_BOTH) {
              if (v.dx > velocity) {
                onSwipeRight();
              } else if (v.dx < -velocity) {
                onSwipeLeft();
              }
            }
          } catch (e) {
            print(e);
          }
        },
        child: child);
  }
}
