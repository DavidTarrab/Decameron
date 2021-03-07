import "package:flutter/material.dart";

class AboutPage extends StatelessWidget {
	@override
	Widget build(BuildContext context) => Scaffold(
		appBar: AppBar(title: const Text("About the Decameron")),
		body: Center(
			child: FractionallySizedBox(
				widthFactor: 2/3,
				child: Column(
					children: [
						const Spacer(),
						Text(
							// ignore: lines_longer_than_80_chars
							"Storytelling makes us human. Stories capture the most powerful and contradictory feelings that we experience. When we tell a story, we become creators of the world. We surprise ourselves with what we surrender, what we shape, and what we share. We become comrades talking around a fire, a place of warmth and comfort. We whisper in each other’s ears.",
							style: Theme.of(context).textTheme.headline4
						),
						const SizedBox(height: 50),
						Text(
							// ignore: lines_longer_than_80_chars
							"As the corona virus spread and the world shut down, the Ramaz community created By the Campfire: Twice-Told Tales, inspired by the Decameron, as a way to come together through storytelling in all its forms.",
							style: Theme.of(context).textTheme.headline5,
						),
						const SizedBox(height: 25),
						Text(
							// ignore: lines_longer_than_80_chars
							"This website provides a space for sharing those stories, and listening to those of others. Click on a story by the campfire to hear it being shared, or record yourself telling your own.",
							style: Theme.of(context).textTheme.headline5,
						),
						const Spacer(),
					]
				)
			)
		)
	);
}
