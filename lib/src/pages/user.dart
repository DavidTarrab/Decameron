import "package:flutter/material.dart";

import "package:decameron/data.dart";
import "package:decameron/models.dart";

class UserPage extends StatefulWidget {
	final Author author;
	const UserPage(this.author);

	@override 
	UserPageState createState() => UserPageState();
}

class UserPageState extends State<UserPage> {
	Future<List<Story>> storiesFuture;

	@override
	void initState() {
		super.initState();
		storiesFuture = Models.instance.stories.getStoriesByAuthor(widget.author);
	}

	@override
	Widget build(BuildContext context) => Scaffold(
		appBar: AppBar(title: const Text("User profile")),
		body: Center(
			child: FutureBuilder<List<Story>>(
				future: storiesFuture,
				builder: (_, AsyncSnapshot snapshot) => snapshot.hasData
					? Text("Loading stories for ${widget.author.name}")
					: ListView(
						children: [
							Text(
								"Stories for ${widget.author.name}", 
								style: Theme.of(context).textTheme.subtitle1,
							),
							for (final Story story in snapshot.data)
								StoryTile(story)
						]
					)
			)
		)
	);
}

class StoryTile extends StatelessWidget {
	final Story story;
	const StoryTile(this.story);

	@override
	Widget build(BuildContext context) => ListTile();
}
