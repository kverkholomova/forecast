import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CheckMarkIndicator extends StatefulWidget {
  final Widget child;

  const CheckMarkIndicator({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  _CheckMarkIndicatorState createState() => _CheckMarkIndicatorState();
}

class _CheckMarkIndicatorState extends State<CheckMarkIndicator>
    with SingleTickerProviderStateMixin {
  static const _indicatorSize = 200.0;

  /// Whether to render check mark instead of spinner
  bool _renderCompleteState = false;

  ScrollDirection prevScrollDirection = ScrollDirection.idle;

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      offsetToArmed: _indicatorSize,
      onRefresh: () => Future.delayed(const Duration(seconds: 2)),
      completeStateDuration: const Duration(seconds: 2),
      onStateChanged: (change) {
        /// set [_renderCompleteState] to true when controller.state become completed
        if (change.didChange(to: IndicatorState.complete)) {
          setState(() {
            _renderCompleteState = true;
          });

          /// set [_renderCompleteState] to false when controller.state become idle
        } else if (change.didChange(to: IndicatorState.idle)) {
          setState(() {
            _renderCompleteState = false;
          });
        }
      },
      builder: (
          BuildContext context,
          Widget child,
          IndicatorController controller,
          ) {
        return Stack(
          children: <Widget>[
            AnimatedBuilder(
              animation: controller,
              builder: (BuildContext context, Widget? _) {
                if (controller.scrollingDirection == ScrollDirection.reverse &&
                    prevScrollDirection == ScrollDirection.forward) {
                  controller.stopDrag();
                }
                prevScrollDirection = controller.scrollingDirection;
                final containerHeight = controller.value * _indicatorSize;
                return Container(
                  alignment: Alignment.center,
                  height: containerHeight,
                  child: OverflowBox(
                    maxHeight: 50,
                    minHeight: 40,
                    maxWidth: 50,
                    minWidth: 40,
                    alignment: Alignment.center,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _renderCompleteState
                            ? Colors.indigoAccent.withOpacity(0.7)
                            : Colors.black45,
                        shape: BoxShape.circle,
                      ),
                      child: _renderCompleteState
                          ? const Icon(
                        Icons.check,
                        color: Colors.white,
                      )
                          : SizedBox(
                        height: 40,
                        width: 40,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                          const AlwaysStoppedAnimation(Colors.white),
                          value:
                          controller.isDragging || controller.isArmed
                              ? controller.value.clamp(0.0, 1.0)
                              : null,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            AnimatedBuilder(
              builder: (context, _) {
                return Transform.translate(
                  offset: Offset(0.0, controller.value * _indicatorSize),
                  child: child,
                );
              },
              animation: controller,
            ),
          ],
        );
      },
      child: widget.child,
    );
  }
}