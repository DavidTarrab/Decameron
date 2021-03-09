import "package:flutter/material.dart";

import "package:decameron/data.dart";
import "package:decameron/models.dart";

import "story.dart";

class UserPage extends StatefulWidget {
	static MaterialPageRoute getRoute({Author author, String uid}) => 
		MaterialPageRoute(
			builder: (_) => UserPage(author: author, uid: uid), 
			settings: RouteSettings(name: "author/${author?.uid ?? uid}"),
		);

	final Author author;
	final String uid;
	const UserPage({this.author, this.uid});

	@override 
	UserPageState createState() => UserPageState();
}

class UserPageState extends State<UserPage> {
	Author author;
	Future<List<Story>> storiesFuture;

	@override
	void initState() {
		super.initState();
		author = widget.author;
		storiesFuture = init();
	}

	Future<List<Story>> init() async {
		final Stories model = Models.instance.stories;
		final Author trueAuthor = widget.author ?? await model.getAuthor(widget.uid);
		setState(() => author = trueAuthor);
		return model.getStoriesByAuthor(author);
	}

	@override
	Widget build(BuildContext context) => Scaffold(
		appBar: AppBar(title: const Text("User profile")),
		body: Center(
			child: FutureBuilder<List<Story>>(
				future: storiesFuture,
				builder: (_, AsyncSnapshot snapshot) => !snapshot.hasData
					? author == null
						? snapshot.hasError
							? const Text("No author with this ID. Check the URL for typos")
							: const Text("Locating author...")
						: Text("Loading stories for $author...")
					: snapshot.data.isEmpty 
						? Text("No stories found for $author")
						: ListView(
							padding: const EdgeInsets.all(20),
							children: [
								Text(
									"Stories by $author:", 
									style: Theme.of(context).textTheme.headline5,
								),
								const SizedBox(height: 20),
								for (final Story story in snapshot.data)
									AuthoredStoryTile(story)
							]
						)
			)
		)
	);
}

class AuthoredStoryTile extends StatelessWidget {
	final Story story;
	const AuthoredStoryTile(this.story);

	@override
	Widget build(BuildContext context) => ListTile(
		title: Text(story.title),
		subtitle: Text(story.firstSentence),
		onTap: () => Navigator.of(context).push(
			MaterialPageRoute(builder: (_) => StoryPage(story))
		)
	);
}
