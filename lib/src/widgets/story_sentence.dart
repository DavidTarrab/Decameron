import "dart:math";

import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:decameron/data.dart";
import "package:decameron/pages.dart";

/// Presents the first sentence of a story. 
/// 
/// The first sentence comes out of a picture of a fireplace as if it were smoke
/// turning into text, and then dissipating into the air. 
/// 
/// To create this affect, we animate five properties: 
/// 
/// 1. The position of the text, as it gets carried away by the wind.
/// 2. The opacity of the text, as it manifests and then dissipates.
/// 3. The rotation of the text, as the wind pushes it around, 
/// 4. The spacing between the letters, as the text dissipates. 
/// 5. The font size, as the text dissipates. 
class StorySentence extends StatefulWidget {
	/// How long the entire animation should last. 
	static const Duration animationDuration = Duration(seconds: 20);

	/// How long it should take for the text to become visible. 
	static const Duration fadeInDuration = Duration(seconds: 5);

	/// How the text should space itself over time. 
	static final Tween<double> letterSpacingTween = Tween(begin: -2, end: 4);

	/// How far the text should rotate when the wind is strongest. 
	static const double maxRotation = pi / 6;  // 30 degrees

	/// The story to display. 
	final Story story;

	final VoidCallback callback;

	/// Animates the first sentence of a story. 
	/// 
	/// The key is set to the sentence, so that these widgets can be removed 
	/// from the widget tree without causing issues. 
	StorySentence(this.story, this.callback) : 
		super(key: ValueKey(story.firstSentence));

	@override
	StorySentenceState createState() => StorySentenceState();
}

/// The state for a [StorySentence]. 
/// 
/// This class is responsible for animating all the different properties. 
///
/// Use [getAnimation] to animate a property. 
class StorySentenceState extends State<StorySentence> 
	with TickerProviderStateMixin {
	/// Provides random data. 
	static final Random random = Random();

	/// The animation controller for the entire animation. 
	AnimationController controller;

	/// The animation controller for the initial animation. 
	/// 
	/// The initial animation controls the text as it manifests into smoke, ie, 
	/// before it starts dissipating. 
	AnimationController initialController;

	/// Controls the position of the text. 
	Animation<Alignment> alignment; 

	/// Controls the rotation of the text. 
	Animation<double> angle;

	/// Controls the spacing of the text. 
	Animation<double> letterSpacing;

	/// Controls the opacity of the text. 
	Animation<double> opacity;

	bool didCallCallback = false;

	/// Initializes the animation controllers. 
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
			..addListener(basicListener)
			..addStatusListener(initialListener);
	}

	/// Creates an animation from a controller, tween and curve. 
	Animation<T> getAnimation<T>({
		@required Animation controller,
		@required Tween<T> tween,
		@required Curve curve, 
	}) => tween.animate(CurvedAnimation(parent: controller, curve: curve));

	@override
	void initState() {
		super.initState();
		initControllers();
		// Chooses an x coordinate from -1 to 1.
		final double offsetX = 2 * random.nextDouble() - 1;
		alignment = getAnimation(
			controller: controller,
			tween: AlignmentTween(
				begin: Alignment.center,
				end: Alignment(offsetX, -0.85),
			),
			curve: Curves.ease,
		);
		angle = getAnimation(
			controller: controller,
			tween: Tween(begin: 0, end: StorySentence.maxRotation * offsetX),
			curve: Curves.ease,
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

	void listener() {
		setState(() {});
		if (controller.value >= 0.5 && !didCallCallback) {
			didCallCallback = true;
			widget.callback();
		}
	}

	/// Rebuilds the widget on new animation ticks. 
	void basicListener() {
		setState(() {});
	}

	/// Listens for when [initialController] finishes, then reverses it. 
	void initialListener(AnimationStatus status) {
		if (status == AnimationStatus.completed) {
			initialController
				..duration = StorySentence.animationDuration - StorySentence.fadeInDuration
				..reverse();
		}
	}

	@override
	void dispose() {
		initialController
			..removeListener(basicListener)
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
				child: MouseRegion(
				  cursor: SystemMouseCursors.click,
			    child: GestureDetector(
						onTap: launchStory,
						child: Text(
							"\n\n    ${widget.story.firstSentence}    \n\n", 
							textScaleFactor: 1.2,
							style: TextStyle(
								color: const Color(0xffe25822),
								letterSpacing: letterSpacing.value,
								fontFamily: "Josefin Sans", 
								fontWeight: FontWeight.w400
							),
						)
					)
				)
			),
		)
	);

	/// Opens the story's full page. 
	void launchStory() => Navigator.of(context).push(
		MaterialPageRoute(
			builder: (_) => StoryPage(widget.story)
		)
	);
}
