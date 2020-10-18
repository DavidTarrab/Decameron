import 'package:flutter/material.dart';
import "dart:async"; 

class SmokeFade extends StatefulWidget {

  final int startDelay;
  final int endDelay;
  final int fadeInDuration;
  final int fadeOutDuration;
  final String fadeText;

  SmokeFade ({
    @required this.startDelay,
    @required this.endDelay,
    @required this.fadeInDuration,
    @required this.fadeOutDuration,
    @required this.fadeText,
  });

  @override
  createState() => SmokeFadeState();
}


class SmokeFadeState extends State<SmokeFade> {

  double opacityLevel = 0.0;

  void _fadeIn() {
    setState(() => opacityLevel = 1.0);
  }

  void _fadeOut() {
    setState(() => opacityLevel = 0.0);
  }

  void _fade() {
    Timer(Duration(seconds: widget.startDelay), _fadeIn);
    Timer(Duration(seconds: widget.endDelay + widget.startDelay + widget.fadeInDuration), _fadeOut);
  }

  @override
  void initState() {
    super.initState();
    _fade();
  }

  @override
  Widget build(BuildContext context) => AnimatedOpacity(
    opacity: opacityLevel,
    duration: Duration(seconds: widget.fadeInDuration),
    child: Text(widget.fadeText),
  );
}

// TODO: Recreate the below widget into a "SmokeAlign" that takes the following:
// - Widget child
// - Alignment startAlignment
// - Alignment endAlignment
// - Duration duration
// 
// The point is to have something like this: 
// Stack(
//   children: [
//     Align(
//       alignment: Alignment.center,
//       child: Fireplace(),
//     ),
//     SmokeAlign(
//       startAlignment: Alignment.center,
//       endAlignment: getRandomAlignment(),  // where the smoke ends up
//       child: SmokeFade(
//         startDelay : 2,
//         endDelay : 5, 
//         fadeInDuration : 1, 
//         fadeOutDuration : 8,
//         fadeText : 'story sentence',
//       )
//     )
//   ]
// )

class SmokeAnim extends StatefulWidget {
  SmokeAnim({Key key}) : super(key: key);

  @override
  _SmokeAnimState createState() => _SmokeAnimState();
}

/// This is the private State class that goes with SmokeAnim.
/// AnimationControllers can be created with `vsync: this` because of TickerProviderStateMixin.
class _SmokeAnimState extends State<SmokeAnim>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlignTransition(
    alignment: AlignmentTween(
      begin: Alignment(-1, -1),
      end: Alignment(1, 1),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.ease,
    )),
    child: FlutterLogo(),
  );
}