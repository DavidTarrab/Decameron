import 'package:flutter/material.dart';
import "dart:math";
import "dart:async"; 

class SmokeAnim extends StatefulWidget {

  final Alignment startAlignment;
  final Alignment endAlignment;
  final int startDelay;
  final int endDelay;
  final int midDelay;
  final int fadeInDuration;
  final int fadeOutDuration;
  final Text fadeText;

    SmokeAnim({
    	Key key,
    	@required this.startAlignment,
    	@required this.endAlignment,
      @required this.startDelay,
      @required this.endDelay,
      @required this.midDelay,
      @required this.fadeInDuration,
      @required this.fadeOutDuration,
      @required this.fadeText,
    	}) : super(key: key);

  @override
  _SmokeAnimState createState() => _SmokeAnimState();
}

/// This is the private State class that goes with SmokeAnim.
/// AnimationControllers can be created with `vsync: this` because of TickerProviderStateMixin.
class _SmokeAnimState extends State<SmokeAnim>
    with TickerProviderStateMixin {

  double opacityLevel = 0.0;

  void _fadeIn() {
    setState(() => opacityLevel = 1.0);
  }

  void _fadeOut() {
    setState(() => opacityLevel = 0.0);
  }

  void _fade() {
    Timer(Duration(milliseconds: widget.startDelay), _fadeIn);
    Timer(Duration(milliseconds: widget.midDelay + widget.startDelay + widget.fadeInDuration), _fadeOut);
  }

  Alignment alignment;

  Random random = new Random();

  AnimationController _controller;

  void go() {
    setState(() => alignment = widget.endAlignment);
  }

  void come() {
    setState(() => alignment = widget.startAlignment);
  }

  void goAndCome() {
    Timer(Duration(milliseconds: widget.startDelay - 300), go);
    Timer(Duration(milliseconds: widget.midDelay + widget.startDelay + widget.fadeInDuration - 200), come);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _fade();
    come();
    goAndCome();
    //add end delay once the loop works
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedAlign(
    alignment: alignment,
    curve: Curves.ease,
    duration: const Duration(seconds: 2),
    child: AnimatedOpacity(
      opacity: opacityLevel,
      duration: Duration(seconds: widget.fadeInDuration),
      child: widget.fadeText,
    )
  );
}