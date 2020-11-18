import "package:flutter/material.dart";

import "package:decameron/mock.dart" as mock;
import "package:decameron/widgets.dart";

/// The home page for the Decameron project. 
class HomePage extends StatelessWidget {
	@override
	Widget build(BuildContext context) => Scaffold(
		body: StorySpawner(mock.stories),
	);
}
