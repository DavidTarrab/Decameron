import "package:flutter/material.dart";

import "package:decameron/data.dart";
import "package:decameron/models.dart";
import "package:decameron/widgets.dart";

String formatDateTime(BuildContext context, DateTime dateTime) {
	final MaterialLocalizations locale = MaterialLocalizations.of(context);
	final TimeOfDay timeOfDay = TimeOfDay.fromDateTime(dateTime);
	String result = locale.formatCompactDate(dateTime);
	result += ", ";
	result += locale.formatTimeOfDay(timeOfDay);
	return result;
}

class StoryPage extends StatefulWidget {
	final Story story;
	const StoryPage(this.story);

	@override
	StoryPageState createState() => StoryPageState();
}

class StoryPageState extends State<StoryPage> {
	final VideoController controller = VideoController();
	bool showTranscript = false;

	bool get needsApproval => 
		Models.instance.user.isModerator && !widget.story.isApproved;

	@override
	void initState() {
		super.initState();
		initVideo();
	}

	Future<void> initVideo() async {
		final String url = await Models.instance.stories.getVideoUrl(widget.story);
		await controller.initialize(url);
	}

	@override
	Widget build(BuildContext context) => Scaffold(
		appBar: AppBar(title: const Text("View story")),
		floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
		floatingActionButton: !needsApproval ? null : FloatingActionButton.extended(
			icon: const Icon(Icons.approval),
			label: const Text("Approve this story"),
			onPressed: () => Models.instance.moderator.approveStory(widget.story),
		),
		body: Center(
			child: ConstrainedBox(
				constraints: const BoxConstraints(maxWidth: 750),
				child: ListView(
					padding: const EdgeInsets.all(10),
					children: [
						Text(
							widget.story.title,
							textAlign: TextAlign.center,
							style: Theme.of(context).textTheme.headline3
						),              
						Center(
						  // TODO: view author's other stories
							// child: TextButton(
								// onPressed: null,
								child: Text(
									"By: ${widget.story.author}",
									style: Theme.of(context).textTheme.headline5,
								)
							// )
						),
						const SizedBox(height: 20),
						Text(
							widget.story.firstSentence,
							textAlign: TextAlign.center,
							style: Theme.of(context).textTheme.headline4
								.copyWith(color: Colors.lightBlue [700]),
						),
						const SizedBox(height: 10),
						VideoPlayer(controller),
						Text(formatDateTime(context, widget.story.createdAt)),
						const SizedBox(height: 10),
						Align(
							alignment: Alignment.centerLeft, 
							child: TextButton(
								onPressed: () => setState(() => showTranscript = !showTranscript),
								child: Row(
									mainAxisSize: MainAxisSize.min,
									children: [
										Icon(showTranscript ? Icons.arrow_drop_up : Icons.arrow_drop_down),
										const Text("Show transcript"),
									]
								)
							)
						),
						if (showTranscript) Text(widget.story.text),
					]
				)
			)
		)
	);
}
