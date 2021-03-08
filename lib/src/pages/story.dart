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
	bool isLoading = false;

	bool get needsApproval => 
		Models.instance.user.isModerator && !widget.story.isApproved;

	@override
	void initState() {
		super.initState();
		initVideo();
	}

	@override
	void dispose() {
		controller.dispose();
		super.dispose();
	}

	Future<void> initVideo() async {
		if (!widget.story.hasVideo) {
			return;
		}
		final String url = await Models.instance.stories.getVideoUrl(widget.story);
		await controller.initialize(url);
	}

	Future<void> approve() async {
		setState(() => isLoading = true);
		await Models.instance.moderator.approveStory(widget.story);
		setState(() => isLoading = false);
		Navigator.of(context).pop();
	}

	Future<void> delete() async {
		final bool confirmation = await showDialog(
			context: context, 
			builder: (_) => AlertDialog(
				title: const Text("Confirm"),
				content: const Text(
					"Are you sure you want to delete this story? This action cannot be undone."
				),
				actions: [
					TextButton(
						child: const Text("Cancel"), 
						onPressed: () => Navigator.of(context).pop(false)
					),
					ElevatedButton(
						child: const Text("OK"), 
						onPressed: () => Navigator.of(context).pop(true)
					),
				]
			)
		);
		if (confirmation == true) {
			await Models.instance.moderator.deleteStory(widget.story);
			Navigator.of(context).pop();
		}
	}

	@override
	Widget build(BuildContext context) => Scaffold(
		appBar: AppBar(
			title: const Text("View story"),
			actions: [
				if (Models.instance.user.isModerator)
					PopupMenuButton<bool>(
						icon: const Icon(Icons.more_vert),
						itemBuilder: (_) => const [
							 PopupMenuItem(value: true, child: Text("Delete story")),
						],
						onSelected: (bool value) {
							if (value == true) {
								delete();
							}
						}
					)
			]
		),
		floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
		floatingActionButton: !needsApproval ? null : FloatingActionButton.extended(
			icon: !isLoading 
				? const Icon(Icons.approval)
				: CircularProgressIndicator(
					valueColor: AlwaysStoppedAnimation(
						Theme.of(context).colorScheme.onSecondary
					),
				),
			label: const Text("Approve this story"),
			onPressed: approve
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
								.copyWith(fontFamily: "Spectral", fontWeight: FontWeight.w800)
						),              
						const SizedBox(height: 30),
						if (widget.story.hasVideo)
							VideoPlayer(controller),
						Row(
							mainAxisAlignment: MainAxisAlignment.spaceBetween,
							children: [
								Text(formatDateTime(context, widget.story.createdAt)),
								Text("By: ${widget.story.author}"),
							]
						),
						const SizedBox(height: 50),
						if (widget.story.hasVideo) Align(
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
						if (showTranscript || !widget.story.hasVideo) Text(widget.story.text),
					]
				)
			)
		)
	);
}
