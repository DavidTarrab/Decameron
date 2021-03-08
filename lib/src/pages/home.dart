import "dart:async";

import "package:flutter/material.dart";

import "package:decameron/data.dart";
import "package:decameron/models.dart";
import "package:decameron/pages.dart";
import "package:decameron/widgets.dart";

/// The home page for the Decameron project. 
class HomePage extends StatefulWidget {
	/// How long to wait between spawning. 
	static const Duration delay = Duration(seconds: 10);

	@override
	HomePageState createState() => HomePageState();
}

/// Controls the fireplace animation. 
class HomePageState extends State<HomePage> {
	/// The stories currently being shown. 
	final List<Story> stories = [];

	/// The index of [Stories.randomStories] to spawn next. 
	int index = 0;

	/// The data model with all the stories.
	Stories model;

	/// Rebuilds the widget tree when [model] updates. 
	void listener() => setState(() {});

	@override
	void initState() {
		super.initState();
		model = Models.instance.stories..addListener(listener);
		spawnStory();
	}

	@override 
	void dispose() {
		model.removeListener(listener);
		super.dispose();
	}

	@override
	Widget build(BuildContext context) => Scaffold(
		body: Stack(
			children: [
				UserPanel(),
				Container(
					alignment: Alignment.bottomRight,
					padding: const EdgeInsets.all(50),
					child: TextButton(
						child: const Text("About", textScaleFactor: 1.2),
						onPressed: () => Navigator.of(context).pushNamed(Routes.about),
					),
				),
				Center(
					child: Image.network(
						"https://media3.giphy.com/media/3o6ZsWmtAVZFltTWVi/giphy.gif",
						scale: 0.5,
					)
				),
				Align(
					alignment: const Alignment(0, 0.85),
					child: Builder(
						builder: (BuildContext context) => TextButton(
							onPressed: () => uploadStory(context),
							child: Text(
								"Tell your own story", 
								style: Theme.of(context).textTheme.headline5
							),
						)
					)
				),
				for (final Story story in stories)
					StorySentence(story, spawnStory)
			]
		)
	);

	/// Spawns a new [StorySentence] on top of the fireplace. 
	/// 
	/// Also deletes a story when it is no longer visible.  
	void spawnStory() {
		if (model.randomStories.isEmpty) {
			return;
		}
		setState(() => stories.add(model.randomStories [index]));
		if (stories.length > 3) {  // only two [StorySentence]s are visible at once
			stories.removeAt(0);  // remove the oldest widget
		}
		if (++index == model.randomStories.length) {
			index = 0;
		}
	}

	/// Directs the user to upload a story, signing them in if necessary. 
	/// 
	/// Needs a [BuildContext] underneath the scaffold. 
	Future<void> uploadStory(BuildContext context) async {
		if (!Models.instance.user.isSignedIn) {
			return Scaffold.of(context).showSnackBar(
				const SnackBar(content: Text("You must be signed in to upload a story")),
			);
		}
		await Navigator.of(context).pushNamed(Routes.upload);
	}
}
