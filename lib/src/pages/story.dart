import "package:flutter/material.dart";
import "package:chewie/chewie.dart";
import "package:video_player/video_player.dart";

import "package:decameron/data.dart";
import "package:decameron/models.dart";

class StoryPage extends StatefulWidget {
	final Story story;
	const StoryPage(this.story);

	@override
	StoryPageState createState() => StoryPageState();
}

class StoryPageState extends State<StoryPage> {
	Future<ChewieController> controllerFuture;

	@override
	void initState() {
		super.initState();
		controllerFuture = getController();		
	}

	Future<ChewieController> getController() async {
		final String url = await Models.instance.stories.getVideoUrl(widget.story);
		final VideoPlayerController controller = 
			VideoPlayerController.network(url);
		await controller.initialize();
		return ChewieController(videoPlayerController: controller);
	}

	@override
	Widget build(BuildContext context) => Scaffold(
		appBar: AppBar(title: const Text("View story")),
		body: ListView(
			children: [
				AspectRatio(
					aspectRatio: 1.5, 
					child: FutureBuilder<ChewieController>(
						future: controllerFuture,
						builder: (_, AsyncSnapshot snapshot) => snapshot.hasData
							? Chewie(controller: snapshot.data)
							: const CircularProgressIndicator(),
					)
				)
			]
		)
	);
}
