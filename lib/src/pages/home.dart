import "dart:async";

import "package:flutter/material.dart";

import "package:decameron/widgets.dart";
import "package:decameron/models.dart";
import "package:decameron/pages.dart";

/// The home page for the Decameron project. 
class HomePage extends StatefulWidget {
	/// How long to wait between spawning. 
	static const Duration delay = Duration(seconds: 10);

	@override
	HomePageState createState() => HomePageState();
}

/// Controls the fireplace animation. 
class HomePageState extends State<HomePage> {
	/// The sentences currently being shown. 
	final List<String> sentences = [];

	/// A timer that waits for one [StorySentence] before spawning another. 
	Timer timer;

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
		timer = Timer.periodic(HomePage.delay, spawnStory);
	}

	@override 
	void dispose() {
		model.removeListener(listener);
		timer.cancel();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) => Scaffold(
		body: ModelListener<Stories>(
			model: () => model,
			builder: (_, Stories stories, __) => Stack(
				children: [
					Container(
						alignment: Alignment.topLeft,
						padding: const EdgeInsets.all(10),
						child: Container(
							decoration: BoxDecoration(
								border: Border.all(color: Colors.white),
								borderRadius: BorderRadius.circular(10),
							),
							child: UserTile(),
						)
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
								onPressed: uploadStory,
								child: Text(
									"Tell your own story", 
									style: Theme.of(context).textTheme.headline5
								),
							)
						)
					),
					for (final String sentence in sentences)
						StorySentence(sentence)
				]
			)
		)
	);

	/// Spawns a new [StorySentence] on top of the fireplace. 
	/// 
	/// Also deletes a story when it is no longer visible.  
	void spawnStory([Timer timer]) {
		if (model.randomStories.isEmpty) {
			return;
		}
		setState(() => sentences.add(model.randomStories [index].firstSentence));
		if (sentences.length > 3) {  // only two [StorySentence]s are visible at once
			sentences.removeAt(0);  // remove the oldest widget
		}
		if (++index == model.randomStories.length) {
			index = 0;
		}
	}

	/// Directs the user to upload a story, signing them in if necessary. 
	Future<void> uploadStory() async {
		if (!Models.instance.user.isSignedIn) {
			return Scaffold.of(context).showSnackBar(
				const SnackBar(content: Text("You must be signed in to upload a story")),
			);
		}
		await Navigator.of(context).pushNamed(Routes.upload);
	}
}
