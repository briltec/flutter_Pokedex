import 'package:flutter/material.dart';

class SlidingUpPanel extends StatefulWidget {
  const SlidingUpPanel({
    Key key,
    @required this.child,
    @required this.minHeight,
    @required this.maxHeight,
    @required this.controller,
  }) : super(key: key);

  final Widget child;
  final AnimationController controller;
  final double maxHeight;
  final double minHeight;

  @override
  State<StatefulWidget> createState() => _SlidingUpPanelState();
}

class _SlidingUpPanelState extends State<SlidingUpPanel> {
  @override
  void dispose() {
    _controller.removeListener(updateLayout);

    super.dispose();
  }

  @override
  void initState() {
    _controller.addListener(updateLayout);

    super.initState();
  }

  AnimationController get _controller => widget.controller;

  updateLayout() {
    setState(() {
      // Refresh the layout
    });
  }

  void _onDrag(DragUpdateDetails details) {
    _controller.value -= details.primaryDelta / (widget.maxHeight - widget.minHeight);
  }

  void _onDragEnd(DragEndDetails details) {
    double minFlingVelocity = (widget.maxHeight - widget.minHeight) / 4;

    if (_controller.isAnimating) return;

    if (details.velocity.pixelsPerSecond.dy.abs() >= minFlingVelocity) {
      double visualVelocity =
          -details.velocity.pixelsPerSecond.dy / (widget.maxHeight - widget.minHeight);

      _controller.fling(velocity: visualVelocity);

      return;
    }

    if (_controller.value > 0.5) {
      _open();
    } else {
      _close();
    }
  }

  void _close() {
    _controller.fling(velocity: -1.0);
  }

  //open the panel
  void _open() {
    _controller.fling(velocity: 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onVerticalDragUpdate: _onDrag,
        onVerticalDragEnd: _onDragEnd,
        child: Container(
          height: _controller.value * (widget.maxHeight - widget.minHeight) + widget.minHeight,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0.0,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  height: widget.maxHeight,
                  child: widget.child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
