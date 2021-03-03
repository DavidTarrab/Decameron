import "package:flutter/material.dart";

import "package:decameron/data.dart";
import "package:decameron/models.dart";
import "package:decameron/pages.dart";

import "story.dart";

class ModeratorPage extends StatefulWidget {
	@override
	ModeratorPageState createState() => ModeratorPageState();
}

class ModeratorPageState extends State<ModeratorPage> {
	Moderator model;

	void listener() => setState(() {});

	@override
	void initState() {
		super.initState();
		model = Models.instance.moderator..addListener(listener);
	}

	@override
	void dispose() {
		model.removeListener(listener);
		super.dispose();
	}

	@override
	Widget build(BuildContext context) => Scaffold(
		appBar: AppBar(title: const Text("Moderation")),
		body: model.pendingStories.isEmpty
			? const Center(child: Text("No stories are pending approval."))
			: ListView(
				children: [
					for (final Story story in model.pendingStories)
						UnapprovedStoryWidget(story)
				]
			)
	);
}

class UnapprovedStoryWidget extends StatelessWidget {
	final Story story;
	const UnapprovedStoryWidget(this.story);

	@override
	Widget build(BuildContext context) => ListTile(
		title: Text(story.title),
		subtitle: Text(story.author.name),
		onTap: () => Navigator.of(context).push(
			MaterialPageRoute(
				builder: (_) => StoryPage(story)
			)
		)
	);
}

