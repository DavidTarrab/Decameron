import "dart:async";
import "package:flutter/material.dart";

import "package:decameron/data.dart";
import "story_sentence.dart";

/// Spawns [StorySentence] widgets over a fireplace. 
class StorySpawner extends StatefulWidget {
	/// How long to wait between spawning. 
	static const Duration delay = Duration(seconds: 10);

	/// The list of stories to spawn. 
	final List<Story> stories;

	/// Creates a widget to manage [StorySentence]s.
	const StorySpawner(this.stories);

	@override
	StorySpawnerState createState() => StorySpawnerState();
}

/// A state for [StorySpawner]. 
/// 
/// This class adds the stories to the fireplace one by one. 
class StorySpawnerState extends State<StorySpawner> {
	/// The sentences currently being shown. 
	final List<String> sentences = [];

	/// A timer that waits for one [StorySentence] before spawning another. 
	Timer timer;

	/// The index of [StorySpawner.stories] to spawn next. 
	int index = 0;

	@override
	void initState() {
		super.initState();
		if (widget.stories.isNotEmpty) {
			timer = Timer.periodic(StorySpawner.delay, spawnStory);
		}
	}

	@override 
	void dispose() {
		timer.cancel();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) => Stack(
		children: [
			Center(
				child: Image.network(
					"https://media3.giphy.com/media/3o6ZsWmtAVZFltTWVi/giphy.gif",
					scale: 0.5,
				)
			),
			for (final String sentence in sentences)
				StorySentence(sentence)
		]
	);

	/// Spawns a new [StorySentence] on top of the fireplace. 
	/// 
	/// Also deletes a story when it is no longer visible.  
	void spawnStory([Timer timer]) {
		setState(() => sentences.add(widget.stories [index].firstSentence));
		if (sentences.length > 3) {  // only two [StorySentence]s are visible at once
			sentences.removeAt(0);  // remove the oldest widget
		}
		if (++index == widget.stories.length) {
			index = 0;
		}
	}
}
