import "package:flutter/material.dart";
import "package:decameron/models.dart";

class UserPage extends StatelessWidget {
	@override
	Widget build(BuildContext context) => Scaffold(
		appBar: AppBar(title: const Text("User profile")),
		body: Center(
			child: Column(
				children: [
					const SizedBox(height: 10),
					Text(
						"Welcome, ${Models.instance.user.author.name}",
						style: Theme.of(context).textTheme.headline4,
					),
					const SizedBox(height: 50),
					// Text("Here are your stories"),
				]
			)
		)
	);
}

class StoryTile extends StatelessWidget {
	@override
	Widget build(BuildContext context) => ListTile();
}

