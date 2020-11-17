import "dart:async";
import "package:flutter/material.dart";

import "story_sentence.dart";

class StorySpawner extends StatefulWidget {
	static const Duration delay = Duration(seconds: 10);

	final List<String> stories;

	StorySpawner(this.stories);

	@override
	StorySpawnerState createState() => StorySpawnerState();
}

class StorySpawnerState extends State<StorySpawner> {
	final List<String> sentences = [];
	Timer timer;
	int index = 0;

	@override
	void initState() {
		super.initState();
		timer = Timer.periodic(StorySpawner.delay, spawnStory);
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

	void spawnStory([Timer timer]) {
		setState(() => sentences.add(widget.stories [index]));
		if (sentences.length > 3) {
			sentences.removeAt(0);
		}
		if (++index == widget.stories.length) {
			index = 0;
		}
	}
}
