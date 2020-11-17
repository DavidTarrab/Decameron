import "package:flutter/material.dart";

import "package:decameron/mock.dart" as mock;
import "package:decameron/widgets.dart";

class HomePage extends StatelessWidget {
	@override
	Widget build(BuildContext context) => Scaffold(
		body: StorySpawner(mock.stories),
	);
}
