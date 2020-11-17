import "dart:math";

import "package:flutter/material.dart";

class StorySentence extends StatefulWidget {
	static const Duration animationDuration = Duration(seconds: 15);
	static const Duration fadeInDuration = Duration(seconds: 3);
	static final Tween<double> letterSpacingTween = Tween(begin: -2, end: 4);
	static const double maxRotation = pi / 6;  // 30 degrees

	final String sentence;

	StorySentence(this.sentence) : super(key: ValueKey(sentence));

	@override
	StorySentenceState createState() => StorySentenceState();
}

class StorySentenceState extends State<StorySentence> with TickerProviderStateMixin {
	static final Random random = Random();

	AnimationController controller;
	AnimationController initialController;

	Animation<Alignment> alignment; 
	Animation<double> angle;
	Animation<double> letterSpacing;
	Animation<double> opacity;

	void initControllers() {
		controller = AnimationController(
			duration: StorySentence.animationDuration,
			vsync: this, 
		)
			..forward()
			..addListener(listener);

		initialController = AnimationController(
			duration: StorySentence.fadeInDuration, 
			vsync: this,
		)
			..forward()
			..addListener(listener)
			..addStatusListener(initialListener);  // so we can make it fade back out
	}

	Animation<T> getAnimation<T>({
		@required Animation controller,
		@required Tween<T> tween,
		@required Curve curve, 
	}) => tween.animate(CurvedAnimation(parent: controller, curve: curve));

	AlignmentTween getAlignmentTween()  {
		final bool direction = random.nextBool();
		final double randomOffsetX = random.nextDouble();
		return AlignmentTween(
			begin: Alignment.center,
			end: Alignment(direction ? randomOffsetX : -randomOffsetX, -0.85),
		);
	}

	@override
	void initState() {
		super.initState();
		initControllers();
		// Need this value for [angle].
		final AlignmentTween alignmentTween = getAlignmentTween();
		final double rotation = StorySentence.maxRotation * alignmentTween.end.x;
		alignment = getAnimation(
			controller: controller,
			tween: alignmentTween,
			curve: Curves.ease,
		);
		angle = getAnimation(
			controller: controller,
			tween: Tween(begin: 0, end: rotation),
			curve: Curves.easeInQuad,
		);
		letterSpacing = getAnimation(
			controller: controller,
			tween: StorySentence.letterSpacingTween,
			curve: Curves.slowMiddle,
		);
		opacity = getAnimation(
			controller: initialController,
			tween: Tween(begin: 0, end: 1),
			curve: Curves.linear,
		);
	}

	void listener() => setState(() {});

	void initialListener(AnimationStatus status) {
		if (status == AnimationStatus.completed) {
			initialController.duration = StorySentence.animationDuration - StorySentence.fadeInDuration;
			initialController.reverse();
		}
	}

	@override
	void dispose() {
		initialController
			..removeListener(listener)
			..removeStatusListener(initialListener)
			..dispose();
		controller
			..removeListener(listener)
			..dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) => Align(
		alignment: alignment.value,
		child: Opacity(
			opacity: opacity.value,
			child: Transform.rotate(
				angle: angle.value,
				child: Text(
					widget.sentence, 
					textScaleFactor: 1.2,
					style: TextStyle(
						color: Colors.white, 
						letterSpacing: letterSpacing.value
					),
				)
			),
		)
	);
}
