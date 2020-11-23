import "package:flutter/material.dart";

import "package:decameron/widgets.dart";
import "package:decameron/models.dart";

/// The home page for the Decameron project. 
class HomePage extends StatelessWidget {
	@override
	Widget build(BuildContext context) => Scaffold(
		body: ModelListener<Stories>(
			model: () => Models.instance.stories,
			builder: (BuildContext context, Stories stories, Widget child) => 
				StorySpawner(stories.randomStories),
		)
	);
}
