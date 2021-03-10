import "package:flutter/material.dart";

class AboutPage extends StatelessWidget {
	static const ImageProvider backgroundImage = 
		NetworkImage("https://wallpapercave.com/wp/aF12T0e.jpg");

	TextStyle getStyle(BuildContext context) => 
		Theme.of(context).textTheme.headline5
			.copyWith(fontFamily: "Josefin Sans", height: 1.2);

	@override
	Widget build(BuildContext context) => Scaffold(
		appBar: AppBar(title: const Text("About the Decameron")),
		body: Container(
			decoration: const BoxDecoration(
	      image: DecorationImage(
	      	image: backgroundImage,
	      	fit: BoxFit.cover
      	)
    	),
    	alignment: Alignment.center,
			child: SingleChildScrollView(
				child: FractionallySizedBox(
					widthFactor: 2/3,
					child: Container(
						color: const Color(0x55000000),
						child: Column(
							mainAxisSize: MainAxisSize.min,
							children: [
								const SizedBox(height: 25),
								Text(
									// ignore: lines_longer_than_80_chars
									"Storytelling makes us human. Stories capture the most powerful and contradictory feelings that we experience. When we tell a story, we become creators of the world.\nWe surprise ourselves with what we surrender, what we shape, and what we share.\nWe become comrades talking around a fire, a place of warmth and comfort.\nWe whisper in each other’s ears.",
									style: getStyle(context),
								),
								const SizedBox(height: 50),
								Text(
									// ignore: lines_longer_than_80_chars
									"As the corona virus spread and the world shut down, the Ramaz community created\n\"By the Campfire: Twice-Told Tales\", inspired by the Decameron, as a way to come together through storytelling in all its forms.",
									style: getStyle(context),
								),
								const SizedBox(height: 25),
								Text(
									// ignore: lines_longer_than_80_chars
									"This website provides a space for sharing those stories, and listening to those of others. Click on a story by the campfire to hear it being shared, or record yourself telling your own.",
									style: getStyle(context),
								),
								const SizedBox(height: 25),
							]
						)
					)
				)
			)
		)
	);
}
